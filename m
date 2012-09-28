Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033280Ab2I1Vch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:32:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422690Ab2I1U1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo Van Doorn <ivdoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 117/218] rt2x00: Identify ASUS USB-N53 device.
Date: Fri, 28 Sep 2012 13:15:34 -0700
Message-Id: <20120928201514.898850608@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 177ef8360fabdc49ff08d2598c06e7f7a36b53e3 upstream.

This is an RT3572 based device.

Signed-off-by: Maximilian Engelhardt <maxi@daemonizer.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x1690, 0x0744) },
 	{ USB_DEVICE(0x1690, 0x0761) },
 	{ USB_DEVICE(0x1690, 0x0764) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
 	/* EnGenius */
@@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0b05, 0x1760) },
 	{ USB_DEVICE(0x0b05, 0x1761) },
 	{ USB_DEVICE(0x0b05, 0x1790) },
-	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262) },
 	{ USB_DEVICE(0x13d3, 0x3284) },


