Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab1GOATD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:19:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:36030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1GOATB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:19:01 -0400
Date: Fri, 15 Jul 2011 00:18:51 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-4bb82178f5cb074783aaeaa06f9f840c67af7707@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
In-Reply-To: <tip-abe48b108247e9b90b4c6739662a2e5c765ed114@git.kernel.org>
References: <tip-abe48b108247e9b90b4c6739662a2e5c765ed114@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: Fix typo in ENERGY_PERF_BIAS_POWERSAVE
Git-Commit-ID: 4bb82178f5cb074783aaeaa06f9f840c67af7707
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 00:18:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bb82178f5cb074783aaeaa06f9f840c67af7707
Gitweb:     http://git.kernel.org/tip/4bb82178f5cb074783aaeaa06f9f840c67af7707
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 14 Jul 2011 14:58:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 14:58:44 -0700

x86, msr: Fix typo in ENERGY_PERF_BIAS_POWERSAVE

Fix a trivial typo in the name of the constant
ENERGY_PERF_BIAS_POWERSAVE.  This didn't cause trouble because this
constant is not currently used for anything.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/tip-abe48b108247e9b90b4c6739662a2e5c765ed114@git.kernel.org
---
 arch/x86/include/asm/msr-index.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 23a9d89..d96bdb2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -261,7 +261,7 @@
 #define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
 #define ENERGY_PERF_BIAS_PERFORMANCE	0
 #define ENERGY_PERF_BIAS_NORMAL		6
-#define ENERGY_PERF_BIAS_POWERSWAVE	15
+#define ENERGY_PERF_BIAS_POWERSAVE	15
 
 #define MSR_IA32_PACKAGE_THERM_STATUS		0x000001b1
 
