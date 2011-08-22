Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1HVWtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:50650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab1HVWtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:49:19 -0400
Date: Mon, 22 Aug 2011 22:49:11 GMT
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-7a4e8beabcb5262547b364851cbdd995b6798be1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jj@chaosbits.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <alpine.LNX.2.00.1108012305570.31999@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108012305570.31999@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, cleanup: Remove unneeded version.h include from arch/x86/
Git-Commit-ID: 7a4e8beabcb5262547b364851cbdd995b6798be1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 22 Aug 2011 22:49:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a4e8beabcb5262547b364851cbdd995b6798be1
Gitweb:     http://git.kernel.org/tip/7a4e8beabcb5262547b364851cbdd995b6798be1
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Mon, 1 Aug 2011 23:07:51 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 22 Aug 2011 15:35:43 -0700

x86, cleanup: Remove unneeded version.h include from arch/x86/

It was pointed out by 'make versioncheck' that the include of
linux/version.h is not needed in arch/x86/mm/mmio-mod.c .
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1108012305570.31999@swampdragon.chaosbits.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/mmio-mod.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 67421f3..de54b9b 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/kallsyms.h>
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>
