Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1ANKHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:07:01 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37399 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab1ANKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:06:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>
Cc: ecryptfs-devel@lists.launchpad.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Piotr Hosowicz <piotr@hosowicz.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] fs: ecryptfs: fix build failure
Date: Fri, 14 Jan 2011 12:06:50 +0200
Message-Id: <1294999610-16783-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The missing <linux/fs.h> caused a compile
error due the missing definition of
struct inode.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 fs/ecryptfs/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d3b28ab..d2e71a2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/key.h>
 #include <linux/parser.h>
+#include <linux/fs.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
 #include "ecryptfs_kernel.h"
-- 
1.7.3.4.598.g85356

