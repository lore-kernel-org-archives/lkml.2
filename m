Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2JEHWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:22:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2JEHWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:22:52 -0400
Date: Fri, 5 Oct 2012 00:22:26 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-961c79761dda351b5fb263a0654b98daac130b7a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, srivatsa.bhat@linux.vnet.ibm.com,
        shai@scalemp.com, gregkh@suse.de, tglx@linutronix.de,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, srivatsa.bhat@linux.vnet.ibm.com,
        shai@scalemp.com, gregkh@suse.de, tglx@linutronix.de,
        dan.carpenter@oracle.com
In-Reply-To: <20121002083409.GM12398@elgon.mountain>
References: <20121002083409.GM12398@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/cache_info: Use ARRAY_SIZE() in amd_l3_attrs(
 )
Git-Commit-ID: 961c79761dda351b5fb263a0654b98daac130b7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 00:22:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  961c79761dda351b5fb263a0654b98daac130b7a
Gitweb:     http://git.kernel.org/tip/961c79761dda351b5fb263a0654b98daac130b7a
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 2 Oct 2012 11:34:09 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 4 Oct 2012 13:28:08 +0200

x86/cache_info: Use ARRAY_SIZE() in amd_l3_attrs()

Using ARRAY_SIZE() is more readable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Shai Fultheim <shai@scalemp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20121002083409.GM12398@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 9a7c90d..93c5451 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -991,7 +991,7 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 	if (attrs)
 		return attrs;
 
-	n = sizeof (default_attrs) / sizeof (struct attribute *);
+	n = ARRAY_SIZE(default_attrs);
 
 	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		n += 2;
