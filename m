Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2BYBWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:22:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38417 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2BYBWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:22:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tipecaml@gmail.com designates 10.180.99.65 as permitted sender) smtp.mail=tipecaml@gmail.com; dkim=pass header.i=tipecaml@gmail.com
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 4/6] amd5536udc: use the DEFINE_PCI_DEVICE_TABLE macro.
Date: Sat, 25 Feb 2012 02:15:00 +0100
Message-Id: <1330132502-17057-5-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFINE_PCI_DEVICE_TABLE instead of "const struct pci_device_id".

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 3d627db..3d563d0 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3405,7 +3405,7 @@ static int udc_remote_wakeup(struct udc *dev)
 }
 
 /* PCI device parameters */
-static const struct pci_device_id pci_id[] = {
+static DEFINE_PCI_DEVICE_TABLE(pci_id) = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x2096),
 		.class =	(PCI_CLASS_SERIAL_USB << 8) | 0xfe,
-- 
1.7.9

