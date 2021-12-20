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
    CommerceContext commerceContext = (CommerceContext)request.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);
    CommerceProductPriceCalculation commerceProductPriceCalculation = (CommerceProductPriceCalculation)request.getAttribute("commerceProductPriceCalculation");
    CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
    RendererDisplayContext rendererDisplayContext = (RendererDisplayContext)request.getAttribute("rendererDisplayContext");

    PlanRendererConfiguration requestQuoteRendererConfiguration = (PlanRendererConfiguration) GetterUtil.getObject(request.getAttribute(PlanRendererConfiguration.class.getName()));
    CPCatalogEntry cpCatalogEntry = cpContentHelper.getCPCatalogEntry(request);
    CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);
    long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();

    //Create the Request a Quote URL and caption
    String requestQuoteCaption = requestQuoteRendererConfiguration.requestQuoteCaption();
    boolean isPublic = themeDisplay.getLayout().isPublicLayout();
    String groupName = themeDisplay.getSiteGroupName().toLowerCase();
    String requestQuotePage = requestQuoteRendererConfiguration.requestQuotePage();
    String requestQuoteUrl ="";
    if (isPublic){
        requestQuoteUrl = "/web/" + groupName + "/" + requestQuotePage;
    }else{
        requestQuoteUrl = "/group/" + groupName + "/" + requestQuotePage;
    }

    //Get price
    CommerceMoney price = null;
    try {
        price = commerceProductPriceCalculation.getCPDefinitionMinimumPrice(cpDefinitionId, commerceContext);
    } catch (PortalException e) {
        e.printStackTrace();
    }

%>

<style>
    .request-quote{
        display: flex;
        align-items: center;
        justify-content: center;
    }
</style>


<div class="mb-5 product-detail" id="<portlet:namespace /><%= cpDefinitionId %>ProductContent">
    <div class="row">
        <!-- Product Image Gallery -->
        <div class="col-12 col-md-6">
            <commerce-ui:gallery
                    CPDefinitionId="<%= cpDefinitionId %>"
                    namespace="<%= liferayPortletResponse.getNamespace() %>"
            />
        </div>

        <div class="col-12 col-md-6 d-flex flex-column justify-content-center">
            <!-- Product Compare -->
            <div class="mt-3">
                <commerce-ui:compare-checkbox
                        CPCatalogEntry="<%= cpCatalogEntry %>"
                        label='<%= LanguageUtil.get(resourceBundle, "compare") %>'
                />
            </div>

            <!-- Product Name -->
            <header>
                <h2 class="product-header-title"><%= HtmlUtil.escape(cpCatalogEntry.getName()) %></h2>
            </header>

            <!-- Product Description -->
            <p class="mt-3 product-description"><%= cpCatalogEntry.getDescription() %></p>

            <!-- Product  Subscription-->
            <h4 class="commerce-subscription-info mt-3 w-100">
                <c:if test="<%= cpSku != null %>">
                    <commerce-ui:product-subscription-info
                            CPInstanceId="<%= cpSku.getCPInstanceId() %>"
                    />
                </c:if>

                <span data-text-cp-instance-subscription-info></span>
                <span data-text-cp-instance-delivery-subscription-info></span>
            </h4>

            <!-- Product  Options-->
            <div class="product-detail-options">
                <form data-senna-off="true" name="fm">
                    <%= cpContentHelper.renderOptions(renderRequest, renderResponse) %>
                </form>

                <liferay-portlet:actionURL name="/cp_content_web/check_cp_instance" portletName="com_liferay_commerce_product_content_web_internal_portlet_CPContentPortlet" var="checkCPInstanceURL">
                    <portlet:param name="cpDefinitionId" value="<%= String.valueOf(cpDefinitionId) %>" />
                </liferay-portlet:actionURL>

                <liferay-frontend:component
                        context='<%=
						HashMapBuilder.<String, Object>put(
							"actionURL", checkCPInstanceURL
						).put(
							"cpDefinitionId", cpDefinitionId
						).put(
							"namespace", liferayPortletResponse.getNamespace()
						).build()
					%>'
                        module="product_detail/render/js/ProductOptionsHandler"
                />
            </div>

            <c:choose>
                <c:when test="<%= price.getPrice().intValue() == 0 %>">

                    <div class="request-quote">
                        <a class="commerce-button commerce-button"  href="<%= requestQuoteUrl %>">
                                <liferay-ui:message key="<%= requestQuoteCaption%>" />
                        </a>
                    </div>

                </c:when>
                <c:otherwise>

                    <!-- Product  Price  -- Only display if it is greater than $0.00 -->
                    <div class="mt-3 price-container row">
                        <div class="col-lg-9 col-sm-12 col-xl-6">
                            <commerce-ui:price
                                    CPCatalogEntry="<%= cpCatalogEntry %>"
                                    namespace="<%= liferayPortletResponse.getNamespace() %>"
                            />
                        </div>
                    </div>

                    <c:if test="<%= cpSku != null %>">

                        <liferay-commerce:tier-price
                                CPInstanceId="<%= cpSku.getCPInstanceId() %>"
                                taglibQuantityInputId='<%= liferayPortletResponse.getNamespace() + cpDefinitionId + "Quantity" %>'
                        />
                    </c:if>

                    <div class="align-items-center d-flex mt-3 product-detail-actions">
                        <commerce-ui:add-to-cart
                                CPCatalogEntry="<%= cpCatalogEntry %>"
                                namespace="<%= liferayPortletResponse.getNamespace() %>"
                                options='<%= "[]" %>'
                        />

                        <commerce-ui:add-to-wish-list
                                CPCatalogEntry="<%= cpCatalogEntry %>"
                                large="<%= true %>"
                        />
                    </div>

                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%
    List<CPMedia> cpAttachmentFileEntries = cpContentHelper.getCPAttachmentFileEntries(cpDefinitionId, themeDisplay);
    List<CPDefinitionSpecificationOptionValue> planOverviewItems = rendererDisplayContext.getSpecificationsByGroup(cpDefinitionId, "plan-overview");
    List<CPDefinitionSpecificationOptionValue> costItems = rendererDisplayContext.getSpecificationsByGroup(cpDefinitionId, "cost-benefits");
