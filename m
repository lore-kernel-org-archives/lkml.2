Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0IPWXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab0IPWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 07/34] union-mount: Add CONFIG_UNION_MOUNT option
Date: Thu, 16 Sep 2010 15:11:58 -0700
Message-Id: <1284675145-4391-8-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_UNION_MOUNT option.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 5f85b59..47409c9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -59,6 +59,19 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
+config UNION_MOUNT
+       bool "Union mounts (writable overlays) (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       help
+         Union mounts allow you to mount a transparent writable
+	 layer over a read-only file system, for example, an ext3
+	 partition on a hard drive over a CD-ROM root file system
+	 image.
+
+	 See <file:Documentation/filesystems/union-mounts.txt> for details.
+
+	 If unsure, say N.
+
 source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
-- 
1.6.3.3

