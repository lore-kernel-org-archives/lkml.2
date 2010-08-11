Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0HKR3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:29:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2390 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab0HKR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:29:11 -0400
Subject: [PATCH] scripts/checkpatch.pl: Add additional attribute #defines
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: apw@canonical.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100811163505.GB26497@redhat.com>
References: <20100811163505.GB26497@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 10:29:08 -0700
Message-ID: <1281547748.3976.41.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 12:35 -0400, Dave Jones wrote:
> I just got this from a patch I merged..
> 
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #121: FILE: arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c:113:
> +static struct pcc_cpu __percpu *pcc_cpu_info;
>                                 ^
> which doesn't seem right.

Perhaps these need to be added to checkpatch.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..51ba019 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -150,6 +150,20 @@ our $Sparse	= qr{
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




