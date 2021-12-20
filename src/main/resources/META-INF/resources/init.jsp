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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>

<%@ taglib uri="http://liferay.com/tld/commerce" prefix="liferay-commerce" %>
<%@ taglib uri="http://liferay.com/tld/commerce-product" prefix="liferay-commerce-product" %>

<%@ taglib uri="http://liferay.com/tld/commerce-ui" prefix="commerce-ui" %>

<%@ taglib uri="http://liferay.com/tld/adaptive-media-image" prefix="liferay-adaptive-media" %>
<%@ taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="com.liferay.commerce.context.CommerceContext" %>

<%@ page import="com.liferay.commerce.constants.CommerceWebKeys" %>

<%@ page import="com.liferay.commerce.currency.model.CommerceMoney" %>

<%@ page import="com.liferay.commerce.demo.plan.renderer.configuration.PlanRendererConfiguration" %>
<%@ page import="com.liferay.commerce.demo.plan.renderer.constants.PlanRendererConstants" %>
<%@ page import="com.liferay.commerce.demo.plan.renderer.display.context.RendererDisplayContext" %>

<%@ page import="com.liferay.commerce.price.CommerceProductPriceCalculation" %>

<%@ page import="com.liferay.commerce.product.content.util.CPContentHelper" %>
<%@ page import="com.liferay.commerce.product.content.constants.CPContentWebKeys" %>

<%@ page import="com.liferay.commerce.product.catalog.CPCatalogEntry" %>
<%@ page import="com.liferay.commerce.product.catalog.CPSku" %>

<%@ page import="com.liferay.commerce.product.constants.CPWebKeys" %>

<%@ page import="com.liferay.commerce.product.content.util.CPMedia" %>

<%@ page import="com.liferay.commerce.product.data.source.CPDataSourceResult" %>

<%@ page import="com.liferay.commerce.product.model.CPDefinitionSpecificationOptionValue" %>
<%@ page import="com.liferay.commerce.product.model.CPOptionCategory" %>
<%@ page import="com.liferay.commerce.product.model.CPSpecificationOption" %>

<%@ page import="com.liferay.portal.kernel.exception.PortalException" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>

<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HashMapBuilder" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>

<%@ page import="com.liferay.petra.string.StringPool" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>


<liferay-frontend:defineObjects />
<liferay-theme:defineObjects />
<portlet:defineObjects />

<%
    String languageId = LanguageUtil.getLanguageId(locale);
%>