package com.liferay.commerce.demo.plan.renderer;

import com.liferay.asset.kernel.service.AssetEntryLocalService;
import com.liferay.asset.kernel.service.AssetVocabularyLocalService;
import com.liferay.commerce.demo.plan.renderer.configuration.PlanRendererConfiguration;
import com.liferay.commerce.demo.plan.renderer.display.context.RendererDisplayContext;
import com.liferay.commerce.price.CommerceProductPriceCalculation;
import com.liferay.commerce.product.catalog.CPCatalogEntry;
import com.liferay.commerce.product.content.render.CPContentRenderer;
import com.liferay.commerce.product.service.CPDefinitionLocalService;
import com.liferay.commerce.product.service.CPDefinitionSpecificationOptionValueLocalService;
import com.liferay.commerce.product.service.CPOptionCategoryLocalService;
import com.liferay.commerce.product.service.CPSpecificationOptionLocalService;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * @author Jeff Handa
 */
@Component(
        configurationPid = "com.liferay.commerce.demo.plan.renderer.configuration.PlanRendererConfiguration",
        immediate = true,
        property = {
                "commerce.product.content.renderer.key=" + PlanCPContentRenderer.KEY,
                "commerce.product.content.renderer.type=grouped",
                "commerce.product.content.renderer.type=simple",
                "commerce.product.content.renderer.type=virtual"
        },
        service = CPContentRenderer.class
)
public class PlanCPContentRenderer implements CPContentRenderer {

    public static final String KEY = "plan-renderer";

    @Override
    public String getKey() {
        return KEY;
    }

    @Override
    public String getLabel(Locale locale) {
        ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
                "content.Language", locale, getClass());

        return LanguageUtil.get(resourceBundle, "plan-renderer");
    }

    @Override
    public void render(CPCatalogEntry cpCatalogEntry, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

        RendererDisplayContext rendererDisplayContext =
                new RendererDisplayContext(httpServletRequest, _cpDefinitionLocalService,
                        _cpOptionCategoryLocalService, _cpSpecificationOptionLocalService,
                        _cpDefinitionSpecificationOptionValueLocalService,_assetEntryLocalService,
                        _assetVocabularyLocalService);

        httpServletRequest.setAttribute("commerceProductPriceCalculation", _commerceProductPriceCalculation);
        httpServletRequest.setAttribute("cpCatalogEntry", cpCatalogEntry);
        httpServletRequest.setAttribute("cpInstanceHelper", _cpInstanceHelper);
        httpServletRequest.setAttribute("rendererDisplayContext", rendererDisplayContext);
        httpServletRequest.setAttribute(PlanRendererConfiguration.class.getName(), _configuration);

        _jspRenderer.renderJSP(
                _servletContext, httpServletRequest, httpServletResponse,
                "/render/view.jsp");

    }

    @Activate
    @Modified
    protected void activate(Map<String, Object> properties) {
        _configuration = ConfigurableUtil.createConfigurable(
                PlanRendererConfiguration.class, properties);
    }
    private volatile PlanRendererConfiguration _configuration;

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