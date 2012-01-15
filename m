Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2AOMb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:31:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39996 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2AOMb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:31:56 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <gregkh@suse.de>
Subject: [PATCH RESEND] Documentation: devres: add allocation functions to list of supported calls
Date: Sun, 15 Jan 2012 13:31:46 +0100
Message-Id: <1326630706-17769-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <gregkh@suse.de>
---

I first sent this patch to Randy, but maybe this is more in Greg's area?

 Documentation/driver-model/devres.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 10c64c8..41c0c5d 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -233,6 +233,10 @@ certainly invest a bit more effort into libata core layer).
   6. List of managed interfaces
   -----------------------------
 
+MEM
+  devm_kzalloc()
+  devm_kfree()
+
 IO region
   devm_request_region()
   devm_request_mem_region()
-- 
1.7.2.5

