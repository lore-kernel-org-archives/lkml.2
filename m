Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2CaGk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 02:40:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50319 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2CaGk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 02:40:26 -0400
Message-ID: <4F76A6CF.6080007@gmail.com>
Date: Sat, 31 Mar 2012 14:40:15 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/extent_io.c: cleanup the comment for clear_state_bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No 'delete' arg is used for clear_state_bit anymore.
Cleanup the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2862454..b67814c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -394,8 +394,7 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 
 /*
  * utility function to clear some bits in an extent state struct.
- * it will optionally wake up any one waiting on this state (wake == 1), or
- * forcibly remove the state from the tree (delete == 1).
+ * it will optionally wake up any one waiting on this state (wake == 1).
  *
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
-- 
1.7.1

