Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab3AIKGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:06:37 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:57507 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628Ab3AIKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:06:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Date: Wed,  9 Jan 2013 10:06:04 +0000
Message-Id: <1357725965-27342-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Snowball is a community board it should have its default LED
trigger set in 'heartbeat' mode, meaning that it double flashes
~1HZ. This provides an excellent debugging tool when community
members are hacking.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 5dea906..0f25b07 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -43,6 +43,8 @@ config MACH_HREFV60
 config MACH_SNOWBALL
 	bool "U8500 Snowball platform"
 	select MACH_MOP500
+	select LEDS_TRIGGERS
+	select LEDS_TRIGGER_HEARTBEAT
 	help
 	  Include support for the snowball development platform.
 
-- 
1.7.9.5

