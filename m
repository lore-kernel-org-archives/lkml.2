Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1DUQIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:08:24 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21914 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1DUQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:08:21 -0400
Subject: Re: [PATCH] drivers/acpi/utils.c: Fixed coding style issues
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110421102815.5abf133e@absol.kitzblitz>
References: <1303341624.11397.2.camel@ks-ubuntu>
	 <20110421102815.5abf133e@absol.kitzblitz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 11:08:19 -0500
Message-ID: <1303402099.11855.9.camel@ks-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are introducing trailing whitespace.
> 
> >  			return AE_BAD_DATA;
> > -		}
> > +		
>    ^^^^^^^^^^^^^
> For every pair of braces you clean away, you're adding
> two new coding style issues.

Nicolas - appreciate your feedback and apologize for the error.  I have
corrected these issues. Re-submitting patch below with corrections.

Best Regards,
Karthigan Srinivasan.


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



