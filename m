Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1HVTt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:49:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64081 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1HVTtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:49:24 -0400
MIME-Version: 1.0
Date: Mon, 22 Aug 2011 13:49:23 -0600
Message-ID: <CAB2gnbXbufVxXHbuW6fg+ivF0ODSjZr-q7FvNyQA0Xr6VBT_Kw@mail.gmail.com>
Subject: [PATCH 1/2] ceph: replace leading spaces with tabs
From: Noah Watkins <noahwatkins@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, sage@newdream.net,
        noahwatkins@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial formatting fix.

Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
---
 fs/ceph/super.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e0a6a06..733674d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -294,29 +294,29 @@ static int parse_mount_options(struct
ceph_mount_options **pfsopt,

 	dout("parse_mount_options %p, dev_name '%s'\n", fsopt, dev_name);

-        fsopt->sb_flags = flags;
-        fsopt->flags = CEPH_MOUNT_OPT_DEFAULT;
+	fsopt->sb_flags = flags;
+	fsopt->flags = CEPH_MOUNT_OPT_DEFAULT;

-        fsopt->rsize = CEPH_RSIZE_DEFAULT;
-        fsopt->rasize = CEPH_RASIZE_DEFAULT;
-        fsopt->snapdir_name = kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
+	fsopt->rsize = CEPH_RSIZE_DEFAULT;
+	fsopt->rasize = CEPH_RASIZE_DEFAULT;
+	fsopt->snapdir_name = kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
 	fsopt->caps_wanted_delay_min = CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
 	fsopt->caps_wanted_delay_max = CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
-        fsopt->cap_release_safety = CEPH_CAP_RELEASE_SAFETY_DEFAULT;
-        fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
-        fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
-        fsopt->congestion_kb = default_congestion_kb();
-	
-        /* ip1[:port1][,ip2[:port2]...]:/subdir/in/fs */
-        err = -EINVAL;
-        if (!dev_name)
-                goto out;
-        *path = strstr(dev_name, ":/");
-        if (*path == NULL) {
-                pr_err("device name is missing path (no :/ in %s)\n",
-                       dev_name);
-                goto out;
-        }
+	fsopt->cap_release_safety = CEPH_CAP_RELEASE_SAFETY_DEFAULT;
+	fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
+	fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
+	fsopt->congestion_kb = default_congestion_kb();
+
+	/* ip1[:port1][,ip2[:port2]...]:/subdir/in/fs */
+	err = -EINVAL;
+	if (!dev_name)
+		goto out;
+	*path = strstr(dev_name, ":/");
+	if (*path == NULL) {
+		pr_err("device name is missing path (no :/ in %s)\n",
+				dev_name);
+		goto out;
+	}
 	dev_name_end = *path;
 	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);

-- 
1.7.6
