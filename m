Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1BWMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:09:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:56628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab1BWMJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:09:25 -0500
Date: Wed, 23 Feb 2011 12:09:00 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
In-Reply-To: <1298385487-4708-5-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-5-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Fix deps of X86_UP_IOAPIC
Message-ID: <tip-1444e0c9daf0d3472677efc15588b192fc2db761@git.kernel.org>
Git-Commit-ID: 1444e0c9daf0d3472677efc15588b192fc2db761
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:09:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1444e0c9daf0d3472677efc15588b192fc2db761
Gitweb:     http://git.kernel.org/tip/1444e0c9daf0d3472677efc15588b192fc2db761
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Tue, 22 Feb 2011 15:38:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:38:46 +0100

x86: Fix deps of X86_UP_IOAPIC

Since commit 7cd92366a593246650cc7d6198e2c7d3af8c1d8a
lAPIC enabled accidently the IOAPIC, which now gets fixed.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
LKML-Reference: <1298385487-4708-5-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..867a8cf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -811,7 +811,7 @@ config X86_LOCAL_APIC
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
 
 config X86_VISWS_APIC
 	def_bool y
