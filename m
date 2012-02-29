Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894Ab2B2Hun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:50:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030857Ab2B2Hul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:50:41 -0500
Date: Tue, 28 Feb 2012 23:49:38 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-b8d43cb504a94f1070159a37c8cb23008276eff3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, nbowler@elliptictech.com, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, matt@console-pimps.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, nbowler@elliptictech.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        matt@console-pimps.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu
In-Reply-To: <20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
References: <20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, tools:
  Remove unneeded header files from tools/build.c
Git-Commit-ID: b8d43cb504a94f1070159a37c8cb23008276eff3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 23:50:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8d43cb504a94f1070159a37c8cb23008276eff3
Gitweb:     http://git.kernel.org/tip/b8d43cb504a94f1070159a37c8cb23008276eff3
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 28 Feb 2012 23:30:58 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 23:40:15 -0800

x86, tools: Remove unneeded header files from tools/build.c

We include <sys/sysmacros.h> and <asm/boot.h>, but none of those
header files actually provide anything this file needs.  Furthermore,
it breaks cross-compilation, so just remove them.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Bowler <nbowler@elliptictech.com>
Link: http://lkml.kernel.org/r/20120229111322.9eb4b23ff1672e8853ad3b3b@canb.auug.org.au
---
 arch/x86/boot/tools/build.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index f2ac95e..f3bd2e6 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -29,11 +29,9 @@
 #include <stdarg.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/sysmacros.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/mman.h>
-#include <asm/boot.h>
 #include <tools/le_byteshift.h>
 
 typedef unsigned char  u8;
