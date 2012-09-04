Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2IDQ2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:28:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49060 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab2IDQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:28:32 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3/3] Documentation/rbtree.txt: Mention rb_entry()
Date: Tue,  4 Sep 2012 17:28:10 +0100
Message-Id: <1346776090-4631-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
References: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention that rb_entry() can be used as a synonym for the standard
container_of() macro.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 Documentation/rbtree.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 47a8cb5..55008c3 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -64,7 +64,8 @@ Data nodes in an rbtree tree are structures containing a struct rb_node member:
   };
 
 When dealing with a pointer to the embedded struct rb_node, the containing data
-structure may be accessed with the standard container_of() macro.
+structure may be accessed with the standard container_of() macro, or by the
+rb_entry() macro which is a synonym for container_of().
 
 At the root of each rbtree is an rb_root structure, which is initialized to be
 empty via:
-- 
1.7.12

