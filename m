Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1ABHsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:48:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:35949 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1ABHXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 145/260] AT91: change dma resource index
Date: Sun,  2 Jan 2011 02:17:21 -0500
Message-Id: <1293952756-15010-146-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:48.0743 (UTC) FILETIME=[DBD2F370:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 8d2602e0778299e2d6084f03086b716d6e7a1e1e upstream.

Reported-by: Dan Liang <dan.liang@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 809114d..501ac6f 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -46,7 +46,7 @@ static struct resource hdmac_resources[] = {
 		.end	= AT91_BASE_SYS + AT91_DMA + SZ_512 - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[2] = {
+	[1] = {
 		.start	= AT91SAM9G45_ID_DMA,
 		.end	= AT91SAM9G45_ID_DMA,
 		.flags	= IORESOURCE_IRQ,
-- 
1.7.3.3

