Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3ACLm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:42:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56715 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3ACLmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:42:53 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-a1-50e56ebad2fa
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/8] fs/configfs: configfs_internal.h checkpatch cleanup
Date: Thu, 03 Jan 2013 12:42:35 +0100
Message-id: <1357213361-23620-3-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
References: <"Message-id: <CAHdPZaNZQcS3YggV5rGkBGULp3BBBXXeeRn4BhTgNfLci0=AwA"@mail.gmail.com>
 <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xq7q78p4GGDx+oG9xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy5k/bzVzwQavi2L85zA2MT5S7GDk5JARMJE4f6mCEsMUkLtxb
	z9bFyMUhJLCUUaL/5EdWCGcDk8T/xtdsIFVsAsYSew9CdIgIKEhs7n0GVsQssJ5RYuL9BrCE
	sICHxJH3z1hAbBYBVYnGRSdYQWxeAVeJD8dWsEGsk5d4er8PzOYUcJNY2b8EattcRolvS9ez
	TmDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjxO9fdjAuPmZ1iFGAg1GJh3dFzZMA
	IdbEsuLK3EOMEhzMSiK813OAQrwpiZVVqUX58UWlOanFhxiZODilGhgDW974OJ5RyT3zQu+Z
	KbvKqUsni6fkn3jjfsj3kfejQhW2lAl2wS+s7yyurI/szP9z566b3g/TZ1EdzYE3EuIMlL/b
	zD13/xTX58juHWGcMzv2bju44ObBHez/CifIxdtxWffmZT4ynLfn7ItXApwRi6aoZVq2vd85
	U+B0Ivfbouqg8w1p6beVWIozEg21mIuKEwGWZHbd2QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate checkpatch errors and warnings

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/configfs/configfs_internal.h |   54 +++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index b5f0a3b..4ef5d4d 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
@@ -34,11 +34,11 @@ struct configfs_dirent {
 	struct list_head	s_sibling;
 	struct list_head	s_children;
 	struct list_head	s_links;
-	void			* s_element;
+	void			*s_element;
 	int			s_type;
 	umode_t			s_mode;
-	struct dentry		* s_dentry;
-	struct iattr		* s_iattr;
+	struct dentry		*s_dentry;
+	struct iattr		*s_iattr;
 #ifdef CONFIG_LOCKDEP
 	int			s_depth;
 #endif
@@ -62,21 +62,26 @@ extern struct kmem_cache *configfs_dir_cachep;
 
 extern int configfs_is_root(struct config_item *item);
 
-extern struct inode * configfs_new_inode(umode_t mode, struct configfs_dirent *, struct super_block *);
-extern int configfs_create(struct dentry *, umode_t mode, int (*init)(struct inode *));
+extern struct inode *configfs_new_inode(umode_t mode, struct configfs_dirent *,
+					struct super_block *);
+extern int configfs_create(struct dentry *, umode_t mode,
+			   int (*init)(struct inode *));
 extern int configfs_inode_init(void);
 extern void configfs_inode_exit(void);
 
-extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
+extern int configfs_create_file(struct config_item *,
+				const struct configfs_attribute *);
 extern int configfs_make_dirent(struct configfs_dirent *,
 				struct dentry *, void *, umode_t, int);
 extern int configfs_dirent_is_ready(struct configfs_dirent *);
 
-extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
-extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
+extern int configfs_add_file(struct dentry *,
+			     const struct configfs_attribute *, int);
+extern void configfs_hash_and_remove(struct dentry *dir, const char *name);
 
-extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
-extern void configfs_drop_dentry(struct configfs_dirent *sd, struct dentry *parent);
+extern const unsigned char *configfs_get_name(struct configfs_dirent *sd);
+extern void configfs_drop_dentry(struct configfs_dirent *sd,
+				 struct dentry *parent);
 extern int configfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern struct dentry *configfs_pin_fs(void);
@@ -104,27 +109,28 @@ extern int configfs_create_link(struct configfs_symlink *sl,
 				struct dentry *parent,
 				struct dentry *dentry);
 
-static inline struct config_item * to_item(struct dentry * dentry)
+static inline struct config_item *to_item(struct dentry *dentry)
 {
-	struct configfs_dirent * sd = dentry->d_fsdata;
-	return ((struct config_item *) sd->s_element);
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	return (struct config_item *) sd->s_element;
 }
 
-static inline struct configfs_attribute * to_attr(struct dentry * dentry)
+static inline struct configfs_attribute *to_attr(struct dentry *dentry)
 {
-	struct configfs_dirent * sd = dentry->d_fsdata;
-	return ((struct configfs_attribute *) sd->s_element);
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	return (struct configfs_attribute *) sd->s_element;
 }
 
-static inline struct config_item *configfs_get_config_item(struct dentry *dentry)
+static inline struct config_item
+*configfs_get_config_item(struct dentry *dentry)
 {
-	struct config_item * item = NULL;
+	struct config_item *item = NULL;
 
 	spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
-		struct configfs_dirent * sd = dentry->d_fsdata;
+		struct configfs_dirent *sd = dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
-			struct configfs_symlink * sl = sd->s_element;
+			struct configfs_symlink *sl = sd->s_element;
 			item = config_item_get(sl->sl_target);
 		} else
 			item = config_item_get(sd->s_element);
@@ -134,7 +140,7 @@ static inline struct config_item *configfs_get_config_item(struct dentry *dentry
 	return item;
 }
 
-static inline void release_configfs_dirent(struct configfs_dirent * sd)
+static inline void release_configfs_dirent(struct configfs_dirent *sd)
 {
 	if (!(sd->s_type & CONFIGFS_ROOT)) {
 		kfree(sd->s_iattr);
@@ -142,7 +148,7 @@ static inline void release_configfs_dirent(struct configfs_dirent * sd)
 	}
 }
 
-static inline struct configfs_dirent * configfs_get(struct configfs_dirent * sd)
+static inline struct configfs_dirent *configfs_get(struct configfs_dirent *sd)
 {
 	if (sd) {
 		WARN_ON(!atomic_read(&sd->s_count));
@@ -151,7 +157,7 @@ static inline struct configfs_dirent * configfs_get(struct configfs_dirent * sd)
 	return sd;
 }
 
-static inline void configfs_put(struct configfs_dirent * sd)
+static inline void configfs_put(struct configfs_dirent *sd)
 {
 	WARN_ON(!atomic_read(&sd->s_count));
 	if (atomic_dec_and_test(&sd->s_count))
-- 
1.7.0.4