%>

<div class="container">
    <div class="row">
        <div class="col-sm">

            <c:if test="<%= planOverviewItems.size() > 0 %>">
                <commerce-ui:panel
                    elementClasses="flex-column mb-3"
                    title='<%= LanguageUtil.get(resourceBundle, "plan-overview") %>'
                >

                    <dl class="specification-list">

                        <%
                            for (CPDefinitionSpecificationOptionValue cpDefinitionSpecificationOptionValue : planOverviewItems) {
                                CPSpecificationOption cpSpecificationOption = cpDefinitionSpecificationOptionValue.getCPSpecificationOption();
                        %>

                            <dt class="specification-term">
                                <%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %>
                            </dt>
                            <dd class="specification-desc">
                                <%= HtmlUtil.escape(cpDefinitionSpecificationOptionValue.getValue(languageId)) %>
                            </dd>

                        <%
                            }
                        %>

                    </dl>
                </commerce-ui:panel>
            </c:if>

        </div>

        <div class="col-sm">

            <c:if test="<%= costItems.size() > 0 %>">
                <commerce-ui:panel
                        elementClasses="flex-column mb-3"
                        title='<%= LanguageUtil.get(resourceBundle, "cost-benefits") %>'
                >
                    <dl class="specification-list">

                        <%
                            for (CPDefinitionSpecificationOptionValue cpDefinitionSpecificationOptionValue : costItems) {
                                CPSpecificationOption cpSpecificationOption = cpDefinitionSpecificationOptionValue.getCPSpecificationOption();
                        %>

                        <dt class="specification-term">
                            <%= HtmlUtil.escape(cpSpecificationOption.getTitle(languageId)) %>
                        </dt>
                        <dd class="specification-desc">
                            <%= HtmlUtil.escape(cpDefinitionSpecificationOptionValue.getValue(languageId)) %>
                        </dd>

                        <%
                            }
                        %>

                    </dl>
                </commerce-ui:panel>
            </c:if>

        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <c:if test="<%= !cpAttachmentFileEntries.isEmpty() %>">
            <commerce-ui:panel
                    elementClasses="mb-3"
                    title='<%= LanguageUtil.get(resourceBundle, "attachments") %>'
            >
                <dl class="specification-list">

                    <%
                        int attachmentsCount = 0;

                        for (CPMedia curCPAttachmentFileEntry : cpAttachmentFileEntries) {
                    %>

                    <dt class="specification-term">
                        <%= HtmlUtil.escape(curCPAttachmentFileEntry.getTitle()) %>
                    </dt>
                    <dd class="specification-desc">
                        <aui:icon cssClass="icon-monospaced" image="download" markupView="lexicon" target="_blank" url="<%= curCPAttachmentFileEntry.getDownloadURL() %>" />
                    </dd>

                    <%
                        attachmentsCount = attachmentsCount + 1;
                    %>

                    <c:if test="<%= attachmentsCount >= 2 %>">
                        <dt class="specification-empty specification-term"></dt>
                        <dd class="specification-desc specification-empty"></dd>

                        <%
                            attachmentsCount = 0;
                        %>

                    </c:if>

                    <%
                        }
                    %>

                </dl>
            </commerce-ui:panel>
        </c:if>
        </div>
    </div>
</div>