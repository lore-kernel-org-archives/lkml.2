Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab1ESJKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab1ESJKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:40 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 27/32] GFS2: Inode.c is empty now, remove it
Date: Thu, 19 May 2011 09:47:22 +0100
Message-Id: <1305794847-3291-28-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index f3d23ef..d22edbb 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,7 +1,7 @@
 ccflags-y := -I$(src)
 obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o dir.o xattr.o glock.o \
-	glops.o inode.o log.o lops.o main.o meta_io.o \
+	glops.o log.o lops.o main.o meta_io.o \
 	aops.o dentry.o export.o file.o \
 	ops_fstype.o ops_inode.o quota.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
deleted file mode 100644
index 9076fbe..0000000
--- a/fs/gfs2/inode.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/posix_acl.h>
-#include <linux/sort.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/crc32.h>
-#include <linux/security.h>
-#include <linux/time.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "acl.h"
-#include "bmap.h"
-#include "dir.h"
-#include "xattr.h"
-#include "glock.h"
-#include "glops.h"
-#include "inode.h"
-#include "log.h"
-#include "meta_io.h"
-#include "quota.h"
-#include "rgrp.h"
-#include "trans.h"
-#include "util.h"
-
-
-- 
1.7.4

