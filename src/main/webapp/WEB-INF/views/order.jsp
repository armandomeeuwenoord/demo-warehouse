<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
	<head>
		<title>Order</title>
		<link rel="stylesheet" href="<c:url value="/resources/blueprint/screen.css" />" type="text/css" media="screen, projection">
		<%--<link rel="stylesheet" href="<c:url value="/resources/blueprint/print.css" />" type="text/css" media="print">--%>
		<!--[if lt IE 8]>
			<link rel="stylesheet" href="<c:url value="/resources/blueprint/ie.css" />" type="text/css" media="screen, projection">
		<![endif]-->
		<%--<link rel="stylesheet" href="<c:url value="/resources/popup.css" />" type="text/css" media="screen, projection">--%>
		<script type="text/javascript" src="<c:url value="/resources/jquery-1.4.min.js" /> "></script>
        <script type="text/javascript" src="<c:url value="/resources/json.min.js" /> "></script>
        <script type="text/javascript" src="<c:url value="/resources/canvas-all.js" /> "></script>
        <script>
            var sr =  JSON.parse('${not empty signedRequestJson?signedRequestJson:"{}"}');
            Sfdc.canvas(function() {
                // Setup the finalize
                if (sr.client.oauthToken){
                    $('#finalizeButton').click(finalizeHandler);
                    $('#finalizeButton').show();
                }
                else{
                    $('#finalizeButton').click(null);
                    $('#finalizeButton').hide();
                }
            });

            function finalizeHandler(){
                var invoiceUri=sr.context.links.sobjectUrl + "Invoice_Statement__c/${order.id}";
                var body = {"Status__c":"Shipped"};
                          alert(sr.client.instanceId);
                Sfdc.canvas.client.ajax(invoiceUri,{
                        token : sr.client,
                        method: 'PATCH',
                        contentType: "application/json",
                        data: JSON.stringify(body),
                        success : localUpdateHandler
                });
            }

            function localUpdateHandler(data){
                console.log("Status from remote salesforce call:", data);
                if (data.status === 200 || data.status === 204){
                  // Update local Order status.
                  $.ajax({
                      url : "/order/${order.id}",
                      type: "PUT",
                      data: JSON.stringify({status:"Shipped"}),
                      success: function() {
                          document.location.reload(true);
                      },
                      error: function(){
                        alert("Error occurred updating local status.");
                      },
                      contentType:"application/json"
                  });
                }
                else{
                    alert("Remote call to salesforce failed. Status: "+data.status+", Text: " + data.statusText);
                }
            }
            
            function getRoot() {
            	return sr.client.instanceUrl;
            }
        </script>


	</head>
	<body>
		<div class="container">
			<h2>
				Order <a href="#" onclick="window.top.location.href = getRoot() + '/${order.id}';"> <c:out value="${order.id}"/> </a>
			</h2>
			<div class="span-12 last">
                <p>Order Id: <c:out value="${order.orderId}"/></p>
                <p>Total: <c:out value="${order.total}"/></p>
                <p>Status: <c:out value="${order.status}"/></p>

                <h2>
                    Line Items
                </h2>
                <table>
                    <tr><th>ID</th><th>Line Item ID</th><th>Quantity</th><th>Unit Price</th><th>Total</th><th>Item</th></tr>
                    <c:forEach items="${order.lineItems}" var="li">
                        <tr>
                            <td><a href="#" onclick="window.top.location.href = getRoot() + '/${li.id}';"><c:out value="${li.id}"/></a></td>
                            <td><c:out value="${li.lineItemId}"/></td>
                            <td><c:out value="${li.quantity}"/></td>
                            <td><c:out value="${li.unitPrice}"/></td>
                            <td><c:out value="${li.total}"/></td>
                            <td><c:out value="${li.item}"/></td>
                        </tr>
                    </c:forEach>
                </table>
                <button onclick="location.href='/orderui'">Back</button>
			    <!--<c:if test="${order.status ne 'Shipped'}">-->
                    <button id="finalizeButton">Finalize</button>
                <!--</c:if>-->
			</div>
		</div>
	</body>
	<%--<script>--%>
	<%--$("#delete").click(function() {--%>
		<%--$.deleteJSON("/order/${order.orderId}", function(data) {--%>
			<%--alert("Deleted order ${order.orderId}");--%>
			<%--location.href = "/orderui";--%>
		<%--}, function(data) {--%>
			<%--alert("Error deleting order ${order.orderId}");--%>
		<%--});--%>
		<%--return false;				--%>
	<%--});--%>
	<%--</script>--%>
</html>
