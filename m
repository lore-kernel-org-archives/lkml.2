Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1BUI7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:59:38 -0500
Received: from server103.greatnet.de ([83.133.97.6]:44069 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab1BUI7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:59:36 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 5/5] x86: fix deps of X86_UP_IOAPIC
Date: Mon, 21 Feb 2011 09:59:24 +0100
Message-Id: <1298278764-3320-5-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298278764-3320-1-git-send-email-henne@nachtwindheim.de>
References: <1298278764-3320-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7cd92366a593246650cc7d6198e2c7d3af8c1d8a
lAPIC enabled accidently the IOAPIC, which now gets fixed.

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

