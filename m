Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0FOG4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:56:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60848 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0FOG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ay9eaU2m6/T8FSFCBIbFRY7yLInHHPDD4q5bOc5TX9Mt7vgkmuzIjlqfuw1Cl0dhka
         xbe+pg+tB7uSLYX4NaeDnr/+9E2yqFZFfGTehKcqL2tqpCwsgS6acOt2GdlLfGVuoIeO
         B/bEF3xM8N/FbuW4h5fh+csmdx37wtUR+S37A=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, ossama.othman@intel.com, mattij.lammi@gmail.com,
       randy.dunlap@oracle.com, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: memrar: memrar_handler.c: Fixed whitespace and tab warnings
Date: Tue, 15 Jun 2010 09:56:27 +0300
Message-Id: <1276584987-9202-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several witespace and tab related warnings and errors reported by the
chechpatch.pl tool. This is my second patch. Please, be nice.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/memrar/memrar_handler.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index efa7fd6..22208cd 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -291,7 +291,7 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 	if (rar_get_address(rarnum, &low, &high) != 0)
 		/* No RAR is available. */
 		return -ENODEV;
-	
+
 	if (low == 0 || high == 0) {
 		rar->base      = 0;
 		rar->length    = 0;
@@ -311,7 +311,8 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 	/* Claim RAR memory as our own. */
 	if (request_mem_region(low, rar->length, devname) == NULL) {
 		rar->length = 0;
-		pr_err("%s: Unable to claim RAR[%d] memory.\n", devname, rarnum);
+		pr_err("%s: Unable to claim RAR[%d] memory.\n",
+		       devname, rarnum);
 		pr_err("%s: RAR[%d] disabled.\n", devname, rarnum);
 		return -EBUSY;
 	}
@@ -347,7 +348,7 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 	}
 
 	pr_info("%s: BRAR[%d] bus address range = [0x%lx, 0x%lx]\n",
-			devname, rarnum, (unsigned long) low, (unsigned long) high);
+		devname, rarnum, (unsigned long) low, (unsigned long) high);
 
 	pr_info("%s: BRAR[%d] size = %zu KiB\n",
 			devname, rarnum, rar->allocator->capacity / 1024);
@@ -531,7 +532,7 @@ static long memrar_get_stat(struct RAR_stat *r)
 {
 	struct memrar_allocator *allocator;
 
- 	if (!memrar_is_valid_rar_type(r->type))
+	if (!memrar_is_valid_rar_type(r->type))
 		return -EINVAL;
 
 	if (!memrars[r->type].allocated)
-- 
1.6.0.4

