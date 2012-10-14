Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2JNOof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:44:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46833 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301Ab2JNOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:24 -0400
Message-Id: <20121014143536.501196147@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 020/147] [media] gspca_pac7302: Add usb-id for 145f:013c
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 4d6454dbae935825e729f34dc7410bb1b22c7944 upstream.

Reported by: Grzegorz Woźniak

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/gspca/pac7302.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/gspca/pac7302.c b/drivers/media/video/gspca/pac7302.c
index 1c44f78..edbc04c 100644
--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -1197,6 +1197,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x093a, 0x2629), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x262a)},
 	{USB_DEVICE(0x093a, 0x262c)},
+	{USB_DEVICE(0x145f, 0x013c)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);


