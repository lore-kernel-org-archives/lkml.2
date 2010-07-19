Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404Ab0GSJp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 05:45:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56943 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab0GSJp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 05:45:56 -0400
Date: Mon, 19 Jul 2010 11:47:04 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] usb: gadget: functionfs: stale Makefile entry removed
In-reply-to: <alpine.DEB.2.00.1007190515460.7957@lynx>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, Greg KH <greg@kroah.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        linux-kernel@vger.kernel.org
Message-id: <56bb448ef3f882f8fdc6a80613a841a729755cc9.1279532379.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <alpine.DEB.2.00.1007190515460.7957@lynx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed entry referencing g_eth_ffs.c file from Makefile.
The file never existed and the line was a leftover from a
developing process.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
---
On Mon, 19 Jul 2010, Robert P. J. Day wrote:
>   ah, gotcha.  well, i'll leave it in your capable hands, then.  i
> think my job here is done.  :-)

As you wish then.  I'll add you to Reported-by at least. :)

 drivers/usb/gadget/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 9bcde11..d8d6f91 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_USB_AUDIO)		+= g_audio.o
 obj-$(CONFIG_USB_ETH)		+= g_ether.o
 obj-$(CONFIG_USB_GADGETFS)	+= gadgetfs.o
 obj-$(CONFIG_USB_FUNCTIONFS)	+= g_ffs.o
-obj-$(CONFIG_USB_ETH_FUNCTIONFS)	+= g_eth_ffs.o
 obj-$(CONFIG_USB_FILE_STORAGE)	+= g_file_storage.o
 obj-$(CONFIG_USB_MASS_STORAGE)	+= g_mass_storage.o
 obj-$(CONFIG_USB_G_SERIAL)	+= g_serial.o
-- 
1.7.1

