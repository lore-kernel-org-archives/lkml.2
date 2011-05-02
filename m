Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab1EBWQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:16:50 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2354 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1EBWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:16:49 -0400
Subject: Re: [PATCH] drivers/acpi/utils.c: Fixed coding style issues
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
To: Len Brown <lenb@kernel.org>, Nicolas Kaiser <nikai@nikai.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1303402099.11855.9.camel@ks-ubuntu>
References: <1303341624.11397.2.camel@ks-ubuntu>
	 <20110421102815.5abf133e@absol.kitzblitz>
	 <1303402099.11855.9.camel@ks-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 17:16:45 -0500
Message-ID: <1304374605.1619.4.camel@ks-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2011-04-21 at 11:08 -0500, Karthigan Srinivasan wrote:

Len - I submitted this patch on 4/21 and have not received any
acknowledgement. I am re-submitting it again. Please review and approve.

Best Regards,
Karthigan Srinivasan.

====

Fixed brace and comment coding style issues is code.

Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
---
 drivers/acpi/utils.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index b002a47..76eaac2 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -99,9 +99,8 @@ acpi_extract_package(union acpi_object *package,
 
 		union acpi_object *element = &(package->package.elements[i]);
 
-		if (!element) {
+		if (!element)
 			return AE_BAD_DATA;
-		}
 
 		switch (element->type) {
 
@@ -185,9 +184,8 @@ acpi_extract_package(union acpi_object *package,
 		u8 **pointer = NULL;
 		union acpi_object *element = &(package->package.elements[i]);
 
-		if (!element) {
+		if (!element)
 			return AE_BAD_DATA;
-		}
 
 		switch (element->type) {
 
@@ -303,9 +301,8 @@ acpi_evaluate_reference(acpi_handle handle,
 	u32 i = 0;
 
 
-	if (!list) {
+	if (!list)
 		return AE_BAD_PARAMETER;
-	}
 
 	/* Evaluate object. */
 
@@ -337,9 +334,9 @@ acpi_evaluate_reference(acpi_handle handle,
 		goto end;
 	}
 
-	if (package->package.count > ACPI_MAX_HANDLES) {
+	if (package->package.count > ACPI_MAX_HANDLES)
 		return AE_NO_MEMORY;
-	}
+
 	list->count = package->package.count;
 
 	/* Extract package data. */
@@ -373,7 +370,7 @@ acpi_evaluate_reference(acpi_handle handle,
       end:
 	if (ACPI_FAILURE(status)) {
 		list->count = 0;
-		//kfree(list->handles);
+		/* kfree(list->handles); */
 	}
 
 	kfree(buffer.pointer);
-- 
1.7.1





