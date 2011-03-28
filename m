Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1C1Qbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:31:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab1C1Qas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tsk6yuLFFi8fY9KvSC6I9DYdXVWwV2RN1mGRIuvTsQgOFWS3G7JPK0Y+XMulSvwsBX
         EHTiO026ct4lMrsWSd775psOuNM5/JeN9EQjNniSud4Y9oVBXDm6a5ZFf6DLvxOrYz8i
         hC5JVx/q23Z13qgvIRCkoXlIFSFYRofXQ9ZPE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 22/25]kernel:power Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:45 -0700
Message-Id: <1301329788-3423-23-git-send-email-justinmattock@gmail.com>
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
 kernel/power/snapshot.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index ca0aacc..68c20c9 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -10,7 +10,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/suspend.h>
-- 
1.7.4.1

