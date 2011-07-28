Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1G1FRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:51303 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1G1FQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 09/11] net: sch_generic remove redundant use of <linux/module.h>
Date: Thu, 28 Jul 2011 01:16:16 -0400
Message-Id: <1311830178-30314-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file has modular references, but they are limited to
those which are covered by the simple "struct module;"
declaration used in dozens of other places.  In fact that
declaration is already there (just outside of the context
of this commit) so simply remove the include line.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/sch_generic.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 4fc88f3..7f7ebee 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -4,7 +4,6 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
 #include <linux/pkt_sched.h>
 #include <linux/pkt_cls.h>
 #include <net/gen_stats.h>
-- 
1.7.6

