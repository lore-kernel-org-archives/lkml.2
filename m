Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3ACLor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:44:47 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56715 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3ACLmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:42:52 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-9e-50e56eba8e21
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/8] fs/configfs: include/linux/configfs.h checkpatch cleanup
Date: Thu, 03 Jan 2013 12:42:34 +0100
Message-id: <1357213361-23620-2-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
References: <"Message-id: <CAHdPZaNZQcS3YggV5rGkBGULp3BBBXXeeRn4BhTgNfLci0=AwA"@mail.gmail.com>
 <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xq7q78p4GGBy5y2dxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy3h29yViwVrXiy0WxBsZu+S5GTg4JAROJDytXMEPYYhIX7q1n
	62Lk4hASWMoosbC3mQXC2cAk8b/xNRtIFZuAscTegx2MILaIgILE5t5nrCBFzALrGSUm3m8A
	SwgL+EpMW3kKrIFFQFWi48p6JhCbV8BVYvmJmWwQ6+Qlnt7vA7M5BdwkVvYvYYXYNpdR4tvS
	9awTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAjx+pcdjIuPWR1iFOBgVOLhXVHz
	JECINbGsuDL3EKMEB7OSCO/1HKAQb0piZVVqUX58UWlOavEhRiYOTqkGxly/3gnHN2eKXczy
	YX2aqTOF+dH6z9N6D2vEXOEOdckLfmUbmHDoQRKnlPSqUzV8K85ILP+04voj6wtXCjh/ilYu
	LtF5cKrU+5TrCc82z8xfWjfCGY0M1ndc+ZAY6Vi5qKbr2PNWlZgDCr1+Fts2/5V3TbbZe2hR
	hI7pj29Fn1mYZz9/Y8e7SImlOCPRUIu5qDgRAM9aIL7YAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate checkpatch errors and warnings

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/configfs.h |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 34025df..5d33a25 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * Based on kobject.h:
  *      Copyright (c) 2002-2003	Patrick Mochel
@@ -66,7 +66,7 @@ struct config_item {
 
 extern int config_item_set_name(struct config_item *, const char *, ...);
 
-static inline char *config_item_name(struct config_item * item)
+static inline char *config_item_name(struct config_item *item)
 {
 	return item->ci_name;
 }
@@ -76,7 +76,7 @@ extern void config_item_init_type_name(struct config_item *item,
 				       const char *name,
 				       struct config_item_type *type);
 
-extern struct config_item * config_item_get(struct config_item *);
+extern struct config_item *config_item_get(struct config_item *);
 extern void config_item_put(struct config_item *);
 
 struct config_item_type {
@@ -93,7 +93,7 @@ struct config_item_type {
 struct config_group {
 	struct config_item		cg_item;
 	struct list_head		cg_children;
-	struct configfs_subsystem 	*cg_subsys;
+	struct configfs_subsystem	*cg_subsys;
 	struct config_group		**default_groups;
 };
 
@@ -104,7 +104,7 @@ extern void config_group_init_type_name(struct config_group *group,
 
 static inline struct config_group *to_config_group(struct config_item *item)
 {
-	return item ? container_of(item,struct config_group,cg_item) : NULL;
+	return item ? container_of(item, struct config_group, cg_item) : NULL;
 }
 
 static inline struct config_group *config_group_get(struct config_group *group)
@@ -123,7 +123,7 @@ extern struct config_item *config_group_find_item(struct config_group *,
 
 struct configfs_attribute {
 	const char		*ca_name;
-	struct module 		*ca_owner;
+	struct module		*ca_owner;
 	umode_t			ca_mode;
 };
 
@@ -223,17 +223,23 @@ static ssize_t _item##_attr_store(struct config_item *item,		\
  */
 struct configfs_item_operations {
 	void (*release)(struct config_item *);
-	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
-	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
+	ssize_t	(*show_attribute)(struct config_item *,
+				  struct configfs_attribute *, char *);
+	ssize_t	(*store_attribute)(struct config_item *,
+				   struct configfs_attribute *,
+				   const char *, size_t);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
 	int (*drop_link)(struct config_item *src, struct config_item *target);
 };
 
 struct configfs_group_operations {
-	struct config_item *(*make_item)(struct config_group *group, const char *name);
-	struct config_group *(*make_group)(struct config_group *group, const char *name);
+	struct config_item *(*make_item)(struct config_group *group,
+					 const char *name);
+	struct config_group *(*make_group)(struct config_group *group,
+					   const char *name);
 	int (*commit_item)(struct config_item *item);
-	void (*disconnect_notify)(struct config_group *group, struct config_item *item);
+	void (*disconnect_notify)(struct config_group *group,
+				  struct config_item *item);
 	void (*drop_item)(struct config_group *group, struct config_item *item);
 };
 
@@ -242,7 +248,8 @@ struct configfs_subsystem {
 	struct mutex		su_mutex;
 };
 
-static inline struct configfs_subsystem *to_configfs_subsystem(struct config_group *group)
+static inline struct configfs_subsystem
+*to_configfs_subsystem(struct config_group *group)
 {
 	return group ?
 		container_of(group, struct configfs_subsystem, su_group) :
@@ -254,7 +261,9 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
 /* These functions can sleep and can alloc with GFP_KERNEL */
 /* WARNING: These cannot be called underneath configfs callbacks!! */
-int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
-void configfs_undepend_item(struct configfs_subsystem *subsys, struct config_item *target);
+int configfs_depend_item(struct configfs_subsystem *subsys,
+			 struct config_item *target);
+void configfs_undepend_item(struct configfs_subsystem *subsys,
+			    struct config_item *target);
 
 #endif /* _CONFIGFS_H_ */
-- 
1.7.0.4

