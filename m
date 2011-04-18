Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1DRNqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:46:35 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3402 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754260Ab1DRNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:46:00 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJUOWC-02-4YA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] x86, gart: Convert spaces to tabs in enable_gart_translation
Date: Mon, 18 Apr 2011 15:45:44 +0200
Message-ID: <1303134346-5805-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably by copy&paste this function was indented by spaces.
Convert this to tabs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/gart.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 43085bf..88c1ebe 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -75,17 +75,17 @@ static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 {
 	u32 tmp, ctl;
 
-        /* address of the mappings table */
-        addr >>= 12;
-        tmp = (u32) addr<<4;
-        tmp &= ~0xf;
-        pci_write_config_dword(dev, AMD64_GARTTABLEBASE, tmp);
-
-        /* Enable GART translation for this hammer. */
-        pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
-        ctl |= GARTEN;
-        ctl &= ~(DISGARTCPU | DISGARTIO);
-        pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
+	/* address of the mappings table */
+	addr >>= 12;
+	tmp = (u32) addr<<4;
+	tmp &= ~0xf;
+	pci_write_config_dword(dev, AMD64_GARTTABLEBASE, tmp);
+
+	/* Enable GART translation for this hammer. */
+	pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
+	ctl |= GARTEN;
+	ctl &= ~(DISGARTCPU | DISGARTIO);
+	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
 
 static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
-- 
1.7.1


