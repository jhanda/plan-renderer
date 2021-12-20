package com.liferay.commerce.demo.plan.renderer.list;

import com.liferay.asset.kernel.service.AssetEntryLocalService;
import com.liferay.asset.kernel.service.AssetVocabularyLocalService;
import com.liferay.commerce.demo.plan.renderer.display.context.RendererDisplayContext;
import com.liferay.commerce.price.CommerceProductPriceCalculation;
import com.liferay.commerce.product.constants.CPPortletKeys;
import com.liferay.commerce.product.content.render.list.CPContentListRenderer;
import com.liferay.commerce.product.service.CPDefinitionLocalService;
import com.liferay.commerce.product.service.CPDefinitionSpecificationOptionValueLocalService;
import com.liferay.commerce.product.service.CPOptionCategoryLocalService;
import com.liferay.commerce.product.service.CPSpecificationOptionLocalService;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * @author Jeff Handa
 */
@Component(

        immediate = true,
        property = {
                "commerce.product.content.list.renderer.key=" + PlanCPContentListRenderer.KEY,
                "commerce.product.content.list.renderer.order=600",
                "commerce.product.content.list.renderer.portlet.name=" + CPPortletKeys.CP_PUBLISHER_WEB,
                "commerce.product.content.list.renderer.portlet.name=" + CPPortletKeys.CP_SEARCH_RESULTS,
                "commerce.product.content.list.renderer.portlet.name=" + CPPortletKeys.CP_COMPARE_CONTENT_WEB
        },
        service = CPContentListRenderer.class
)
public class PlanCPContentListRenderer implements CPContentListRenderer {

        public static final String KEY = "plan-list";

        @Override
        public String getKey() {
                return KEY;
        }

        @Override
        public String getLabel(Locale locale) {
                ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
                        "content.Language", locale, getClass());

                return LanguageUtil.get(resourceBundle, "plan-list");
        }

        @Override
        public void render(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

                httpServletRequest.setAttribute("commerceProductPriceCalculation", _commerceProductPriceCalculation);
                httpServletRequest.setAttribute("cpInstanceHelper", _cpInstanceHelper);
                RendererDisplayContext rendererDisplayContext =
                        new RendererDisplayContext(httpServletRequest, _cpDefinitionLocalService,
                                _cpOptionCategoryLocalService, _cpSpecificationOptionLocalService,
                                _cpDefinitionSpecificationOptionValueLocalService,_assetEntryLocalService,
                                _assetVocabularyLocalService);

                httpServletRequest.setAttribute("rendererDisplayContext", rendererDisplayContext);

                _jspRenderer.renderJSP(
                        _servletContext, httpServletRequest, httpServletResponse,
                        "/list_renderer/view.jsp");
        }

        @Reference(
                target = "(osgi.web.symbolicname=com.liferay.commerce.demo.plan.renderer)"
        )
        private ServletContext _servletContext;

        @Reference
        private JSPRenderer _jspRenderer;

        @Reference
        private CommerceProductPriceCalculation _commerceProductPriceCalculation;

        @Reference
        private CPInstanceHelper _cpInstanceHelper;

        @Reference
        private CPDefinitionLocalService _cpDefinitionLocalService;

        @Reference
        private CPOptionCategoryLocalService _cpOptionCategoryLocalService ;

        @Reference
        private CPSpecificationOptionLocalService _cpSpecificationOptionLocalService;

        @Reference
        private CPDefinitionSpecificationOptionValueLocalService _cpDefinitionSpecificationOptionValueLocalService;

        @Reference
        private AssetEntryLocalService _assetEntryLocalService;

        @Reference
        private AssetVocabularyLocalService _assetVocabularyLocalService;
}