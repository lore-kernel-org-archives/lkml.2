Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1JKS0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:26:25 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41188 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755608Ab1JKS0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:26:22 -0400
Message-ID: <4E948A4B.3010009@xenotime.net>
Date: Tue, 11 Oct 2011 11:26:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH -next] x86: perf_event_intel.c needs export.h
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
In-Reply-To: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Add <linux/export.h> to fix build warnings:

arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: data definition has no type or storage class
arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/x86/kernel/cpu/perf_event_intel.c:1323:1: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- next-2011-1011.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ next-2011-1011/arch/x86/kernel/cpu/perf_event_intel.c
@@ -7,6 +7,7 @@
 
 #include <linux/stddef.h>
 #include <linux/types.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 
