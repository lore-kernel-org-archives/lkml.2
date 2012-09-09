Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2IITDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 15:03:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2IITDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 15:03:08 -0400
Date: Sun, 9 Sep 2012 12:02:53 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-ethzcr5nipikl6hd5q8ssepq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpufeature: Add feature bit for SMAP
Git-Commit-ID: 05194cfc547528a01d655262c49da3b1311c4b11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 12:03:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05194cfc547528a01d655262c49da3b1311c4b11
Gitweb:     http://git.kernel.org/tip/05194cfc547528a01d655262c49da3b1311c4b11
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 9 Sep 2012 11:12:04 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 9 Sep 2012 11:12:04 -0700

x86, cpufeature: Add feature bit for SMAP

Add CPUID feature bit for Supervisor Mode Access Prevention (SMAP).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-ethzcr5nipikl6hd5q8ssepq@git.kernel.org
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6b7ee5f..633b617 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -209,6 +209,7 @@
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
+#define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
