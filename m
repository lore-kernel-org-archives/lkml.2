Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1LLD3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:03 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19071 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1LLD2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:42 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 10/11] bf537: spi sport driver can support any gpio as its cs pin
Date: Mon, 12 Dec 2011 11:28:32 +0800
Message-ID: <1323660513-9620-10-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Jiang <scott.jiang.linux@gmail.com>

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index c59d21f..1b34466 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1462,7 +1462,7 @@ static struct platform_device bfin_spi0_device = {
 
 /* SPORT SPI controller data */
 static struct bfin5xx_spi_master bfin_sport_spi0_info = {
-	.num_chipselect = 1, /* master only supports one device */
+	.num_chipselect = MAX_BLACKFIN_GPIOS,
 	.enable_dma = 0,  /* master don't support DMA */
 	.pin_req = {P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_DRPRI,
 		P_SPORT0_RSCLK, P_SPORT0_TFS, P_SPORT0_RFS, 0},
@@ -1492,7 +1492,7 @@ static struct platform_device bfin_sport_spi0_device = {
 };
 
 static struct bfin5xx_spi_master bfin_sport_spi1_info = {
-	.num_chipselect = 1, /* master only supports one device */
+	.num_chipselect = MAX_BLACKFIN_GPIOS,
 	.enable_dma = 0,  /* master don't support DMA */
 	.pin_req = {P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_DRPRI,
 		P_SPORT1_RSCLK, P_SPORT1_TFS, P_SPORT1_RFS, 0},
-- 
1.7.0.4


