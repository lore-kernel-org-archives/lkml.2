Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2GPCfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:35:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:46677 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2GPCfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:35:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177812526"
From: Alex Shi <alex.shi@intel.com>
To: rusty@rustcorp.com.au, kosaki.motohiro@jp.fujitsu.com
Cc: alex.shi@intel.com, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cpumask: cpumask_scnprintf() comments correction
Date: Mon, 16 Jul 2012 10:35:54 +0800
Message-Id: <1342406154-24001-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function has no parameter @len now, so need to remove it from
comments to avoid kernel-doc warning:

alexs@debian:~/linux-next$ scripts/kernel-doc -man
include/linux/cpumask.h | split-man.pl /tmp/man
....
Creating /tmp/man/cpumask_scnprintf.9
Warning(include/linux/cpumask.h:602): Excess function parameter 'len'
description in 'cpulist_parse'

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/cpumask.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 8bf1c27..5bad959 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -593,7 +593,6 @@ static inline int cpulist_scnprintf(char *buf, int len,
 /**
  * cpulist_parse_user - extract a cpumask from a user string of ranges
  * @buf: the buffer to extract from
- * @len: the length of the buffer
  * @dstp: the cpumask to set.
  *
  * Returns -errno, or 0 for success.
-- 
1.7.5.4

