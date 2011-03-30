Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1C3GCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:02:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52405 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1C3GCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:02:34 -0400
Subject: [PATCH] arm: fix build failure introduced by typo in irq namespace
 cleanup.
To: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 30 Mar 2011 00:02:29 -0600
Message-ID: <20110330060229.27397.7628.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6845664a6a7d443f03883db59d10749d38d98b8e, "arm: Cleanup the irq
namespace" introduces a typo causing a build failure for the versatile
platform.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-versatile/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 96e59e3..eb7ffa0 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -314,7 +314,7 @@ static struct mmci_platform_data mmc0_plat_data = {
 	.gpio_cd	= -1,
 };
 
-static struct resource chalcd_resources[] = {
+static struct resource char_lcd_resources[] = {
 	{
 		.start = VERSATILE_CHAR_LCD_BASE,
 		.end   = (VERSATILE_CHAR_LCD_BASE + SZ_4K - 1),

