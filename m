Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab2KZROs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934009Ab2KZROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksandr Chumachenko <ledest@gmail.com>,
        Michael Shigorin <mike@osdn.org.ua>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 235/270] usb-storage: add unusual_devs entry for Casio EX-N1 digital camera
Date: Mon, 26 Nov 2012 14:58:45 -0200
Message-Id: <1353949160-26803-236-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Shigorin <mike@osdn.org.ua>

commit d7870af7e2e3a91b462075ec1ca669b482215187 upstream.

This commit sets removable subclass for Casio EX-N1 digital camera.

The patch has been tested within an ALT Linux kernel:
http://git.altlinux.org/people/led/packages/?p=kernel-image-3.0.git;a=commitdiff;h=c0fd891836e89fe0c93a4d536a59216d90e4e3e7

See also https://bugzilla.kernel.org/show_bug.cgi?id=49221

Signed-off-by: Oleksandr Chumachenko <ledest@gmail.com>
Signed-off-by: Michael Shigorin <mike@osdn.org.ua>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1719886..dd2c64f 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1004,6 +1004,12 @@ UNUSUAL_DEV( 0x07cf, 0x1001, 0x1000, 0x9999,
 		USB_SC_8070, USB_PR_CB, NULL,
 		US_FL_NEED_OVERRIDE | US_FL_FIX_INQUIRY ),
 
+/* Submitted by Oleksandr Chumachenko <ledest@gmail.com> */
+UNUSUAL_DEV( 0x07cf, 0x1167, 0x0100, 0x0100,
+		"Casio",
+		"EX-N1 DigitalCamera",
+		USB_SC_8070, USB_PR_DEVICE, NULL, 0),
+
 /* Submitted by Hartmut Wahl <hwahl@hwahl.de>*/
 UNUSUAL_DEV( 0x0839, 0x000a, 0x0001, 0x0001,
 		"Samsung",
-- 
1.7.9.5

