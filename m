Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab1JYNBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:01:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48543 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab1JYNBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:01:07 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Documentation: devres: add allocation functions to list of supported calls
Date: Tue, 25 Oct 2011 15:00:57 +0200
Message-Id: <1319547657-22342-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
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
---

Changes since RFC:
* added acks. Ack from Grant given personally here in Prague.

 Documentation/driver-model/devres.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index d79aead..badd964 100644
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
1.7.6.3

