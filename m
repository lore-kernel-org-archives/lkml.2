Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2JNOo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:44:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46826 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932397Ab2JNOoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:25 -0400
Message-Id: <20121014143536.638265112@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 021/147] [media] gspca_pac7302: add support for device 1ae7:2001 Speedlink
 Snappy Microphone SL-6825-SBK
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Schäfer <fschaefer.oss@googlemail.com>

commit 97d2fbf501e3cf105ac957086c7e40e62e15cdf8 upstream.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/gspca/pac7302.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -1198,6 +1198,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x093a, 0x262a)},
 	{USB_DEVICE(0x093a, 0x262c)},
 	{USB_DEVICE(0x145f, 0x013c)},
+	{USB_DEVICE(0x1ae7, 0x2001)}, /* SpeedLink Snappy Mic SL-6825-SBK */
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);


