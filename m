Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab1C3KZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:25:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:49334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab1C3KZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:25:45 -0400
Date: Wed, 30 Mar 2011 10:24:49 GMT
From: tip-bot for Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20110330060229.27397.7628.stgit@ponder>
References: <20110330060229.27397.7628.stgit@ponder>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] arm: versatile : Fix typo introduced in irq namespace cleanup
Message-ID: <tip-e282326600f31ab38d8814fd6deb277a48850c35@git.kernel.org>
Git-Commit-ID: e282326600f31ab38d8814fd6deb277a48850c35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 10:24:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e282326600f31ab38d8814fd6deb277a48850c35
Gitweb:     http://git.kernel.org/tip/e282326600f31ab38d8814fd6deb277a48850c35
Author:     Grant Likely <grant.likely@secretlab.ca>
AuthorDate: Wed, 30 Mar 2011 00:02:29 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 30 Mar 2011 12:02:15 +0200

arm: versatile : Fix typo introduced in irq namespace cleanup

Commit 6845664(arm: Cleanup the irq namespace) introduces a typo
causing a build failure for the versatile platform.

[ tglx: Sorry, my bad. Have no idea how I fatfingered that ]

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
LKML-Reference: <20110330060229.27397.7628.stgit@ponder>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
