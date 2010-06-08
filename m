Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0FHBBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 21:01:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:37444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0FHBBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 21:01:23 -0400
Date: Tue, 8 Jun 2010 01:01:00 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100605114042.35ac69c1@dev.queued.net>
References: <20100605114042.35ac69c1@dev.queued.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: use __ASSEMBLY__ rather than __ASSEMBLER__
Message-ID: <tip-fc4ac7a5f5996712d9123ae4850948c640edb315@git.kernel.org>
Git-Commit-ID: fc4ac7a5f5996712d9123ae4850948c640edb315
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 01:01:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc4ac7a5f5996712d9123ae4850948c640edb315
Gitweb:     http://git.kernel.org/tip/fc4ac7a5f5996712d9123ae4850948c640edb315
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Sat, 5 Jun 2010 11:40:42 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 7 Jun 2010 17:27:11 -0700

x86: use __ASSEMBLY__ rather than __ASSEMBLER__

As Ingo pointed out in a separate patch, we should be using __ASSEMBLY__.
Make that the case in pgtable headers.

Signed-off-by: Andres Salomon <dilinger@queued.net>
LKML-Reference: <20100605114042.35ac69c1@dev.queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable_32_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index 5e67c15..ed5903b 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -26,7 +26,7 @@
  */
 #define VMALLOC_OFFSET	(8 * 1024 * 1024)
 
-#ifndef __ASSEMBLER__
+#ifndef __ASSEMBLY__
 extern bool __vmalloc_start_set; /* set once high_memory is set */
 #endif
 
