Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2EHWWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:22:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:22:38 -0400
Date: Tue, 8 May 2012 15:22:28 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-f7436a9da902922a48cccc208099763b87d6171f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-12-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-12-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: Align .
 data section in trampoline_32.S
Git-Commit-ID: f7436a9da902922a48cccc208099763b87d6171f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:22:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7436a9da902922a48cccc208099763b87d6171f
Gitweb:     http://git.kernel.org/tip/f7436a9da902922a48cccc208099763b87d6171f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:34 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:03 -0700

x86, realmode: Align .data section in trampoline_32.S

Specify the alignment of the .data section in trampoline_32.S.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-12-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/trampoline_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 18cb7fc..1f9e331 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -68,7 +68,7 @@ trampoline_data:
 
 	.data
 	.globl startup_32_smp, boot_gdt, trampoline_status
-
+	.balign	4
 boot_gdt_descr:
 	.word	__BOOT_DS + 7			# gdt limit
 boot_gdt:
