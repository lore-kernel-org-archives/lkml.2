Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab0HEW3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:29:38 -0400
Received: from kroah.org ([198.145.64.141]:37865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934595Ab0HEWZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/28] sysfs: Remove owner field from sysfs struct attribute
Date: Thu,  5 Aug 2010 15:24:17 -0700
Message-Id: <1281047058-23716-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysfs.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 8bf06b6..3c92121 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -22,14 +22,8 @@ struct kobject;
 struct module;
 enum kobj_ns_type;
 
-/* FIXME
- * The *owner field is no longer used.
- * x86 tree has been cleaned up. The owner
- * attribute is still left for other arches.
- */
 struct attribute {
 	const char		*name;
-	struct module		*owner;
 	mode_t			mode;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	*key;
-- 
1.7.2

