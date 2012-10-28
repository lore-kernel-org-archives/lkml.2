Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2J1Xmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:42:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41983 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab2J1X1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:38 -0400
Message-Id: <20121028231600.588481260@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Shigorin <mike@osdn.org.ua>,
        Oleksandr Chumachenko <ledest@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 076/105] usb-storage: add unusual_devs entry for Casio EX-N1 digital camera
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 779cd95..d305a5a 100644
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


