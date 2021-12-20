package com.liferay.commerce.demo.plan.renderer.configuration;

import aQute.bnd.annotation.metatype.Meta;
import com.liferay.portal.configuration.metatype.annotations.ExtendedObjectClassDefinition;

/**
 * @author Jeff Handa
 */
@ExtendedObjectClassDefinition(
        category = "plan-renderer",
        scope = ExtendedObjectClassDefinition.Scope.GROUP
)
@Meta.OCD(
        id = "com.liferay.commerce.demo.plan.renderer.configuration.PlanRendererConfiguration",
        localization = "content/Language", name = "plan-renderer-configuration-name"
)
public interface PlanRendererConfiguration {
    @Meta.AD(
            deflt = "request-a-quote", description = "request-a-quote-page-description",
            name = "request-a-quote-page-name", required = false
    )
    public String requestQuotePage();

    @Meta.AD(
            deflt = "request-a-quote", description = "request-a-quote-caption-description",
            name = "request-a-quote-caption-name", required = false
    )
    public String requestQuoteCaption();
}
