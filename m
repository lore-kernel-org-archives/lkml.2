Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0DIDah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:30:37 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:54852 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0DIDad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=P/NKFRK84rGjZC/cTN5iZAiS2Yd23/AGuMZJLeF06k3Rsd3Ojh+K1nT0O0fSu0Il1g
         5yyLoPve0eCyAdQH1BklBAXz4GZ9WaX2iMdeox+6L6uXfO35pGRFg66TIs4tRLzpRDXA
         RqsMOr1wE0nggXIPgv3ox1weZ0tfiElqGSsvg=
Date: Fri, 9 Apr 2010 19:30:29 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: [PATCH] Security: Fix coding style in security/
Message-ID: <20100409113029.GB2994@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in security/

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/selinux/selinuxfs.c   |   44 ++++++++++++++++++++--------------------
 security/selinux/ss/mls.c      |    2 +-
 security/selinux/ss/policydb.c |    4 +-
 security/selinux/ss/services.c |   12 +++++-----
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index cd191bb..0293843 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -503,11 +503,11 @@ static ssize_t sel_write_access(struct file *file, char *buf, size_t size)
 		return length;
 
 	length = -ENOMEM;
-	scon = kzalloc(size+1, GFP_KERNEL);
+	scon = kzalloc(size + 1, GFP_KERNEL);
 	if (!scon)
 		return length;
 
-	tcon = kzalloc(size+1, GFP_KERNEL);
+	tcon = kzalloc(size + 1, GFP_KERNEL);
 	if (!tcon)
 		goto out;
 
@@ -515,10 +515,10 @@ static ssize_t sel_write_access(struct file *file, char *buf, size_t size)
 	if (sscanf(buf, "%s %s %hu", scon, tcon, &tclass) != 3)
 		goto out2;
 
-	length = security_context_to_sid(scon, strlen(scon)+1, &ssid);
+	length = security_context_to_sid(scon, strlen(scon) + 1, &ssid);
 	if (length < 0)
 		goto out2;
-	length = security_context_to_sid(tcon, strlen(tcon)+1, &tsid);
+	length = security_context_to_sid(tcon, strlen(tcon) + 1, &tsid);
 	if (length < 0)
 		goto out2;
 
@@ -550,11 +550,11 @@ static ssize_t sel_write_create(struct file *file, char *buf, size_t size)
 		return length;
 
 	length = -ENOMEM;
-	scon = kzalloc(size+1, GFP_KERNEL);
+	scon = kzalloc(size + 1, GFP_KERNEL);
 	if (!scon)
 		return length;
 
-	tcon = kzalloc(size+1, GFP_KERNEL);
+	tcon = kzalloc(size + 1, GFP_KERNEL);
 	if (!tcon)
 		goto out;
 
@@ -562,10 +562,10 @@ static ssize_t sel_write_create(struct file *file, char *buf, size_t size)
 	if (sscanf(buf, "%s %s %hu", scon, tcon, &tclass) != 3)
 		goto out2;
 
-	length = security_context_to_sid(scon, strlen(scon)+1, &ssid);
+	length = security_context_to_sid(scon, strlen(scon) + 1, &ssid);
 	if (length < 0)
 		goto out2;
-	length = security_context_to_sid(tcon, strlen(tcon)+1, &tsid);
+	length = security_context_to_sid(tcon, strlen(tcon) + 1, &tsid);
 	if (length < 0)
 		goto out2;
 
@@ -609,11 +609,11 @@ static ssize_t sel_write_relabel(struct file *file, char *buf, size_t size)
 		return length;
 
 	length = -ENOMEM;
-	scon = kzalloc(size+1, GFP_KERNEL);
+	scon = kzalloc(size + 1, GFP_KERNEL);
 	if (!scon)
 		return length;
 
-	tcon = kzalloc(size+1, GFP_KERNEL);
+	tcon = kzalloc(size + 1, GFP_KERNEL);
 	if (!tcon)
 		goto out;
 
@@ -621,10 +621,10 @@ static ssize_t sel_write_relabel(struct file *file, char *buf, size_t size)
 	if (sscanf(buf, "%s %s %hu", scon, tcon, &tclass) != 3)
 		goto out2;
 
-	length = security_context_to_sid(scon, strlen(scon)+1, &ssid);
+	length = security_context_to_sid(scon, strlen(scon) + 1, &ssid);
 	if (length < 0)
 		goto out2;
-	length = security_context_to_sid(tcon, strlen(tcon)+1, &tsid);
+	length = security_context_to_sid(tcon, strlen(tcon) + 1, &tsid);
 	if (length < 0)
 		goto out2;
 
@@ -666,11 +666,11 @@ static ssize_t sel_write_user(struct file *file, char *buf, size_t size)
 		return length;
 
 	length = -ENOMEM;
-	con = kzalloc(size+1, GFP_KERNEL);
+	con = kzalloc(size + 1, GFP_KERNEL);
 	if (!con)
 		return length;
 
-	user = kzalloc(size+1, GFP_KERNEL);
+	user = kzalloc(size + 1, GFP_KERNEL);
 	if (!user)
 		goto out;
 
@@ -678,7 +678,7 @@ static ssize_t sel_write_user(struct file *file, char *buf, size_t size)
 	if (sscanf(buf, "%s %s", con, user) != 2)
 		goto out2;
 
-	length = security_context_to_sid(con, strlen(con)+1, &sid);
+	length = security_context_to_sid(con, strlen(con) + 1, &sid);
 	if (length < 0)
 		goto out2;
 
