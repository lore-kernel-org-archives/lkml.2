Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2HAEy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:54:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62493 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2HAEyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:54:46 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 1/5] Fix comment/license formatting in android/ashmem.c
Date: Wed,  1 Aug 2012 14:54:16 +1000
Message-Id: <1343796860-7025-2-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/ashmem.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 69cf2db..94a740d 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -1,20 +1,20 @@
 /* mm/ashmem.c
-**
-** Anonymous Shared Memory Subsystem, ashmem
-**
-** Copyright (C) 2008 Google, Inc.
-**
-** Robert Love <rlove@google.com>
-**
-** This software is licensed under the terms of the GNU General Public
-** License version 2, as published by the Free Software Foundation, and
-** may be copied, distributed, and modified under those terms.
-**
-** This program is distributed in the hope that it will be useful,
-** but WITHOUT ANY WARRANTY; without even the implied warranty of
-** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-** GNU General Public License for more details.
-*/
+ *
+ * Anonymous Shared Memory Subsystem, ashmem
+ *
+ * Copyright (C) 2008 Google, Inc.
+ *
+ * Robert Love <rlove@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
 
 #define pr_fmt(fmt) "ashmem: " fmt
 
-- 
1.7.9.5

