Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0HRPsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51915 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0HRPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:12 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH 11/16] checkpatch: Add additional attribute #defines
Date: Wed, 18 Aug 2010 16:46:44 +0100
Message-Id: <1282146409-30544-12-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

On Wed, 2010-08-11 at 12:35 -0400, Dave Jones wrote:
> I just got this from a patch I merged..
>
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #121: FILE: arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c:113:
> +static struct pcc_cpu __percpu *pcc_cpu_info;
>                                 ^
> which doesn't seem right.

Perhaps these need to be added to checkpatch.

[apw@canonical.com: added tests]
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 93fa145..c151c9e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -152,6 +152,20 @@ our $Sparse	= qr{
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
 			const|
+			__percpu|
+			__nocast|
+			__safe|
+			__bitwise__|
+			__packed__|
+			__packed2__|
+			__naked|
+			__maybe_unused|
+			__always_unused|
+			__noreturn|
+			__used|
+			__cold|
+			__noclone|
+			__deprecated|
 			__read_mostly|
 			__kprobes|
 			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
-- 
1.7.0.4

