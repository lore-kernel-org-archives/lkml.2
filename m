Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1FNO5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:57:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56943 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1FNO5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XT5wsuGbVJNe/SZ1t85yw/QQLss0RNmD7mbS/A0tYlwxjggC7/OFgnfVoSa33KcwYf
         dWUfiZCW6beTiRzlUodvcAQyJU/8k8W5RrTYt+T9O2r433jwT3sDTavwCCHE2wQWTAvN
         uvtuXIi1TubsDB+8WHKrKLPvWVH+eH7zawYXY=
Subject: [PATCH v2] Add support for 88SE91A0, 88SE91A4
From: =?UTF-8?Q?Pawe=C5=82?= Drewniak <czajernia@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, czajernia@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 15:56:07 +0100
Message-ID: <1308063367.21407.3.camel@woody-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch enables support for Marvell IDE PATA controllers found on
Asus P8P67LE motherboard.
The formatting has been corrected and I also received a report from two
users of this motherboard that the patch works.

Thanks,
Paweł Drewniak

diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 75a6a0c..3a4c885 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -161,6 +161,8 @@ static const struct pci_device_id marvell_pci_tbl[]
= {
 	{ PCI_DEVICE(0x11AB, 0x6121), },
 	{ PCI_DEVICE(0x11AB, 0x6123), },
 	{ PCI_DEVICE(0x11AB, 0x6145), },
+	{ PCI_DEVICE(0x1B4B, 0x91A0), },
+	{ PCI_DEVICE(0x1B4B, 0x91A4), },
 	{ }	/* terminate list */
 };


