Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1KEJgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 05:36:04 -0400
Received: from mailout-eu.gmx.com ([213.165.64.43]:55825 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752366Ab1KEJgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 05:36:02 -0400
X-Authenticated: #65887224
X-Provags-ID: V01U2FsdGVkX1+TSNJVquSTcEKrI2g/0JsxBn4afPu2BmB0gOz+Sr
	8piSCBt3f8Zxvl
From: Vsevolod Alekseev <vsevolod.alekseev@gmx.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Vsevolod Alekseev <vsevolod.alekseev@gmx.com>
Subject: [PATCH] trivial: fix misc typos/grammar errors in comments
Date: Sat,  5 Nov 2011 02:35:28 -0700
Message-Id: <1320485728-2103-1-git-send-email-vsevolod.alekseev@gmx.com>
X-Mailer: git-send-email 1.7.0.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various typos/grammar errors in include/linux/security.h comments (no code changes).

Signed-off-by: Vsevolod Alekseev <vsevolod.alekseev@gmx.com>
---
 include/linux/security.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 19d8e04..94c3533 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -186,7 +186,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * Security module identifier.
  *
  * @name:
- *	A string that acts as a unique identifeir for the LSM with max number
+ *	A string that acts as a unique identifier for the LSM with max number
  *	of characters = SECURITY_NAME_MAX.
  *
  * Security hooks for program execution operations.
@@ -275,7 +275,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@copy copied data which will be passed to the security module.
  *	Returns 0 if the copy was successful.
  * @sb_remount:
- *	Extracts security system specifc mount options and verifys no changes
+ *	Extracts security system specific mount options and verifies no changes
  *	are being made to those options.
  *	@sb superblock being remounted
  *	@data contains the filesystem-specific data.
@@ -380,15 +380,15 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return 0 if permission is granted.
  * @inode_mkdir:
  *	Check permissions to create a new directory in the existing directory
- *	associated with inode strcture @dir.
- *	@dir containst the inode structure of parent of the directory to be created.
+ *	associated with inode structure @dir.
+ *	@dir contains the inode structure of parent of the directory to be created.
  *	@dentry contains the dentry structure of new directory.
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
  * @path_mkdir:
  *	Check permissions to create a new directory in the existing directory
- *	associated with path strcture @path.
- *	@dir containst the path structure of parent of the directory
+ *	associated with path structure @path.
+ *	@dir contains the path structure of parent of the directory
  *	to be created.
  *	@dentry contains the dentry structure of new directory.
  *	@mode contains the mode of new directory.
@@ -578,7 +578,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@file contains the file structure.
  *	@cmd contains the operation to perform.
  *	@arg contains the operational arguments.
- *	Check permission for an ioctl operation on @file.  Note that @arg can
+ *	Check permission for an ioctl operation on @file.  Note that @arg
  *	sometimes represents a user space pointer; in other cases, it may be a
  *	simple integer value.  When @arg represents a user space pointer, it
  *	should never be used by the security module.
@@ -606,7 +606,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return 0 if permission is granted.
  * @file_fcntl:
  *	Check permission before allowing the file operation specified by @cmd
- *	from being performed on the file @file.  Note that @arg can sometimes
+ *	from being performed on the file @file.  Note that @arg sometimes
  *	represents a user space pointer; in other cases, it may be a simple
  *	integer value.  When @arg represents a user space pointer, it should
  *	never be used by the security module.
@@ -793,7 +793,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	information can be saved using the eff_cap field of the
  *	netlink_skb_parms structure.  Also may be used to provide fine
  *	grained control over message transmission.
- *	@sk associated sock of task sending the message.,
+ *	@sk associated sock of task sending the message.
  *	@skb contains the sk_buff structure for the netlink message.
  *	Return 0 if the information was successfully saved and message
  *	is allowed to be transmitted.
@@ -1080,9 +1080,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	should free it.
  *	@key points to the key to be queried.
  *	@_buffer points to a pointer that should be set to point to the
- *	 resulting string (if no label or an error occurs).
+ *	resulting string (if no label or an error occurs).
  *	Return the length of the string (including terminating NUL) or -ve if
- *      an error.
+ *	an error.
  *	May also return 0 (and a NULL buffer pointer) if there is no label.
  *
  * Security hooks affecting all System V IPC operations.
@@ -1268,7 +1268,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	credentials.
  *	@tsk contains the task_struct for the process.
  *	@cred contains the credentials to use.
- *      @ns contains the user namespace we want the capability in
+ *	@ns contains the user namespace we want the capability in
  *	@cap contains the capability <include/linux/capability.h>.
  *	@audit: Whether to write an audit message or not
  *	Return 0 if the capability is granted for @tsk.
@@ -1370,7 +1370,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * 	@ctxlen contains the length of @ctx.
  *
  * @inode_getsecctx:
- * 	Returns a string containing all relavent security context information
+ *	Returns a string containing all relevant security context information
  *
  * 	@inode we wish to get the security context of.
  *	@ctx is a pointer in which to place the allocated security context.
-- 
1.6.3.3

