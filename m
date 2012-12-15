Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2LOUq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:46:29 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64777 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2LOUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:46:28 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:16:27 +0530
Message-ID: <CAA_L+UN2E3SL90PMynba-qA1fifBeVvTEy5tBVt543Uq80c5ng@mail.gmail.com>
Subject: [PATCH 3.7.0 9/9] i82975x_edac: set sw-scrub mode, bump rev.
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 9/9] i82975x_edac: set sw-scrub mode, bump rev.

update revision number and enable software scrub mode.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-15 23:08:28.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 23:09:29.000000000 +0530
@@ -16,7 +16,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"

-#define I82975X_REVISION	" Ver: 1.0.0"
+#define I82975X_REVISION	" Ver: 2.0.0"
 #define EDAC_MOD_STR		"i82975x_edac"

 #define i82975x_printk(level, fmt, arg...) \
@@ -586,7 +586,7 @@ static int i82975x_probe1(struct pci_dev
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->chip = dev_idx;
 	i82975x_init_csrows(mci, mch_window);
-	mci->scrub_mode = SCRUB_HW_SRC;
+	mci->scrub_mode = SCRUB_SW_SRC;
 	i82975x_get_error_info(mci, &discard);  /* clear counters */

 	/* finalize this instance of memory controller with edac core */
