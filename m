Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0I0Cfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:35:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47676 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab0I0Cfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PvU3f3bXUgPrHN1CMyr7dC12NLDo3GBdJ6D2MI0vGcdaoRcQkwqfiZqUNvWUkmppRL
         WuNXRujarilOleXuguyOia4NPmnxTcW1yli562LCRv9blYSxokxqpH7sFDlLxaOApLY7
         JZLExM4SjdeZ2g4mv+3yLVRupRPS98FCwgQzU=
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3/4] ALSA: hda: add Vortex86MX PCI ids
Date: Sun, 26 Sep 2010 23:35:06 -0300
Message-Id: <1285554907-4495-3-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.2.3.313.gcd15
In-Reply-To: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
References: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 34940a0..e986209 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2799,6 +2799,8 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* this entry seems still valid -- i.e. without emu20kx chip */
 	{ PCI_DEVICE(0x1102, 0x0009), .driver_data = AZX_DRIVER_GENERIC },
 #endif
+	/* Vortex86MX */
+	{ PCI_DEVICE(0x17f3, 0x3010), .driver_data = AZX_DRIVER_GENERIC },
 	/* AMD/ATI Generic, PCI class code and Vendor ID for HD Audio */
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_ANY_ID),
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
-- 
1.7.2.3.313.gcd15

