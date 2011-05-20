Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279Ab1ETEyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:54:01 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:37872
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935245Ab1ETExi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:53:38 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/12] staging: usbip: usbip_common.c: rename init and exit functions
Date: Thu, 19 May 2011 21:37:05 -0700
Message-Id: <19f031a32b5aad2dff221f12c08274ac73181c5a.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the prefix of the __init and __exit functions to usbip_core_ to
correspond with the modules name.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/usbip_common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index b204e6f..1be4dc1 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -838,19 +838,19 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
 
-static int __init usbip_common_init(void)
+static int __init usbip_core_init(void)
 {
 	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
 	return 0;
 }
 
-static void __exit usbip_common_exit(void)
+static void __exit usbip_core_exit(void)
 {
 	return;
 }
 
-module_init(usbip_common_init);
-module_exit(usbip_common_exit);
+module_init(usbip_core_init);
+module_exit(usbip_core_exit);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.5.1

