Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2JWGWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:22:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWGWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:22:53 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/2]staging: "ehci-w90x900" Fix typos.
Date: Mon, 22 Oct 2012 23:22:21 -0700
Message-Id: <1350973342-3868-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes a typo in staging: "ehci-w90x900"

 drivers/usb/host/ehci-w90x900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
index ec59808..a9c28a0 100644
--- a/drivers/usb/host/ehci-w90x900.c
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -13,7 +13,7 @@
 
 #include <linux/platform_device.h>
 
-/*ebable phy0 and phy1 for w90p910*/
+/*enable phy0 and phy1 for w90p910*/
 #define	ENPHY		(0x01<<8)
 #define PHY0_CTR	(0xA4)
 #define PHY1_CTR	(0xA8)
-- 
1.7.10.4

