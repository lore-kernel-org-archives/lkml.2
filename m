Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab0DUHC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 03:02:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39046 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0DUHC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 03:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OHT6TfVDMP3rhx15AOzKEFnam7ejXxCO7XXZ8o19IhafKP9rX5kiRS1OX+kVA1gnIW
         xUz0BCTL5LE1lSaFpqZJTxKE3zYmNADyoD/WJ0wfmEgcMA9bXa/TS9VZXtQxO3V+jnMu
         6x9Wtksn4OWbJIDc3YnJlZkqSc2PWpPFlGhc8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Whitespace Coding style fixes.
Date: Wed, 21 Apr 2010 00:02:11 -0700
Message-Id: <1271833331-26973-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitespace Coding style fixes. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 security/commoncap.c       |    4 +-
 security/device_cgroup.c   |    2 +-
 security/keys/key.c        |    2 +-
 security/keys/keyctl.c     |   58 ++++++++++++++++++++++----------------------
 security/keys/keyring.c    |   20 +++++++-------
 security/keys/permission.c |    2 +-
 security/keys/proc.c       |    2 +-
 7 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..a70b682 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -570,7 +570,7 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
 	}
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
+		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
@@ -596,7 +596,7 @@ int cap_inode_removexattr(struct dentry *dentry, const char *name)
 	}
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
+		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index f77c604..8d9c48f 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -470,7 +470,7 @@ struct cgroup_subsys devices_subsys = {
 	.name = "devices",
 	.can_attach = devcgroup_can_attach,
 	.create = devcgroup_create,
-	.destroy  = devcgroup_destroy,
+	.destroy = devcgroup_destroy,
 	.populate = devcgroup_populate,
 	.subsys_id = devices_subsys_id,
 };
diff --git a/security/keys/key.c b/security/keys/key.c
index e50d264..c70da6f 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -355,7 +355,7 @@ EXPORT_SYMBOL(key_alloc);
  */
 int key_payload_reserve(struct key *key, size_t datalen)
 {
-	int delta = (int) datalen - key->datalen;
+	int delta = (int)datalen - key->datalen;
 	int ret = 0;
 
 	key_check(key);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index e9c2e7c..e550f46 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -212,15 +212,15 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
 	ret = key->serial;
 
  	key_put(key);
- error5:
+error5:
 	key_type_put(ktype);
- error4:
+error4:
 	key_ref_put(dest_ref);
- error3:
+error3:
 	kfree(callout_info);
- error2:
+error2:
 	kfree(description);
- error:
+error:
 	return ret;
 
 } /* end sys_request_key() */
@@ -246,7 +246,7 @@ long keyctl_get_keyring_ID(key_serial_t id, int create)
 
 	ret = key_ref_to_ptr(key_ref)->serial;
 	key_ref_put(key_ref);
- error:
+error:
 	return ret;
 
 } /* end keyctl_get_keyring_ID() */
@@ -275,7 +275,7 @@ long keyctl_join_session_keyring(const char __user *_name)
 	ret = join_session_keyring(name);
 	kfree(name);
 
- error:
+error:
 	return ret;
 
 } /* end keyctl_join_session_keyring() */
@@ -322,9 +322,9 @@ long keyctl_update_key(key_serial_t id,
 	ret = key_update(key_ref, payload, plen);
 
 	key_ref_put(key_ref);
- error2:
+error2:
 	kfree(payload);
- error:
+error:
 	return ret;
 
 } /* end keyctl_update_key() */
@@ -356,7 +356,7 @@ long keyctl_revoke_key(key_serial_t id)
 	ret = 0;
 
 	key_ref_put(key_ref);
- error:
+error:
 	return ret;
 
 } /* end keyctl_revoke_key() */
@@ -381,7 +381,7 @@ long keyctl_keyring_clear(key_serial_t ringid)
 	ret = keyring_clear(key_ref_to_ptr(keyring_ref));
 
 	key_ref_put(keyring_ref);
- error:
+error:
 	return ret;
 
 } /* end keyctl_keyring_clear() */
@@ -413,9 +413,9 @@ long keyctl_keyring_link(key_serial_t id, key_serial_t ringid)
 	ret = key_link(key_ref_to_ptr(keyring_ref), key_ref_to_ptr(key_ref));
 
 	key_ref_put(key_ref);
- error2:
+error2:
 	key_ref_put(keyring_ref);
- error:
+error:
 	return ret;
 
 } /* end keyctl_keyring_link() */
@@ -447,9 +447,9 @@ long keyctl_keyring_unlink(key_serial_t id, key_serial_t ringid)
 	ret = key_unlink(key_ref_to_ptr(keyring_ref), key_ref_to_ptr(key_ref));
 
 	key_ref_put(key_ref);
- error2:
+error2:
 	key_ref_put(keyring_ref);
- error:
+error:
 	return ret;
 
 } /* end keyctl_keyring_unlink() */
@@ -529,9 +529,9 @@ okay:
 	}
 
 	kfree(tmpbuf);
