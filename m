Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2HBMnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:43:15 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:46998 "EHLO
	homiemail-a49.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753720Ab2HBMnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=from:to:cc
	:subject:date:message-id; q=dns; s=shealevy.com; b=FmKwN+juLLGvv
	knXwAPDOHlIOrZ54wdRRvfPeWlLqKINdp1ghawYyvPWRuWF+TQqpKijerQ686q+S
	3p3jav6tKFwrq74/J0Libv4g/Wv8RaniM7eV9o4QCZiUJ4ouxq416Y/JXGIZUE03
	2+b0t15hPxcC9iyeS1wj2hpVUrQvf8=
From: shea@shealevy.com
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shea Levy <shea@shealevy.com>
Subject: [PATCH] Bluetooth: Add support for Apple MacBook Pro 9,2
Date: Thu,  2 Aug 2012 08:42:45 -0400
Message-Id: <1343911365-3376-1-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 1.7.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shea Levy <shea@shealevy.com>

---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e272214..e4ecd5e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -73,6 +73,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple MacBookPro8,2 */
 	{ USB_DEVICE(0x05ac, 0x821a) },
 
+	/* Apple MacBookPro9,2 */
+	{ USB_DEVICE(0x05ac, 0x821d) },
+
 	/* Apple MacMini5,1 */
 	{ USB_DEVICE(0x05ac, 0x8281) },
 
-- 
1.7.11

