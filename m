Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2DPLXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:23:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2DPLXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:23:06 -0400
Date: Mon, 16 Apr 2012 04:22:49 -0700
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-d7de8649f34d45041409d1af4ba4a521971a9075@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de
In-Reply-To: <20120411151238.GA4794@alberich.amd.com>
References: <20120411151238.GA4794@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/amd:
  Remove broken links from comment and kernel message
Git-Commit-ID: d7de8649f34d45041409d1af4ba4a521971a9075
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Apr 2012 04:22:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7de8649f34d45041409d1af4ba4a521971a9075
Gitweb:     http://git.kernel.org/tip/d7de8649f34d45041409d1af4ba4a521971a9075
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Wed, 11 Apr 2012 17:12:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Apr 2012 08:53:43 +0200

x86/amd: Remove broken links from comment and kernel message

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20120411151238.GA4794@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0a44b90..1248f9c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -26,7 +26,8 @@
  *	contact AMD for precise details and a CPU swap.
  *
  *	See	http://www.multimania.com/poulot/k6bug.html
- *		http://www.amd.com/K6/k6docs/revgd.html
+ *	and	section 2.6.2 of "AMD-K6 Processor Revision Guide - Model 6"
+ *		(Publication # 21266  Issue Date: August 1998)
  *
  *	The following test is erm.. interesting. AMD neglected to up
  *	the chip setting when fixing the bug but they also tweaked some
@@ -94,7 +95,6 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 				"system stability may be impaired when more than 32 MB are used.\n");
 		else
 			printk(KERN_CONT "probably OK (after B9730xxxx).\n");
-		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
 	}
 
 	/* K6 with old style WHCR */
