Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030693Ab2HWSsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:48:09 -0400
Received: from noserose.net ([66.220.18.76]:50448 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030632Ab2HWSsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:48:05 -0400
Message-Id: <ccb20e55eedd4dfe4aeb521fcbb09e1e3970940c.1345743802.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Fri, 17 Aug 2012 21:28:15 -0400
Subject: [PATCH 13/14] aoe: update copyright year in touched files
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h     |    2 +-
 drivers/block/aoe/aoeblk.c  |    2 +-
 drivers/block/aoe/aoechr.c  |    2 +-
 drivers/block/aoe/aoecmd.c  |    2 +-
 drivers/block/aoe/aoedev.c  |    2 +-
 drivers/block/aoe/aoemain.c |    2 +-
 drivers/block/aoe/aoenet.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 32aede9..27d0a21 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 #define VERSION "49"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 7ec4b8f..83160ab 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoeblk.c
  * block device routines
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 723e604..deb30c1 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoechr.c
  * AoE character device driver
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 1010c4e..d91b8d0 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoecmd.c
  * Filesystem request handling methods
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 6be7b38..ccaecff 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoedev.c
  * AoE device utility functions; maintains device list.
diff --git a/drivers/block/aoe/aoemain.c b/drivers/block/aoe/aoemain.c
index 6fc4b05..04793c2 100644
--- a/drivers/block/aoe/aoemain.c
+++ b/drivers/block/aoe/aoemain.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoemain.c
  * Module initialization routines, discover timer
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 3c923e5..162c647 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoenet.c
  * Ethernet portion of AoE driver
-- 
1.7.2.5

