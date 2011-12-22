Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1LVDQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:16:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45820 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1LVDQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:16:05 -0500
Message-ID: <4EF2A0ED.8080308@gmail.com>
Date: Thu, 22 Dec 2011 11:15:57 +0800
From: "nai.xia" <nai.xia@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] radix_tree: delete orphaned macro radix_tree_indirect_to_ptr
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils> <20111221050740.GD23662@dastard> <alpine.LSU.2.00.1112202218490.4026@eggly.anvils> <20111221221527.GE23662@dastard> <alpine.LSU.2.00.1112211555430.25868@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1112211555430.25868@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems nobody has been using the macro radix_tree_indirect_to_ptr()
since long time ago. Delete it.

Signed-off-by: Nai Xia <nai.xia@gmail.com>
---
  include/linux/radix-tree.h |    3 ---
  1 files changed, 0 insertions(+), 3 deletions(-)

--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -49,9 +49,6 @@
  #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
  #define RADIX_TREE_EXCEPTIONAL_SHIFT	2

-#define radix_tree_indirect_to_ptr(ptr) \
-	radix_tree_indirect_to_ptr((void __force *)(ptr))
-
  static inline int radix_tree_is_indirect_ptr(void *ptr)
  {
  	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
