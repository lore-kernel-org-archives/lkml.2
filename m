Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1KHOpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:45:35 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37182 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1KHOpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:45:34 -0500
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Frank Arnold <frank.arnold@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, AMD: Correct align_va_addr documentation
Date: Tue,  8 Nov 2011 15:45:27 +0100
Message-Id: <1320763527-22894-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing penalties on AMD family
15h") introduced a kernel command line parameter called 'align_va_addr'
which still refers to arguments used in an earlier version of the patch
and which got changed without updating the documentation. Correct that
omission.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Documentation/kernel-parameters.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..5e22c3f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -315,8 +315,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			CPU-intensive style benchmark, and it can vary highly in
 			a microbenchmark depending on workload and compiler.
 
-			1: only for 32-bit processes
-			2: only for 64-bit processes
+			32: only for 32-bit processes
+			64: only for 64-bit processes
 			on: enable for both 32- and 64-bit processes
 			off: disable for both 32- and 64-bit processes
 
-- 
1.7.8.rc0

