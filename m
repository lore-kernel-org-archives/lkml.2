Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2DTAYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:24:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2DTAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:24:06 -0400
Date: Thu, 19 Apr 2012 17:23:56 -0700
From: tip-bot for David Daney <david.daney@cavium.com>
Message-ID: <tip-d405c60128a1973648058fa950a8960ec1f27e38@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1334872799-14589-6-git-send-email-ddaney.cavm@gmail.com>
References: <1334872799-14589-6-git-send-email-ddaney.cavm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86: Select BUILDTIME_EXTABLE_SORT
Git-Commit-ID: d405c60128a1973648058fa950a8960ec1f27e38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:24:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d405c60128a1973648058fa950a8960ec1f27e38
Gitweb:     http://git.kernel.org/tip/d405c60128a1973648058fa950a8960ec1f27e38
Author:     David Daney <david.daney@cavium.com>
AuthorDate: Thu, 19 Apr 2012 14:59:59 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:07:10 -0700

x86: Select BUILDTIME_EXTABLE_SORT

We can sort the exeception table at build time for x86, so let's do
it.

Signed-off-by: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/1334872799-14589-6-git-send-email-ddaney.cavm@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
