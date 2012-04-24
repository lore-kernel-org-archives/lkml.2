Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab2DXVUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:20:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab2DXVUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:20:02 -0400
Date: Tue, 24 Apr 2012 14:19:46 -0700
From: tip-bot for David Daney <ddaney@caviumnetworks.com>
Message-ID: <tip-8b5ad472991796b2347464922c72de2ca5a028f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de
In-Reply-To: <1335291795-26693-3-git-send-email-ddaney.cavm@gmail.com>
References: <1335291795-26693-3-git-send-email-ddaney.cavm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] Revert "x86, extable:
  Disable presorted exception table for now"
Git-Commit-ID: 8b5ad472991796b2347464922c72de2ca5a028f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Apr 2012 14:19:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b5ad472991796b2347464922c72de2ca5a028f3
Gitweb:     http://git.kernel.org/tip/8b5ad472991796b2347464922c72de2ca5a028f3
Author:     David Daney <ddaney@caviumnetworks.com>
AuthorDate: Tue, 24 Apr 2012 11:23:15 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 24 Apr 2012 11:42:25 -0700

Revert "x86, extable: Disable presorted exception table for now"

sortextable now works with relative entries, re-enable it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Link: http://lkml.kernel.org/r/1335291795-26693-3-git-send-email-ddaney.cavm@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..2f925cc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,6 +82,7 @@ config X86
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
+	select BUILDTIME_EXTABLE_SORT
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
