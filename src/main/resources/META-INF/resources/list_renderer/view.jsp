<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/META-INF/resources/init.jsp" %>

<%

    CommerceProductPriceCalculation commerceProductPriceCalculation = (CommerceProductPriceCalculation)request.getAttribute("commerceProductPriceCalculation");
    CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
    CPDataSourceResult cpDataSourceResult = (CPDataSourceResult)request.getAttribute(CPWebKeys.CP_DATA_SOURCE_RESULT);
    List<CPCatalogEntry> cpCatalogEntries = cpDataSourceResult.getCPCatalogEntries();
    CommerceContext commerceContext = (CommerceContext)request.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);
    RendererDisplayContext rendererDisplayContext = (RendererDisplayContext)request.getAttribute("rendererDisplayContext");
%>

<style>

    .compare-container{
        display: flex;
        align-items: center;
        justify-content: center;
        padding-bottom: 0.5em;
    }

    .product-list{
        display:flex;
        flex-wrap:wrap;
        justify-content: center;
    }

    .product-download {
        padding-top: 1em;
        padding-bottom: 1em;

    }

    .product-specs {
        border-top: 1px dashed;
        padding-top: 1em;
    }

    .learn-more-cta{
        padding: 1em;
    }

</style>

<c:choose>
    <c:when test="<%= !cpCatalogEntries.isEmpty() %>">
        <div class="product-list">
        <%
            for (CPCatalogEntry cpCatalogEntry : cpCatalogEntries) {


                String friendlyURL = cpContentHelper.getFriendlyURL(cpCatalogEntry, themeDisplay);
                CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);
                long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();
                CPMedia cpMedia = cpContentHelper.getImages(cpDefinitionId, themeDisplay).get(0);

                //Get the Plan Overview and the Cost & Benefit Specifications and pick out the specs that are meant
                //to be displayed in the Plan Summary section
                List<CPDefinitionSpecificationOptionValue> planSummaryItems = new ArrayList<CPDefinitionSpecificationOptionValue>();
                List<CPDefinitionSpecificationOptionValue> planOverviewItems = rendererDisplayContext.getSpecificationsByGroup(cpDefinitionId, "plan-overview");
                List<CPDefinitionSpecificationOptionValue> costItems = rendererDisplayContext.getSpecificationsByGroup(cpDefinitionId, "cost-benefits");

                for (CPDefinitionSpecificationOptionValue item: costItems){
                    boolean displayInPlanSummary = (boolean)item.getCPSpecificationOption().getExpandoBridge().getAttribute(PlanRendererConstants.DISPLAY_IN_PLAN_SUMMARY);
                    if (displayInPlanSummary){
                        planSummaryItems.add(item);
                    }
                }

                for (CPDefinitionSpecificationOptionValue item: planOverviewItems){
                    boolean displayInPlanSummary = (boolean)item.getCPSpecificationOption().getExpandoBridge().getAttribute(PlanRendererConstants.DISPLAY_IN_PLAN_SUMMARY);
                    if (displayInPlanSummary){
                        planSummaryItems.add(item);
                    }
                }

                List<CPMedia> cpAttachmentFileEntries = cpContentHelper.getCPAttachmentFileEntries(cpDefinitionId, themeDisplay);


                CommerceMoney price = null;
                try {
                    price = commerceProductPriceCalculation.getCPDefinitionMinimumPrice(cpDefinitionId, commerceContext);
                } catch (PortalException e) {
                    e.printStackTrace();
                }

                //Color code the top of the product cards based on the plan name.
                String topBarColor = "blue";
                String productName = cpCatalogEntry.getName();

                if (productName.toLowerCase().contains("bronze")){
                    topBarColor = "#f08811";
                }else if (productName.toLowerCase().contains("silver")){
                    topBarColor = "#C0C0C0";
                }else if (productName.toLowerCase().contains("gold")){
                    topBarColor = "#F2B90D";
                }else if (productName.toLowerCase().contains("platinum")){
                    topBarColor = "#949494";
                }
        %>
            <div class="col-12 col-md-3 pt-2 pb-2">
                <div class="card card-lg shadow-hover product-card">
                    <div class="card-body  text-center" style="border-top: 8px solid <%= topBarColor%>;">

                        <!-- Product Compare -->
                        <div class="compare-container">
                            <commerce-ui:compare-checkbox
                                    CPCatalogEntry="<%= cpCatalogEntry %>"
                                    label='<%= LanguageUtil.get(resourceBundle, "compare") %>'
                            />
                        </div>

                        <!-- Product Name -->
                        <h2><a href="<%= friendlyURL%>"><%= cpCatalogEntry.getName() %></a></h2>

                        <!-- Product Image -->
                        <div id="<portlet:namespace />thumbs-container">

                            <div class="card thumb" data-url="<%= HtmlUtil.escapeAttribute(cpMedia.getURL()) %>">
                                <a href="<%= friendlyURL%>">
                                    <img class="center-block img-fluid" src="<%= HtmlUtil.escapeAttribute(cpMedia.getURL()) %>" />
                                </a>
                            </div>

                        </div>

                        <!-- Product Short Description -->
                        <p class="plan-description"><%= cpCatalogEntry.getShortDescription()%></p>

                        <!-- Price -->
                        <c:choose>
                            <c:when test="<%= price.getPrice().intValue() != 0 %>">
                                <commerce-ui:price
                                        compact="<%= true %>"
                                        CPCatalogEntry="<%= cpCatalogEntry %>"
                                />
                            </c:when>
                        </c:choose>

                        <!-- Product Attachment -- Displays a single document (whichever document has the lowest priority -->
                        <%
                            if (cpAttachmentFileEntries.size() > 0){
                                CPMedia curCPAttachmentFileEntry = cpAttachmentFileEntries.get(0);
                        %>
                        <div class="product-download">
                            <h4><%= curCPAttachmentFileEntry.getTitle()%></h4>

                            <aui:icon cssClass="icon-monospaced" image="download" markupView="lexicon" target="_blank"
                                      url="<%= curCPAttachmentFileEntry.getDownloadURL()%>" />
                        </div>
                        <%
                            }
                        %>

                        <!-- Plan Summary -- Displays specs that are associated with the Specification Group named 'Plan Summary' -->
                        <c:if test="<%= planSummaryItems.size() > 0 %>">
                            <h3 class="product-specs"><liferay-ui:message key="plan-summary" /></h3>
                            <table class="table table-striped">
                            <%
                                for (CPDefinitionSpecificationOptionValue cpDefinitionSpecificationOptionValue : planSummaryItems) {
                                    CPSpecificationOption cpSpecificationOption = cpDefinitionSpecificationOptionValue.getCPSpecificationOption();
                                    String specLabel = cpSpecificationOption.getTitle(languageId);
                                    String specValue = cpDefinitionSpecificationOptionValue.getValue(languageId);
                            %>
                                <tr>
                                    <td class="spec-table-cell">
                                        <dl>
                                            <dt class="specification-term"><%= specLabel%></dt>
                                            <dd class="specification-desc"><%= specValue%></dd>
                                        </dl>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                            </table>
                        </c:if>

                        <!-- Call to Action -->
                        <div class="learn-more-cta">
                            <a class="commerce-button commerce-button--outline w-50" href="<%= friendlyURL %>">
                                <liferay-ui:message key="learn-more" />
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <%
            }
        %>
        </div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-info">
            <liferay-ui:message key="no-products-were-found" />
        </div>
    </c:otherwise>
</c:choose>