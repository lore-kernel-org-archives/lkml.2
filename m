Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1CPVN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:13:26 -0400
Received: from kroah.org ([198.145.64.141]:60912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1CPVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Javi Merino <cibervicho@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/50] kref: Fix typo in kref documentation
Date: Wed, 16 Mar 2011 14:11:19 -0700
Message-Id: <1300309888-5028-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javi Merino <cibervicho@gmail.com>

container_of() should refer to the struct created in the example.

Signed-off-by: Javi Merino <cibervicho@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kref.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kref.txt b/Documentation/kref.txt
index ae203f9..48ba715 100644
--- a/Documentation/kref.txt
+++ b/Documentation/kref.txt
@@ -156,7 +156,7 @@ static struct my_data *get_entry()
 	struct my_data *entry = NULL;
 	mutex_lock(&mutex);
 	if (!list_empty(&q)) {
-		entry = container_of(q.next, struct my_q_entry, link);
+		entry = container_of(q.next, struct my_data, link);
 		kref_get(&entry->refcount);
 	}
 	mutex_unlock(&mutex);
-- 
1.7.4.1

