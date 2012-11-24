Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2KXAWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:22:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:57888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2KXAVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:21:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 1/8] x86: Export asm/{svm.h,vmx.h,perf_regs.h}
Date: Fri, 23 Nov 2012 21:20:46 -0300
Message-Id: <1353716453-9693-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353716453-9693-1-git-send-email-acme@infradead.org>
References: <1353716453-9693-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Export asm/{svm.h,vmx.h,perf_regs.h} so that they can be disintegrated.

It looks from previous commits that the first two should have been exported,
but the header-y lines weren't added to the Kbuild.

I'm guessing that asm/perf_regs.h should be exported too.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 arch/x86/include/asm/Kbuild |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 66e5f0e..79fd8a3 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -12,6 +12,7 @@ header-y += mce.h
 header-y += msr-index.h
 header-y += msr.h
 header-y += mtrr.h
+header-y += perf_regs.h
 header-y += posix_types_32.h
 header-y += posix_types_64.h
 header-y += posix_types_x32.h
@@ -19,8 +20,10 @@ header-y += prctl.h
 header-y += processor-flags.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
+header-y += svm.h
 header-y += ucontext.h
 header-y += vm86.h
+header-y += vmx.h
 header-y += vsyscall.h
 
 genhdr-y += unistd_32.h
-- 
1.7.9.2.358.g22243

