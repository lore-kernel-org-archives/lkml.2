Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2BUTwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:52:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab2BUTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/73] union-mount: Add CONFIG_UNION_MOUNT option [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:03 +0000
Message-ID: <20120221180003.25235.77675.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Add CONFIG_UNION_MOUNT option.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d621f02..6fc3c69 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -61,6 +61,18 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
+config UNION_MOUNT
+       bool "Union mounts (writable overlays) (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       help
+         Union mounts allow you to mount a transparent writable layer over a
+	 read-only file system, for example, an ext3 partition on a hard drive
+	 over a CD-ROM root file system image.
+
+	 See <file:Documentation/filesystems/union-mounts.txt> for details.
+
+	 If unsure, say N.
+
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 

