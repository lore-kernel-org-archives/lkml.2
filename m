Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab2LTWi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:38:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2LTWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:38:21 -0500
Date: Thu, 20 Dec 2012 14:37:59 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-6444174548f6556fcf26c84d5296defd295914c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, cpw@sgi.com, alex.shi@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, cpw@sgi.com, tglx@linutronix.de,
        alex.shi@intel.com, hpa@linux.intel.com
In-Reply-To: <1356030701-16284-26-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-26-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] arch/x86/platform/uv:
  use ARRAY_SIZE where possible
Git-Commit-ID: 6444174548f6556fcf26c84d5296defd295914c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Dec 2012 14:38:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6444174548f6556fcf26c84d5296defd295914c4
Gitweb:     http://git.kernel.org/tip/6444174548f6556fcf26c84d5296defd295914c4
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:34 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Dec 2012 11:49:39 -0800

arch/x86/platform/uv: use ARRAY_SIZE where possible

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/r/1356030701-16284-26-git-send-email-sasha.levin@oracle.com
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Alex Shi <alex.shi@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/uv/tlb_uv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index b8b3a37..933bea5 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1463,7 +1463,7 @@ static ssize_t ptc_proc_write(struct file *file, const char __user *user,
 	}
 
 	if (input_arg == 0) {
-		elements = sizeof(stat_description)/sizeof(*stat_description);
+		elements = ARRAY_SIZE(stat_description);
 		printk(KERN_DEBUG "# cpu:      cpu number\n");
 		printk(KERN_DEBUG "Sender statistics:\n");
 		for (i = 0; i < elements; i++)
@@ -1504,7 +1504,7 @@ static int parse_tunables_write(struct bau_control *bcp, char *instr,
 	char *q;
 	int cnt = 0;
 	int val;
-	int e = sizeof(tunables) / sizeof(*tunables);
+	int e = ARRAY_SIZE(tunables);
 
 	p = instr + strspn(instr, WHITESPACE);
 	q = p;
