#pragma checksum "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "58db0ce9c12e1a272b5a9ba4951f5b1d35a8c33b"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Report_RepairModelReport), @"mvc.1.0.view", @"/Views/Report/RepairModelReport.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/_ViewImports.cshtml"
using team011;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/_ViewImports.cshtml"
using team011.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"58db0ce9c12e1a272b5a9ba4951f5b1d35a8c33b", @"/Views/Report/RepairModelReport.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"b6eceadba93b855566579e663d5cd9e6ca14d499", @"/Views/_ViewImports.cshtml")]
    public class Views_Report_RepairModelReport : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#nullable restore
#line 4 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
  
    var modelrepairreports = ViewBag.ModelRepairReport as List<ModelRepairReport>;
    string tempVehicleTypeforModel=ViewBag.tempVehicleType;
    string tempManufacturerNameforModel=ViewBag.tempManufacturerNameforModel;

#line default
#line hidden
#nullable disable
            WriteLiteral(@"
<h1>Report - Repair</h1>

<div class=""btn-group mt-3"">

    <button type=""button"" class=""btn btn-primary dropdown-toggle"" data-toggle=""dropdown"" aria-haspopup=""true"" aria-expanded=""false"">
        Get Reports
    </button>
    <div class=""dropdown-menu"">
        <a class=""dropdown-item"" href=""/Report/ColorReport"">Sales by Color</a>
        <a class=""dropdown-item"" href=""/Report/VehicleTypeReport"">Sales by Vehicle Type</a>
        <a class=""dropdown-item"" href=""/Report/ManufacturerReport"">Sales by Manufacturer</a>
        <a class=""dropdown-item"" href=""/Report/GrossCustomerIncomeReport"">Gross Customer Income</a>
        <a class=""dropdown-item"" href=""/Report/RepairReport"">Repair Reports</a>
        <a class=""dropdown-item"" href=""/Report/BelowCostSaleReport"">Below Cost Sales</a>
        <a class=""dropdown-item"" href=""/Report/AverageInventoryTimeReport"">View Average Inventory Time</a>
        <a class=""dropdown-item"" href=""/Report/PartReport"">Parts Statistics</a>
        <a class=""dropdown-item"" href=""/Report/M");
            WriteLiteral("onthlySaleReport\">Monthly Sales</a>\n    </div>\n</div>\n\n<p style=\"line-height:1.5em;\"></p>\n\n<a");
            BeginWriteAttribute("href", " href=\"", 1463, "\"", 1567, 1);
#nullable restore
#line 32 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
WriteAttributeValue("", 1470, Url.Action("RepairTypeReport","Report", new { @ManufacturerName = tempManufacturerNameforModel}), 1470, 97, false);

#line default
#line hidden
#nullable disable
            EndWriteAttribute();
            WriteLiteral(" class=\"btn btn-primary btn-sm active\" role=\"button\" aria-pressed=\"true\">Back to ");
#nullable restore
#line 32 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                                                                                                                                                                                       Write(tempManufacturerNameforModel);

#line default
#line hidden
#nullable disable
            WriteLiteral(" ");
#nullable restore
#line 32 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                                                                                                                                                                                                                     Write(tempVehicleTypeforModel);

#line default
#line hidden
#nullable disable
            WriteLiteral("</a>\n\n    <h1>Model</h1>\n\n    <div");
            BeginWriteAttribute("id", " id=\"", 1737, "\"", 1742, 0);
            EndWriteAttribute();
            WriteLiteral(@" style=""padding-top:5px"">
        <table id=""tblrepairbymodel"" class=""table table-striped table-bordered"" style=""width:100%"">
            <thead>
                <tr>
                    <th>
                        Model Name
                    </th>
                    <th>
                        Number of Repairs
                    </th>
                    <th>
                        Parts Total Cost
                    </th>
                    <th>
                        Labor Total Cost
                    </th>
                    <th>
                        Repair Total
                    </th>
                </tr>
            </thead>
            <tbody");
            BeginWriteAttribute("id", " id=\"", 2422, "\"", 2427, 0);
            EndWriteAttribute();
            WriteLiteral(">\n\n\n");
#nullable restore
#line 60 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                 foreach (var r in modelrepairreports)
                {


#line default
#line hidden
#nullable disable
            WriteLiteral("                    <tr>\n                        <th>\n                            ");
#nullable restore
#line 65 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                       Write(r.model_name);

#line default
#line hidden
#nullable disable
            WriteLiteral("\n                        </th>\n                        <td>\n                            ");
#nullable restore
#line 68 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                       Write(r.repair_count);

#line default
#line hidden
#nullable disable
            WriteLiteral("\n                        </td>\n                        <td>\n                            ");
#nullable restore
#line 71 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                       Write(r.total_parts_cost);

#line default
#line hidden
#nullable disable
            WriteLiteral("\n                        </td>\n                        <td>\n                            ");
#nullable restore
#line 74 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                       Write(r.total_labor_charge);

#line default
#line hidden
#nullable disable
            WriteLiteral("\n                        </td>\n                        <td>\n                            ");
#nullable restore
#line 77 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"
                       Write(r.total_repair_cost);

#line default
#line hidden
#nullable disable
            WriteLiteral("\n                        </td>\n\n                    </tr>\n");
#nullable restore
#line 81 "/Users/TonyS/Project/cs6400-2021-03-fall/cs6400-2021-03-Team011/team011/team011/Views/Report/RepairModelReport.cshtml"

                }

#line default
#line hidden
#nullable disable
            WriteLiteral("\n\n\n\n            </tbody>\n        </table>\n\n    </div>\n    <script>$(\'#tblrepairbymodel\').DataTable({ \"order\": [], \"pageLength\": 100  } )</script>");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<dynamic> Html { get; private set; }
    }
}
#pragma warning restore 1591
