Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2JWOpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:45:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52149 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2JWOph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:45:37 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: stern@rowland.harvard.edu
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]usb: "ehci-w90x900" Fix a typo and add some whitespace.
Date: Tue, 23 Oct 2012 07:45:01 -0700
Message-Id: <1351003501-4949-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes a typo in usb: ehci-w90x900.c as well as adding whitespace to the comment.
NOTE: this is a resend due to a typo creating a new typo as well as revision to the original.

 drivers/usb/host/ehci-w90x900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
index ec59808..fdd7c48 100644
--- a/drivers/usb/host/ehci-w90x900.c
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -13,7 +13,7 @@
 
 #include <linux/platform_device.h>
 
-/*ebable phy0 and phy1 for w90p910*/
+/* enable phy0 and phy1 for w90p910 */
 #define	ENPHY		(0x01<<8)
 #define PHY0_CTR	(0xA4)
 #define PHY1_CTR	(0xA8)
-- 
1.7.10.4

