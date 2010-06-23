Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0FWGqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:46:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35822 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0FWGqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XF+TaQdDxi9Ty5mrKbON+S/qpxPUHi8aIKiviniAVECLcUfD61AcOyfJ58/7GKLZ31
         m6g2gmg4mDtPF80vVRQTKY5DvkzKjmwfc7zZiVeI7ZO+C0O2xLwIIMoIQPp/dCI8XdP0
         +qTXpQ4FbB8e3LMYDF49dBDX6S498Uzj+nqeo=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pe1dnn@amsat.org, akpm@linux-foundation.org, tj@kernel.org,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [staging-next] [2] Staging: wl_cs.c: fixed invalid UTF-8 style issues in wl_cs.c
Date: Wed, 23 Jun 2010 12:16:41 +0530
Message-Id: <1277275601-6315-1-git-send-email-pshah.mumbai@gmail.com>
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
index f855537..fbc09b3 100644
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

