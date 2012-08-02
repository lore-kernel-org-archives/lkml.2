Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2HBMpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:45:45 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:47076 "EHLO
	homiemail-a49.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754259Ab2HBMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=from:to:cc
	:subject:date:message-id; q=dns; s=shealevy.com; b=Usl+HgrdLv0Yy
	qcjYWu0nUhkEbH6Qq3xoYVpG1woOmvx8ZVGcTGQ4EYPlUFlKTxbaUWqRtAMyf9AC
	Ch7HrrHDDCLD1LIYVMFSThIVV8qoNgSgLuYALMrYZpxqKgxnBbW/6MuCo9SZzDmR
	av3vI/SZ1JHJcF8ux0vj+EPlSrjBg4=
From: shea@shealevy.com
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shea Levy <shea@shealevy.com>
Subject: [PATCH] Bluetooth: Add support for Apple MacBook Pro 9,2
Date: Thu,  2 Aug 2012 08:45:33 -0400
Message-Id: <1343911533-3423-1-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 1.7.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shea Levy <shea@shealevy.com>


Signed-off-by: Shea Levy <shea@shealevy.com>
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

