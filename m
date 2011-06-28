Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1F1K30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:29:26 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4518 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab1F1K2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:28:22 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com, avictor.za@gmail.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Date: Tue, 28 Jun 2011 13:35:27 +0200
Message-Id: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this Kconfig variable to ease the submission of this chip support.
As this chip/board inclusion is dealayed due to deep consolidation of
arm/mach-at91 sources, we include this dummy configuration variable to allow
submission of SAM9x5 related drivers in other subsystems.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2248467..ce45f64 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -12,6 +12,9 @@ config HAVE_AT91_USART4
 config HAVE_AT91_USART5
 	bool
 
+config ARCH_AT91SAM9X5
+	bool
+
 menu "Atmel AT91 System-on-Chip"
 
 choice
-- 
1.7.3

