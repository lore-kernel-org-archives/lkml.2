Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2GDHeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:34:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40120 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2GDHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:34:19 -0400
Date: Wed, 4 Jul 2012 15:34:24 +0800
From: Wang YanQing <udknight@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, hughd@google.com
Subject: [PATCH] radix-tree.h: remove unneeded include of kernel.h
Message-ID: <20120704073424.GA9247@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	hughd@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that we can remove the unneeded include of kernel.h
from radix-tree.h safely. Any user of radix-tree that need kernel.h
should include it separately.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 include/linux/radix-tree.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index ffc444c..34be4b1 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -24,7 +24,6 @@
 #include <linux/preempt.h>
 #include <linux/types.h>
 #include <linux/bug.h>
-#include <linux/kernel.h>
 #include <linux/rcupdate.h>
 
 /*
-- 
1.7.3.4

