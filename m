Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab2J2VwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:52:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:48605 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761560Ab2J2Vl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oleksandr Chumachenko <ledest@gmail.com>,
        Michael Shigorin <mike@osdn.org.ua>
Subject: [ 22/54] usb-storage: add unusual_devs entry for Casio EX-N1 digital camera
Date: Mon, 29 Oct 2012 14:40:23 -0700
Message-Id: <20121029213805.232823088@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1004,6 +1004,12 @@ UNUSUAL_DEV( 0x07cf, 0x1001, 0x1000, 0x9
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


