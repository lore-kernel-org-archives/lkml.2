Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2AGQHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 11:07:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2AGQHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 11:07:06 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=TRgVYD6ZyiEA:10 a=Cp4j2ZIZoM4A:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=pGLkceISAAAA:8 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=M4Y_NfsQnDJY0BWQaAIA:9 a=CjuIK1q_8ugA:10 a=jTbnE2AvvFoA:10 a=MSl-tDqOz04A:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sat, 07 Jan 2012 10:07:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        dario.lucia@gmail.com, post@rolandgruber.de
Subject: [PATCH] staging: r8712u: Add two new Sitecom UsB IDs
Message-ID: <4f086da7.iqSQ3kcASBfpUO2p%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB IDs for Sitecom WLA-2000 v1.001 WLAN, and SITECOM WLA-1000 V1 001 WLAN

Reported-and-tested-by: Roland Gruber <post@rolandgruber.de>
Reported-and-tested-by: Dario Lucia <dario.lucia@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

Greg,

The 0df6:005d modification was submitted Dec. 11, 2011, but appears to have
fallen through some crack. I am, therefore, resubmitting it. The 0df6:005b
ID is new.

Thanks,

Larry
---

 drivers/staging/rtl8712/usb_intf.c |    2 ++
 1 file changed, 2 insertions(+)
---

Index: staging/drivers/staging/rtl8712/usb_intf.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/usb_intf.c
+++ staging/drivers/staging/rtl8712/usb_intf.c
@@ -89,6 +89,8 @@ static struct usb_device_id rtl871x_usb_
 	{USB_DEVICE(0x0DF6, 0x0045)},
 	{USB_DEVICE(0x0DF6, 0x0059)}, /* 11n mode disable */
 	{USB_DEVICE(0x0DF6, 0x004B)},
+	{USB_DEVICE(0x0DF6, 0x005B)},
+	{USB_DEVICE(0x0DF6, 0x005D)},
 	{USB_DEVICE(0x0DF6, 0x0063)},
 	/* Sweex */
 	{USB_DEVICE(0x177F, 0x0154)},
