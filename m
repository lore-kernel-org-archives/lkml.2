Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2EGCsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:48:37 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43147 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2EGCsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:48:35 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, wuzhy@linux.vnet.ibm.com
Subject: [PATCH] kobject: fix the uncorrect comment
Date: Mon,  7 May 2012 10:48:25 +0800
Message-Id: <1336358905-26456-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050702-6148-0000-0000-0000059E1FA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 lib/kobject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index aeefa8b..575f4c2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -634,7 +634,7 @@ struct kobject *kobject_create(void)
 /**
  * kobject_create_and_add - create a struct kobject dynamically and register it with sysfs
  *
- * @name: the name for the kset
+ * @name: the name for the kobject
  * @parent: the parent kobject of this kobject, if any.
  *
  * This function creates a kobject structure dynamically and registers it
-- 
1.7.6

