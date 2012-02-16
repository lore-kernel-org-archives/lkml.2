Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2BPNyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:54:52 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51374 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab2BPNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:54:50 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Danny Kukawka <dkukawka@suse.de>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/nfs/dns_resolve.c: included linux/nfs_fs.h twice
Date: Thu, 16 Feb 2012 14:54:41 +0100
Message-Id: <1329400481-31627-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400490;daf762c4;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/dns_resolve.c: included 'linux/nfs_fs.h' twice. No need
to include it in the 'CONFIG_NFS_USE_NEW_IDMAPPER not defined'
block since it's already included at the top of the file.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 fs/nfs/idmap.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 2c05f19..1526b5f 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -374,8 +374,6 @@ int nfs_map_gid_to_group(const struct nfs_server *server, __u32 gid, char *buf,
 #include <linux/workqueue.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
 
-#include <linux/nfs_fs.h>
-
 #include "nfs4_fs.h"
 
 #define IDMAP_HASH_SZ          128
-- 
1.7.8.3

