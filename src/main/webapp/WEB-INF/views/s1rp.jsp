<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice Statement</title>
    <meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="<c:url value="/resources/blueprint/screen.css" />" type="text/css" media="screen, projection">
    <!--[if lt IE 8]>
    <link rel="stylesheet" href="<c:url value="/resources/blueprint/ie.css" />" type="text/css" media="screen, projection">
    <![endif]-->
    <script type="text/javascript" src="<c:url value="/resources/jquery-1.4.min.js" /> "></script>
    <script type="text/javascript" src="<c:url value="/resources/json.min.js" /> "></script>
    <script type="text/javascript" src="<c:url value="/resources/canvas-all.js" /> "></script>
    <script>
        var sr =  JSON.parse('${not empty signedRequestJson?signedRequestJson:"{}"}');
        Sfdc.canvas(function() {
            Sfdc.canvas.client.autogrow(sr.client, true);
        });

    </script>

    <style>
        #myTable {
            padding: 0px 0px 4px 0px;
        }

        #myTable td {
            border-bottom: 1px solid #CCCCCC;
        }

        .myCol {
            text-align: left;
            color: #4a4f5b;
            font-weight: bold;
        }

        .valueCol {
            padding-left:10px;
        }

        #bodyDiv {
            padding:0px;
            padding-top: 0px;
        }

        #lineItemTitle {
            font-size: 1.2em;
            font-weight: bold;
            padding-right: 10px;
        }

        #myPageBlockTable {
            padding:5px;
            background: #F8F8F8;
            border: 1px solid #CDCDCD;
            border-radius: 6px;
            border-top: 3px solid #998c7c;
        }

        #lineItemTable {
            border-right: 1px solid #CDCDCD;
            border-left: 1px solid #CDCDCD;
        }

        #lineItemTable th {
            background: #f2f3f3;
            border: 1px solid #CDCDCD;
            border-left: 0px;
            position: relative;
            bottom: 2px;
            padding-right: 5px;
            padding-left: 4px;
        }

        .span-12 {
            width:700px;
        }

        .myLineItemTableRow {
            background: white;
            border-bottom: 1px solid #CCCCCC;
        }

        .myLineItemTableRow td {
            padding: 4px 0px 4px 8px;
            border-bottom: 1px solid #CCCCCC;
        }
    </style>

</head>
<body>
<div id="bodyDiv" style="width:inherit;">
    <div class="container">
        <div>
            <div id="myPageBlockTable">
                <h2>Page Layout Preview - Click to Open</h2>
                <table id="myTable" width="100%">
                    <col width="20%">
                    <tr><td class="myCol">Invoice Statement:</td><td class="valueCol"><c:out value="${order.orderId}"/></td></tr>
                    <tr><td class="myCol">Invoice Statement Id:</td><td class="valueCol"><c:out value="${order.id}"/></td></tr>
                    <tr><td class="myCol">Total:</td><td class="valueCol"><c:out value="${order.total}"/></td></tr>
                    <tr><td class="myCol">Status:</td><td class="valueCol" valign="center"><c:out value="${order.status}"/>
                        <c:choose>
                            <c:when test="${order.status == 'Shipped'}">
                                <img src="/resources/images/shipped.png" />
                            </c:when>
                            <c:otherwise>
                                <img src="/resources/images/pending.png" />
                            </c:otherwise>
                        </c:choose>
                    </td></tr>
                </table>
                <h2 id="lineItemTitle">
                    Line Items
                </h2>
                <table id="lineItemTable">
                    <tr><th style="border-left:0px;">Line Item Name</th><th>Quantity</th><th>Unit Price</th><th>Total</th><th style="border-right:0px;">Item</th></tr>
                    <c:forEach items="${order.lineItems}" var="li">
                        <tr class="myLineItemTableRow">
                            <td><a href="#" onclick="window.top.location.href = getRoot() + '/${li.id}';"><c:out value="${li.lineItemId}"/></a></td>
                            <td><c:out value="${li.quantity}"/></td>
                            <td><c:out value="${li.unitPrice}"/></td>
                            <td><c:out value="${li.total}"/></td>
                            <td><c:out value="${li.item}"/></td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
