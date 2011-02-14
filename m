Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1BNPAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:00:13 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:55029
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755545Ab1BNPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:00:09 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: davem@davemloft.net
Cc: jesper.nilsson@axis.com, linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] klist: removed a prohibited space
Date: Mon, 14 Feb 2011 15:59:51 +0100
Message-Id: <1297695591-12773-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4.1
X-Null-Tag: aae77e134831f4ac6062f9242be4efde
X-Authenticated-Sender: user tvh from 86.103.153.223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a prohibited space between between function name and open parenthesis '('

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 include/linux/klist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index a370ce5..6625752 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -22,7 +22,7 @@ struct klist {
 	struct list_head	k_list;
 	void			(*get)(struct klist_node *);
 	void			(*put)(struct klist_node *);
-} __attribute__ ((aligned (sizeof(void *))));
+} __attribute__ ((aligned(sizeof(void *))));
 
 #define KLIST_INIT(_name, _get, _put)					\
 	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
-- 
1.7.4.1

