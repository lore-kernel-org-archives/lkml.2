Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1LQMRJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 07:17:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50739 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752115Ab1LQMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 07:17:03 -0500
X-Authenticated: #989139
X-Provags-ID: V01U2FsdGVkX1+YMQtqS4qYrf1dVa7Cu03kWhHJzE9b18MJ9ofyvB
	MjSN+qy7LxyukX
Message-ID: <4EEC8839.1010801@gmx.de>
Date: Sat, 17 Dec 2011 13:16:57 +0100
From: Ignaz Forster <ignaz.forster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110905 Firefox/6.0.2 SeaMonkey/2.3.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Enable HID_QUIRK_MULTI_INPUT for Trio Linker Plus II
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add quirk for the Trio Linker Plus II - the adapter supports several controllers simultaneously, generating a new HID entry for each connected device.

Signed-off-by: Ignaz Forster <ignaz.forster@gmx.de>
---
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 5028d60..4d256a7 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -47,6 +47,7 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
 
+	{ USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },

