Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1C1QaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1C1QaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=R0ZQMJgKceacWyo640zPWN+1sFMyMmNfy/9hfjNjME2cFqFILWEuWsNrepVAsV/I6e
         cOnPJx4HWIPETVfWNK0+xv+SdAfg+mjaJkkScQYeI1jgB1ff2bkRzCAcAn8Pzg3MSc+p
         bR5EgZ9VrAgZRAPB3XtGRSGTPcA5qXYPnpEec=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 07/25]drivers:scsi Remove version.h since it is unused. 
Date: Mon, 28 Mar 2011 09:29:30 -0700
Message-Id: <1301329788-3423-8-git-send-email-justinmattock@gmail.com>
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
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    1 -
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index fc2cdb6..93f9bb09 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -14,7 +14,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f3a4cd7..8323c7b 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -13,7 +13,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
-- 
1.7.4.1

