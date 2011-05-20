Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1ETAMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:25 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49423 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934999Ab1ETAMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:19 -0400
X-Sasl-enc: hUkfBIyye4FN8S6GJy/FRpTgMFlbWKFnB/n2Z9pHvVLU 1305850339
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/44] SYSFS: Fix erroneous comments for sysfs_update_group().
Date: Thu, 19 May 2011 17:10:58 -0700
Message-Id: <1305850262-9575-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Fix what is clearly a simple copy-and-paste error in commenting the
sysfs_update_group() routine.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/group.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index c8769dc..194414f 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -101,9 +101,9 @@ int sysfs_create_group(struct kobject *kobj,
 }
 
 /**
- * sysfs_update_group - given a directory kobject, create an attribute group
- * @kobj:	The kobject to create the group on
- * @grp:	The attribute group to create
+ * sysfs_update_group - given a directory kobject, update an attribute group
+ * @kobj:	The kobject to update the group on
+ * @grp:	The attribute group to update
  *
  * This function updates an attribute group.  Unlike
  * sysfs_create_group(), it will explicitly not warn or error if any
-- 
1.7.4.2

