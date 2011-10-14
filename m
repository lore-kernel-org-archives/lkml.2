Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1JNMbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:31:15 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58780 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab1JNMbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:31:12 -0400
Subject: [PATCH 16/21] x86: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:30:23 +0200
Message-ID: <1318595423.6132.75.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/x86/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..18f74ed 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -192,9 +192,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 config NEED_PER_CPU_PAGE_FIRST_CHUNK
 	def_bool y
 
-config HAVE_CPUMASK_OF_CPU_MAP
-	def_bool X86_64_SMP
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
1.7.4.4

