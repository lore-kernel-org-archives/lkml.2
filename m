Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab0FJQin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:38:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57702 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab0FJQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GJP2KE8CC09F61t4q1opsT7qdLNgUEyyaWfRuAC+8Ab0OBTGYP923mJ+IxFoi49QUT
         ZkDGsacOh5CG1mZvmA8fiyrfZ5aLUvr010saJuzaAhNygAFrZp4vZJoNiYKpxy9t49pd
         DE0Pf8nMfo6SNJ2UvsdnUIdp24fZ+XN19LQnc=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pe1dnn@amsat.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tj@kernel.org, devel@driverdev.osuosl.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [staging-next] [3] Staging: wl_cs.c: fixed invalid UTF-8 style issues in wl_cs.c
Date: Thu, 10 Jun 2010 22:07:56 +0530
Message-Id: <1276187876-6619-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_cs.c file that corrects the invalid
UTF-8 encoding style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_cs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index b2120f0..52c293a 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -23,7 +23,7 @@
  * software indicates your acceptance of these terms and conditions.  If you do
  * not agree with these terms and conditions, do not use the software.
  *
- * Copyright © 2003 Agere Systems Inc.
+ * Copyright (c) 2003 Agere Systems Inc.
  * All rights reserved.
  *
  * Redistribution and use in source or binary forms, with or without
@@ -44,7 +44,7 @@
  *
  * Disclaimer
  *
- * THIS SOFTWARE IS PROVIDED “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
  * INCLUDING, BUT NOT LIMITED TO, INFRINGEMENT AND THE IMPLIED WARRANTIES OF
  * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ANY
  * USE, MODIFICATION OR DISTRIBUTION OF THIS SOFTWARE IS SOLELY AT THE USERS OWN
-- 
1.6.0.4

