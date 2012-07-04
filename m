Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2GDHPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:15:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40457 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2GDHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:15:20 -0400
Date: Wed, 4 Jul 2012 15:15:31 +0800
From: Wang YanQing <udknight@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, paul.gortmaker@windriver.com
Subject: [PATCH] rbtree.h: remove unneeded include of kernel.h
Message-ID: <20120704071531.GA9094@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	paul.gortmaker@windriver.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that we should remove the unneeded include of kernel.h
from rbtree.h, any user of rbtree need kernel.h should include it
separately.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 include/linux/rbtree.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 033b507..3cae05e 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -94,7 +94,6 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 #ifndef	_LINUX_RBTREE_H
 #define	_LINUX_RBTREE_H
 
-#include <linux/kernel.h>
 #include <linux/stddef.h>
 
 struct rb_node
-- 
1.7.3.4

