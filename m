Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab1KDSXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:23:04 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42902 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932862Ab1KDSXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:23:00 -0400
Message-ID: <4EB42D56.8070503@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 3/8] Documentation: fix inotify source file paths
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Paulo de Souza <marcos.mage@gmail.com>

Fixes the path to find the source files of the inotify subsystem.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/filesystems/inotify.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx1104.orig/Documentation/filesystems/inotify.txt
+++ lnx1104/Documentation/filesystems/inotify.txt
@@ -194,7 +194,8 @@ associated with the inotify_handle, and
 Each watch is associated with an inotify_watch structure.  Watches are chained
 off of each associated inotify_handle and each associated inode.
 
-See fs/inotify.c and fs/inotify_user.c for the locking and lifetime rules.
+See fs/notify/inotify/inotify_fsnotify.c and fs/notify/inotify/inotify_user.c
+for the locking and lifetime rules.
 
 
 (vi) Rationale
