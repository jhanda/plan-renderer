# Plan Product Renderer

![Freelancer](doc/preview.gif
)

## Usage

This product renderer is designed to support _services_ products, such as insurance, financial, or telecommunication 
products. In a Product Publisher, the products will be displayed side by side, with a summary of product specifications.  

This renderer is expecting that products will have _Product Specifications_ divided into two _Specification Groups_ 
(Plan Overview and Costs & Benefits).  To designate which Product Specifications should appear in the Plan Summary 
section, set the_Display in Plan Summary_ custom field on the Specifications.  The renderer will create this Custom 
Field when the module is deployed.  If you want to change the names of the Specification Groups or add additional 
Specification groups you will need to edit the view.jsp for the detail and list views.  

In many situations, the price for these services may not be immediately available for all customers. If there is no price
available for a product (price is equal to 0), the price and Add to Cart button will be replaced with a *Request a
Quote* button.  The button will direct you to a /request-a-quote page where you can present a form to capture relevant
details.

The caption on the button and the URL can be updated to support other use-cases such as *Request a Sample* or *Submit a
Bid*.  Configuration can be found under System Settings > Other > Plan Renderer

## Requirements

- Liferay Commerce 4.0.0

## Installation

- Download the `.jar` file in [releases](https://github.com/jhanda/plan-renderer/releases/tag/4.0.1) and
  deploy it into Liferay.

or

- Clone this repository, add it to a Liferay workspace and deploy it into Liferay.

## License

[MIT](LICENSE)
