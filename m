Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1DTXU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:20:27 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7429 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1DTXUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:20:25 -0400
Subject: [PATCH] drivers/acpi/utils.c: Fixed coding style issues
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Karthigan Srinivasan <Karthigan.Srinivasan@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 18:20:24 -0500
Message-ID: <1303341624.11397.2.camel@ks-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e770496964bf749c30df8a19abbdfe0f79d64fb7 Mon Sep 17 00:00:00 2001
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Date: Wed, 20 Apr 2011 18:14:10 -0500
Subject: [PATCH] drivers/acpi/utils.c: Fixed coding style issues.

Fixed brace and comment coding style issues in code.

Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
---
 drivers/acpi/utils.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index b002a47..2cf81a1 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -99,9 +99,9 @@ acpi_extract_package(union acpi_object *package,
 
 		union acpi_object *element = &(package->package.elements[i]);
 
-		if (!element) {
+		if (!element) 
 			return AE_BAD_DATA;
-		}
+		
 
 		switch (element->type) {
 
@@ -185,9 +185,9 @@ acpi_extract_package(union acpi_object *package,
 		u8 **pointer = NULL;
 		union acpi_object *element = &(package->package.elements[i]);
 
-		if (!element) {
+		if (!element) 
 			return AE_BAD_DATA;
-		}
+		
 
 		switch (element->type) {
 
@@ -303,9 +303,9 @@ acpi_evaluate_reference(acpi_handle handle,
 	u32 i = 0;
 
 
-	if (!list) {
+	if (!list) 
 		return AE_BAD_PARAMETER;
-	}
+	
 
 	/* Evaluate object. */
 
@@ -337,9 +337,9 @@ acpi_evaluate_reference(acpi_handle handle,
 		goto end;
 	}
 
-	if (package->package.count > ACPI_MAX_HANDLES) {
+	if (package->package.count > ACPI_MAX_HANDLES) 
 		return AE_NO_MEMORY;
-	}
+	
 	list->count = package->package.count;
 
 	/* Extract package data. */
@@ -373,7 +373,7 @@ acpi_evaluate_reference(acpi_handle handle,
       end:
 	if (ACPI_FAILURE(status)) {
 		list->count = 0;
-		//kfree(list->handles);
+		/* kfree(list->handles);*/
 	}
 
 	kfree(buffer.pointer);
-- 
1.7.1



