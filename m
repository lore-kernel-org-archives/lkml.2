Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab1CCUFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:05:54 -0500
Received: from server103.greatnet.de ([83.133.97.6]:55210 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab1CCUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:05:14 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 5/7] x86: remove ancient crufty prototype
Date: Thu,  3 Mar 2011 21:04:59 +0100
Message-Id: <1299182701-8591-5-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function cache_APIC_registers() does not exist in
the whole git history, so it can be removed.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/apic.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f17d7c5..142fd7a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -227,7 +227,6 @@ extern void disconnect_bsp_APIC(int virt_wire_setup);
 extern void disable_local_APIC(void);
 extern void lapic_shutdown(void);
 extern int verify_local_APIC(void);
-extern void cache_APIC_registers(void);
 extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
-- 
1.7.2.3

