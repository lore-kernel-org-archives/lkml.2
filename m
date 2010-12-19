Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab0LSRi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 12:38:57 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:47601 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0LSRi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 12:38:56 -0500
X-Greylist: delayed 1084 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 12:38:56 EST
Message-ID: <4D0E3EDF.3060805@t-online.de>
Date: Sun, 19 Dec 2010 18:20:31 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergey Vlasov <vsu@altlinux.ru>, Greg KH <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [PATCH] USB: usb-storage: unusual_devs update for Cypress ATACB
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: Z2KT+rZrrhB7t9nQO7pwARqA14vvrWh252PaEZhOWv+pxH0buJYB6k5HJ0BrG2wgEF
X-TOI-MSGID: e85ad08d-69c2-4eee-83e3-362058555024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New device ID added for unusual Cypress ATACB device.

Signed-off-by: Richard Schütz <r.schtz@t-online.de>

--- a/drivers/usb/storage/unusual_cypress.h	2010-12-09 
23:17:27.000000000 +0100
+++ b/drivers/usb/storage/unusual_cypress.h	2010-12-19 
12:20:14.756009149 +0100
@@ -31,4 +31,9 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
  		"Cypress ISD-300LP",
  		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),

+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+		"Super Top",
+		"USB 2.0  SATA BRIDGE",
+		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
+
  #endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */

-- 
Regards,
Richard Schütz
