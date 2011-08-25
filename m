Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1HYFXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:23:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35447 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1HYFXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:23:23 -0400
Date: Thu, 25 Aug 2011 15:23:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the moduleh tree with the lt-mtd tree
Message-Id: <20110825152321.5a961bcebffb656a8daed837@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
include/linux/mtd/mtd.h between commit 7f338a9bf785 ("mtd: style fixups
in multi-line comment, indentation") from the l2-mtd tree and commit
089f5643ba44 ("include: replace linux/module.h with "struct module"
wherever possible") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mtd/mtd.h
index ff7bae0,af31170..0000000
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@@ -41,11 -40,11 +40,13 @@@
  
  #define MTD_FAIL_ADDR_UNKNOWN -1LL
  
+ struct module;
+ 
 -/* If the erase fails, fail_addr might indicate exactly which block failed.  If
 -   fail_addr = MTD_FAIL_ADDR_UNKNOWN, the failure was not at the device level or was not
 -   specific to any particular block. */
 +/*
 + * If the erase fails, fail_addr might indicate exactly which block failed. If
 + * fail_addr = MTD_FAIL_ADDR_UNKNOWN, the failure was not at the device level
 + * or was not specific to any particular block.
 + */
  struct erase_info {
  	struct mtd_info *mtd;
  	uint64_t addr;
