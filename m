Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0KPSLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:11:11 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49795 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0KPSLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:11:10 -0500
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix included-by file reference comments
Date: Tue, 16 Nov 2010 10:10:04 -0800
Message-Id: <1289931004-16066-1-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.2.3
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the paths for files that are including verify_cpu.S.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/verify_cpu.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 5644b4b..0edefc1 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -17,9 +17,9 @@
  *	file is included at various places and compiled in that context.
  *	This file is expected to run in 32bit code.  Currently:
  *
- *	arch/x86_64/boot/compressed/head_64.S: Boot cpu verification
- *	arch/x86_64/kernel/trampoline_64.S: secondary processor verfication
- *	arch/x86_64/kernel/head_32.S: processor startup
+ *	arch/x86/boot/compressed/head_64.S: Boot cpu verification
+ *	arch/x86/kernel/trampoline_64.S: secondary processor verfication
+ *	arch/x86/kernel/head_32.S: processor startup
  *
  *	verify_cpu, returns the status of longmode and SSE in register %eax.
  *		0: Success    1: Failure
-- 
1.7.2.3

