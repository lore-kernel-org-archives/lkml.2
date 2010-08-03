Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0HCRtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:49:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab0HCRtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:49:22 -0400
Date: Tue, 3 Aug 2010 17:49:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <201008031815.09764.florian@openwrt.org>
References: <201008031815.09764.florian@openwrt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
Message-ID: <tip-c0366f5f5c1615c4f70b1bd646149ba9233830b9@git.kernel.org>
Git-Commit-ID: c0366f5f5c1615c4f70b1bd646149ba9233830b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 17:49:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0366f5f5c1615c4f70b1bd646149ba9233830b9
Gitweb:     http://git.kernel.org/tip/c0366f5f5c1615c4f70b1bd646149ba9233830b9
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 3 Aug 2010 10:09:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 3 Aug 2010 10:09:56 -0700

x86, cpu: RDC doesn't have CPUID, which is what c_ident is

c_ident is supposed to be a CPUID identifier, and RDC doesn't have
that.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Mark Kelly <mark@bifferos.com>
Cc: Florian Fainelli <florian@openwrt.org>
LKML-Reference: <201008031815.09764.florian@openwrt.org>
---
 arch/x86/kernel/cpu/rdc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/rdc.c b/arch/x86/kernel/cpu/rdc.c
index c2bcdcc..e5e241c 100644
--- a/arch/x86/kernel/cpu/rdc.c
+++ b/arch/x86/kernel/cpu/rdc.c
@@ -65,7 +65,6 @@ static void __cpuinit rdc_identify(struct cpuinfo_x86 *c)
 
 static const struct cpu_dev __cpuinitconst rdc_cpu_dev = {
 	.c_vendor	= "RDC",
-	.c_ident	= { "RDC" },
 	.c_identify	= rdc_identify,
 	.c_x86_vendor	= X86_VENDOR_RDC,
 };
