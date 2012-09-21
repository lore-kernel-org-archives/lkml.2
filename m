Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab2IUT7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:59:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2IUT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:59:30 -0400
Date: Fri, 21 Sep 2012 12:59:20 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-85fdf05cc395f23384cb0adb22765cbaa9653b54@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-4-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-4-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap: Add CR4 bit for SMAP
Git-Commit-ID: 85fdf05cc395f23384cb0adb22765cbaa9653b54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 12:59:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85fdf05cc395f23384cb0adb22765cbaa9653b54
Gitweb:     http://git.kernel.org/tip/85fdf05cc395f23384cb0adb22765cbaa9653b54
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:07 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:25 -0700

x86, smap: Add CR4 bit for SMAP

Add X86_CR4_SMAP to <asm/processor-flags.h>.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-4-git-send-email-hpa@linux.intel.com
---
 arch/x86/include/asm/processor-flags.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index aea1d1d..680cf09 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -65,6 +65,7 @@
 #define X86_CR4_PCIDE	0x00020000 /* enable PCID support */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 #define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
+#define X86_CR4_SMAP	0x00200000 /* enable SMAP support */
 
 /*
  * x86-64 Task Priority Register, CR8
