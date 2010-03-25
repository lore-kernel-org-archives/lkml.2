Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0CYRX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:28 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0CYRXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kbcpKQjyl5rDdyC5TA8XcfHP5s2ZPfZKEmGuS9vGxi6So8x9lAWWNmdXC/Nx2wmQeV
         vAamGWykFqfkeyFuDRPO0sCi8MzuVVjlaTWqBXmXfXy+X6EWD3Mahv6umyyrcgnYP5on
         woIJhAZaNylHf6VEbooOYFG9mowG7xbMJKBMw=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Alex Elder <aelder@sgi.com>,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@lst.de>,
       Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] XFS xfs_trace.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:41 +0100
Message-Id: <1269537767-7553-11-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/xfs/linux-2.6/xfs_trace.c: xfs_attr_sf.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/xfs/linux-2.6/xfs_trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
index 5a10760..cb840e0 100644
--- a/fs/xfs/linux-2.6/xfs_trace.c
+++ b/fs/xfs/linux-2.6/xfs_trace.c
@@ -41,7 +41,6 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
-#include "xfs_attr_sf.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_log_priv.h"
 #include "xfs_buf_item.h"
-- 
1.7.0.3.296.g9776a

