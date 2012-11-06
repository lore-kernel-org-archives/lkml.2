Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab2KFIR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:17:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:44874 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab2KFIR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="215703267"
From: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Subject: [PATCH] smack: SMACK_MAGIC to include/uapi/linux/magic.h
Date: Tue,  6 Nov 2012 10:17:49 +0200
Message-Id: <1352189869-27190-1-git-send-email-jarkko.sakkinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMACK_MAGIC moved to a proper place for easy user space access
(i.e. libsmack).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
---
 include/uapi/linux/magic.h |    1 +
 security/smack/smack.h     |    5 -----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index e15192c..12735ad 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -11,6 +11,7 @@
 #define DEBUGFS_MAGIC          0x64626720
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
+#define SMACK_MAGIC		0x43415d53	/* "SMAC" */
 #define RAMFS_MAGIC		0x858458f6	/* some random number */
 #define TMPFS_MAGIC		0x01021994
 #define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 99b3612..8ad3095 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -149,11 +149,6 @@ struct smack_known {
 #define SMACK_CIPSO_SOCKET	1
 
 /*
- * smackfs magic number
- */
-#define SMACK_MAGIC	0x43415d53 /* "SMAC" */
-
-/*
  * CIPSO defaults.
  */
 #define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */
-- 
1.7.10.4

