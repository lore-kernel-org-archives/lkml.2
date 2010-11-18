Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0KREZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:25:14 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:47437 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753658Ab0KREZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:25:13 -0500
X-Yahoo-SMTP: jzB4jWiswBBYkOSEyh0b8C1fg.r66R8R7JNKIg--
X-YMail-OSG: Kez7Vp4VM1kN1SPdnF8ch.YE.Fc6IVr5BGZLcvpXKjWq81A
 JsHZ8y81FPOJOpMlfcnW29k8wG_c61XXs9suM4X1CFhev60qVPEidr_CEt09
 RziijhgNKy1FE7GpbosVKn8foNt8wzN2VPfnSAhinGNBPiTeGeavRRZcMH0v
 lUL3LTI2fwd3.kzTdP9fNvY9Y5u6vodItBDAcyR9Vt_SaJZKlQccT1.jAvqL
 fLLwjxDS0EFOkCBQ1.TJTzdM9FE6b6g3gi8JkfRIk80NTq_vzQJikFn_5
X-Yahoo-Newman-Property: ymail-3
From: Brian Walsh <brian@walsh.ws>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] arm: ixp4xx export symbol dma_set_coherent_mask
Date: Wed, 17 Nov 2010 23:25:10 -0500
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic-pae; KDE/4.4.2; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011172325.10894.brian@walsh.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM ixp4xx module building has been broken since commit 710224fa2750.
arm: fix "arm: fix pci_set_consistent_dma_mask for dmabounce devices"

Signed-off-by: Brian Walsh <brian@walsh.ws>

diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 24498a9..d54b219 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -513,4 +513,5 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
+EXPORT_SYMBOL(dma_set_coherent_mask);
