Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1JXImz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:42:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57393 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1JXImT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:42:19 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, Tejun Heo <tj@kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 1/4] Documentation: devres: add allocation functions to list of supported calls
Date: Mon, 24 Oct 2011 10:42:06 +0200
Message-Id: <1319445729-14841-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
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

