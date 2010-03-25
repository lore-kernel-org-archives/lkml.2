Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0CYRXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:38 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab0CYRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vgLlhYbOUhbhd2YYJN2k3FSphQK6Qa5OwhTohT7ONB6gxgT+NWTrtRkySe0wfO3ihC
         M4w2Foy/cOy2a2vq8Vw2W6tYKshvZI1MPL9tmZFBPRxJDSC2ysQw9Vfv4e6Gwa2NYUyI
         RCFqky8Cj4n79bhA9s5Z4lkwR/oSK3k0FL2AY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>,
       Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] BTRFS ioctl.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:45 +0100
Message-Id: <1269537767-7553-15-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/btrfs/ioctl.c: ctree.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/btrfs/ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2845c6c..5c9f8b3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -48,7 +48,6 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
-#include "ctree.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
-- 
1.7.0.3.296.g9776a