- error2:
+error2:
 	key_ref_put(key_ref);
- error:
+error:
 	return ret;
 
 } /* end keyctl_describe_key() */
@@ -616,17 +616,17 @@ long keyctl_keyring_search(key_serial_t ringid,
 
 	ret = key_ref_to_ptr(key_ref)->serial;
 
- error6:
+error6:
 	key_ref_put(key_ref);
- error5:
+error5:
 	key_type_put(ktype);
- error4:
+error4:
 	key_ref_put(dest_ref);
- error3:
+error3:
 	key_ref_put(keyring_ref);
- error2:
+error2:
 	kfree(description);
- error:
+error:
 	return ret;
 
 } /* end keyctl_keyring_search() */
@@ -673,7 +673,7 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 	}
 
 	/* the key is probably readable - now try to read it */
- can_read_key:
+can_read_key:
 	ret = key_validate(key);
 	if (ret == 0) {
 		ret = -EOPNOTSUPP;
@@ -686,9 +686,9 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 		}
 	}
 
- error2:
+error2:
 	key_put(key);
- error:
+error:
 	return ret;
 
 } /* end keyctl_read_key() */
@@ -1282,16 +1282,16 @@ long keyctl_session_to_parent(void)
 
 	/* the parent must have the same effective ownership and mustn't be
 	 * SUID/SGID */
-	if (pcred-> uid	!= mycred->euid	||
+	if (pcred->uid	!= mycred->euid	||
 	    pcred->euid	!= mycred->euid	||
 	    pcred->suid	!= mycred->euid	||
-	    pcred-> gid	!= mycred->egid	||
+	    pcred->gid	!= mycred->egid	||
 	    pcred->egid	!= mycred->egid	||
 	    pcred->sgid	!= mycred->egid)
 		goto not_permitted;
 
 	/* the keyrings must have the same UID */
-	if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
+	if (pcred->tgcred->session_keyring->uid != mycred->euid ||
 	    mycred->tgcred->session_keyring->uid != mycred->euid)
 		goto not_permitted;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e814d21..ca5316f 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -39,7 +39,7 @@ static inline unsigned keyring_hash(const char *desc)
 	unsigned bucket = 0;
 
 	for (; *desc; desc++)
-		bucket += (unsigned char) *desc;
+		bucket += (unsigned char)*desc;
 
 	return bucket & (KEYRING_NAME_HASH_SIZE - 1);
 }
@@ -237,7 +237,7 @@ static long keyring_read(const struct key *keyring,
 		ret = qty;
 	}
 
- error:
+error:
 	return ret;
 
 } /* end keyring_read() */
@@ -508,7 +508,7 @@ key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 	rcu_read_unlock();
 	return ERR_PTR(-ENOKEY);
 
- found:
+found:
 	atomic_inc(&key->usage);
 	rcu_read_unlock();
 	return make_key_ref(key, possessed);
@@ -565,7 +565,7 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 	read_unlock(&keyring_name_lock);
 	keyring = ERR_PTR(-ENOKEY);
 
- error:
+error:
 	return keyring;
 
 } /* end find_keyring_by_name() */
@@ -598,7 +598,7 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 	sp = 0;
 
 	/* start processing a new keyring */
- descend:
+descend:
 	if (test_bit(KEY_FLAG_REVOKED, &subtree->flags))
 		goto not_this_keyring;
 
@@ -607,7 +607,7 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 		goto not_this_keyring;
 	kix = 0;
 
- ascend:
+ascend:
 	/* iterate through the remaining keys in this keyring */
 	for (; kix < keylist->nkeys; kix++) {
 		key = keylist->keys[kix];
@@ -633,7 +633,7 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 
 	/* the keyring we're looking at was disqualified or didn't contain a
 	 * matching key */
- not_this_keyring:
+not_this_keyring:
 	if (sp > 0) {
 		/* resume the checking of a keyring higher up in the tree */
 		sp--;
@@ -644,15 +644,15 @@ static int keyring_detect_cycle(struct key *A, struct key *B)
 
 	ret = 0; /* no cycles detected */
 
- error:
+error:
 	rcu_read_unlock();
 	return ret;
 
- too_deep:
+too_deep:
 	ret = -ELOOP;
 	goto error;
 
- cycle_detected:
+cycle_detected:
 	ret = -EDEADLK;
 	goto error;
 
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 0ed802c..2864550 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -109,7 +109,7 @@ int key_validate(struct key *key)
 		}
 	}
 
- error:
+error:
 	return ret;
 
 } /* end key_validate() */
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 706d63f..068b66e 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -306,7 +306,7 @@ static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
 static void *proc_key_users_next(struct seq_file *p, void *v, loff_t *_pos)
 {
 	(*_pos)++;
-	return key_user_next((struct rb_node *) v);
+	return key_user_next((struct rb_node *)v);
 }
 
 static void proc_key_users_stop(struct seq_file *p, void *v)
-- 
1.6.5.GIT

