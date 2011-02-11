Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab1BKOiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:38:13 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:34539 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab1BKOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:38:10 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...,commit_signer:8/10=80%),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        Thomas Koeller <thomas.koeller@baslerweb.com> (commit_signer:4/10=40%),
        Cyril Chemparathy <cyril@ti.com> (commit_signer:3/10=30%),
        Victor Rodriguez <vm.rod25@gmail.com> (commit_signer:1/10=10%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 05/13] da850: pruss CAN platform specific additions.
Date: Fri, 11 Feb 2011 20:21:24 +0530
Message-Id: <1297435892-28278-6-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary pins for the pruss CAN.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/da850.c            |    4 ++++
 arch/arm/mach-davinci/include/mach/mux.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index a098263..4862c28 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -565,6 +565,10 @@ static const struct mux_config da850_pins[] = {
 	MUX_CFG(DA850, EMA_CLK,		6,	0,	15,	1,	false)
 	MUX_CFG(DA850, EMA_WAIT_1,	6,	24,	15,	1,	false)
 	MUX_CFG(DA850, NEMA_CS_2,	7,	0,	15,	1,	false)
+	/* PRU functions for soft CAN */
+	MUX_CFG(DA850, PRUSS_PRU0_R31_0,	7,	28,	15,	0,	false)
+	MUX_CFG(DA850, PRUSS_PRU1_R30_15,	12,	0,	15,	4,	false)
+	MUX_CFG(DA850, PRUSS_PRU1_R31_18,	11,	20,	15,	0,	false)
 	/* GPIO function */
 	MUX_CFG(DA850, GPIO2_4,		6,	12,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_6,		6,	4,	15,	8,	false)
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
index 5d4e0fe..10f49f2 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -906,6 +906,10 @@ enum davinci_da850_index {
 	DA850_EMA_CLK,
 	DA850_EMA_WAIT_1,
 	DA850_NEMA_CS_2,
+	/* PRU I/O */
+	DA850_PRUSS_PRU0_R31_0,
+	DA850_PRUSS_PRU1_R30_15,
+	DA850_PRUSS_PRU1_R31_18,
 
 	/* GPIO function */
 	DA850_GPIO2_4,
-- 
1.7.2.3

