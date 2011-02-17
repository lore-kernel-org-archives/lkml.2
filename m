Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1BQIu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:50:58 -0500
Received: from vs81.sauer-cs.de ([80.244.252.81]:42689 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1BQIu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:50:57 -0500
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Feb 2011 03:50:56 EST
Date: Thu, 17 Feb 2011 11:43:39 +0300 (MSK)
From: Alexander Kurz <linux@kbdbabel.org>
X-X-Sender: linux@vs81.sauer-cs.de
To: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, romfs@googlegroups.com
Subject: [PATCH] Documentation/filesystems/romfs.txt: fixing link to
 genromfs
Message-ID: <alpine.DEB.1.10.1102171141090.3995@vs81.sauer-cs.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7d5f1c2ff9fc44d66983667705f8779ed95c7fcc Mon Sep 17 00:00:00 2001
From: Alexander Kurz <linux@kbdbabel.org>
Date: Thu, 17 Feb 2011 09:35:47 +0100
Subject: [PATCH] Documentation/filesystems/romfs.txt: fixing link to genromfs

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
---
 Documentation/filesystems/romfs.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/romfs.txt b/Documentation/filesystems/romfs.txt
index 2d2a7b2..e2b07cc 100644
--- a/Documentation/filesystems/romfs.txt
+++ b/Documentation/filesystems/romfs.txt
@@ -17,8 +17,7 @@ comparison, an actual rescue disk used up 3202 blocks with ext2, while
 with romfs, it needed 3079 blocks.
 
 To create such a file system, you'll need a user program named
-genromfs.  It is available via anonymous ftp on sunsite.unc.edu and
-its mirrors, in the /pub/Linux/system/recovery/ directory.
+genromfs. It is available on http://romfs.sourceforge.net/
 
 As the name suggests, romfs could be also used (space-efficiently) on
 various read-only media, like (E)EPROM disks if someone will have the
-- 
1.7.2.3

