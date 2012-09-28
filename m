Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030745Ab2I1TG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:06:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030703Ab2I1TGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20244/262=5D=20net=3A=20qmi=5Fwwan=3A=20add=20ZTE=20MF821D?=
Date: Fri, 28 Sep 2012 11:52:53 -0700
Message-Id: <20120928183027.228872277@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit db8dacf953a70274172236957a4b97d4fdb376f0 upstream.

Sold by O2 (telefonica germany) under the name "LTE4G"

Tested-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -453,6 +453,15 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE MF821D */
+		.match_flags        = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x0326,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
+	},
 	{	/* ZTE (Vodafone) K3520-Z */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x19d2,


