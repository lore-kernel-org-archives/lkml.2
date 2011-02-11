Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1BKOid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:38:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53394 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1BKOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:38:28 -0500
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
Subject: [PATCH v2 07/13] da850: pruss CAN platform specific changes for gpios.
Date: Fri, 11 Feb 2011 20:21:26 +0530
Message-Id: <1297435892-28278-8-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the GPIOs for the pruss CAN device.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/da850.c            |    1 +
 arch/arm/mach-davinci/include/mach/mux.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 4862c28..a15571d 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -570,6 +570,7 @@ static const struct mux_config da850_pins[] = {
 	MUX_CFG(DA850, PRUSS_PRU1_R30_15,	12,	0,	15,	4,	false)
 	MUX_CFG(DA850, PRUSS_PRU1_R31_18,	11,	20,	15,	0,	false)
 	/* GPIO function */
+	MUX_CFG(DA850, GPIO2_0,		6,	28,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_4,		6,	12,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_6,		6,	4,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_8,		5,	28,	15,	8,	false)
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
index 10f49f2..85b3a0d 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -912,6 +912,7 @@ enum davinci_da850_index {
 	DA850_PRUSS_PRU1_R31_18,
 
 	/* GPIO function */
+	DA850_GPIO2_0,
 	DA850_GPIO2_4,
 	DA850_GPIO2_6,
 	DA850_GPIO2_8,
-- 
1.7.2.3

