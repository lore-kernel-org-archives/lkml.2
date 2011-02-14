Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1BNKAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:00:44 -0500
Received: from server103.greatnet.de ([83.133.97.6]:38361 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab1BNKA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:00:26 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@readhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        yinghai@kernel.org, ak@linux.intel.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org, henne@nachtwindheim.de
Subject: [PATCH 6/6] x86: makes X86_UP_IOAPIC work again
Date: Mon, 14 Feb 2011 11:00:12 +0100
Message-Id: <1297677612-12405-6-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a typo, which made CONFIG_X86_UP_IOAPIC defunctional,
in commit 7cd92366a593246650cc7d6198e2c7d3af8c1d8a.

This has been successfully tested.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 95c36c4..66c6801 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -811,7 +811,7 @@ config X86_LOCAL_APIC
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
 
 config X86_VISWS_APIC
 	def_bool y
-- 
1.7.2.3