@@ -727,11 +727,11 @@ static ssize_t sel_write_member(struct file *file, char *buf, size_t size)
 		return length;
 
 	length = -ENOMEM;
-	scon = kzalloc(size+1, GFP_KERNEL);
+	scon = kzalloc(size + 1, GFP_KERNEL);
 	if (!scon)
 		return length;
 
-	tcon = kzalloc(size+1, GFP_KERNEL);
+	tcon = kzalloc(size + 1, GFP_KERNEL);
 	if (!tcon)
 		goto out;
 
@@ -739,10 +739,10 @@ static ssize_t sel_write_member(struct file *file, char *buf, size_t size)
 	if (sscanf(buf, "%s %s %hu", scon, tcon, &tclass) != 3)
 		goto out2;
 
-	length = security_context_to_sid(scon, strlen(scon)+1, &ssid);
+	length = security_context_to_sid(scon, strlen(scon) + 1, &ssid);
 	if (length < 0)
 		goto out2;
-	length = security_context_to_sid(tcon, strlen(tcon)+1, &tsid);
+	length = security_context_to_sid(tcon, strlen(tcon) + 1, &tsid);
 	if (length < 0)
 		goto out2;
 
@@ -1401,7 +1401,7 @@ static int sel_make_perm_files(char *objclass, int classvalue,
 		}
 		inode->i_fop = &sel_perm_ops;
 		/* i+1 since perm values are 1-indexed */
-		inode->i_ino = sel_perm_to_ino(classvalue, i+1);
+		inode->i_ino = sel_perm_to_ino(classvalue, i + 1);
 		d_add(dentry, inode);
 	}
 
@@ -1489,7 +1489,7 @@ static int sel_make_classes(void)
 		goto out;
 
 	/* +2 since classes are 1-indexed */
-	last_class_ino = sel_class_to_ino(nclasses+2);
+	last_class_ino = sel_class_to_ino(nclasses + 2);
 
 	for (i = 0; i < nclasses; i++) {
 		struct dentry *class_name_dir;
@@ -1506,7 +1506,7 @@ static int sel_make_classes(void)
 			goto out1;
 
 		/* i+1 since class values are 1-indexed */
-		rc = sel_make_class_dir_entries(classes[i], i+1,
+		rc = sel_make_class_dir_entries(classes[i], i + 1,
 				class_name_dir);
 		if (rc)
 			goto out1;
diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index 372b773..b4eff7a 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -255,7 +255,7 @@ int mls_context_to_sid(struct policydb *pol,
 
 	if (!pol->mls_enabled) {
 		if (def_sid != SECSID_NULL && oldc)
-			*scontext += strlen(*scontext)+1;
+			*scontext += strlen(*scontext) + 1;
 		return 0;
 	}
 
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 23c6e53..c956458 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -156,7 +156,7 @@ static int roles_init(struct policydb *p)
 		rc = -EINVAL;
 		goto out_free_role;
 	}
-	key = kmalloc(strlen(OBJECT_R)+1, GFP_KERNEL);
+	key = kmalloc(strlen(OBJECT_R) + 1, GFP_KERNEL);
 	if (!key) {
 		rc = -ENOMEM;
 		goto out_free_role;
@@ -2195,7 +2195,7 @@ int policydb_read(struct policydb *p, void *fp)
 		rangetr_hash_eval(p->range_tr);
 	}
 
-	p->type_attr_map = kmalloc(p->p_types.nprim*sizeof(struct ebitmap), GFP_KERNEL);
+	p->type_attr_map = kmalloc(p->p_types.nprim * sizeof(struct ebitmap), GFP_KERNEL);
 	if (!p->type_attr_map)
 		goto bad;
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index cf27b3e..0b44f5a 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -274,15 +274,15 @@ static int constraint_expr_eval(struct context *scontext,
 		case CEXPR_AND:
 			BUG_ON(sp < 1);
 			sp--;
-			s[sp] &= s[sp+1];
+			s[sp] &= s[sp + 1];
 			break;
 		case CEXPR_OR:
 			BUG_ON(sp < 1);
 			sp--;
-			s[sp] |= s[sp+1];
+			s[sp] |= s[sp + 1];
 			break;
 		case CEXPR_ATTR:
-			if (sp == (CEXPR_MAXDEPTH-1))
+			if (sp == (CEXPR_MAXDEPTH - 1))
 				return 0;
 			switch (e->attr) {
 			case CEXPR_USER:
@@ -1216,7 +1216,7 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 	*sid = SECSID_NULL;
 
 	/* Copy the string so that we can modify the copy as we parse it. */
-	scontext2 = kmalloc(scontext_len+1, gfp_flags);
+	scontext2 = kmalloc(scontext_len + 1, gfp_flags);
 	if (!scontext2)
 		return -ENOMEM;
 	memcpy(scontext2, scontext, scontext_len);
@@ -2101,9 +2101,9 @@ int security_get_user_sids(u32 fromsid,
 
 	ebitmap_for_each_positive_bit(&user->roles, rnode, i) {
 		role = policydb.role_val_to_struct[i];
-		usercon.role = i+1;
+		usercon.role = i + 1;
 		ebitmap_for_each_positive_bit(&role->types, tnode, j) {
-			usercon.type = j+1;
+			usercon.type = j + 1;
 
 			if (mls_setup_user_range(fromcon, user, &usercon))
 				continue;
-- 
1.6.5.3

