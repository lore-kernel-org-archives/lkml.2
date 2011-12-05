Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab1LESEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:04:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:04:29 -0500
Date: Mon, 5 Dec 2011 10:04:04 -0800
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-8360ee2f74bda2b794bdf4e23ab19d8b4e93807f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        frank.arnold@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        frank.arnold@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1321873819-29541-1-git-send-email-bp@amd64.org>
References: <1321873819-29541-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD: Correct align_va_addr documentation
Git-Commit-ID: 8360ee2f74bda2b794bdf4e23ab19d8b4e93807f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:04:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8360ee2f74bda2b794bdf4e23ab19d8b4e93807f
Gitweb:     http://git.kernel.org/tip/8360ee2f74bda2b794bdf4e23ab19d8b4e93807f
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 21 Nov 2011 12:10:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:07:30 +0100

x86, AMD: Correct align_va_addr documentation

Commit dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing penalties
on AMD family 15h") introduced a kernel command line parameter
called 'align_va_addr' which still refers to arguments used in
an earlier version of the patch and which got changed without
updating the documentation. Correct that omission.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Frank Arnold <frank.arnold@amd.com>
Link: http://lkml.kernel.org/r/1321873819-29541-1-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
