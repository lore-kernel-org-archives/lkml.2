Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2GZVVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:21:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43844 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2GZVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Nicoletti <dantti12@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 11/23] HID: add battery quirk for Apple Wireless ANSI
Date: Thu, 26 Jul 2012 14:19:50 -0700
Message-Id: <20120726211406.893492664@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Nicoletti <dantti12@gmail.com>

commit 0c47935c5b5cd4916cf1c1ed4a2894807f7bcc3e upstream.

Add USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI, to the quirk list since it report
wrong feature type and wrong percentage range.

Signed-off-by: Daniel Nicoletti <dantti12@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -290,6 +290,9 @@ static const struct hid_device_id hid_ba
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 			       USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+		USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
+	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{}
 };
 


