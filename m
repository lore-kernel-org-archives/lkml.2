Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1C1Qcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:32:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab1C1Qap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tRI5iOFZNxAvWW9NAIudlCYRLzdOzxeX1a7VyTLSpNvj3dgLPfBY6DMTr0n2IC32JC
         /BP/csnGGk2j8/WEbYxsEFRTJ6a0tA+iVRZ10sg/ORK1gSPWRfXGDt3aO3CosQlAeTyF
         s+clcTJJYQm89MiIKK/RWjP2lca7ZTebiHZfM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 20/25]include:linux Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:43 -0700
Message-Id: <1301329788-3423-21-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/ceph/messenger.h |    1 -
 include/linux/media.h          |    1 -
 include/media/pwc-ioctl.h      |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 31d91a6..291aa6e 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -6,7 +6,6 @@
 #include <linux/net.h>
 #include <linux/radix-tree.h>
 #include <linux/uio.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 
 #include "types.h"
diff --git a/include/linux/media.h b/include/linux/media.h
index 0ef8833..92641e2 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -25,7 +25,6 @@
 
 #include <linux/ioctl.h>
 #include <linux/types.h>
-#include <linux/version.h>
 
 #define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
 
diff --git a/include/media/pwc-ioctl.h b/include/media/pwc-ioctl.h
index 0f19779..1ed1e61 100644
--- a/include/media/pwc-ioctl.h
+++ b/include/media/pwc-ioctl.h
@@ -53,7 +53,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/version.h>
 
 /* Enumeration of image sizes */
 #define PSZ_SQCIF	0x00
-- 
1.7.4.1

