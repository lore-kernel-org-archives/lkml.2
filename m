Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab1KDSXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:23:11 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:37033 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933135Ab1KDSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:23:08 -0400
Message-ID: <4EB42D5E.7090104@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 5/8] Documentation: HFS is orphaned
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Paulo de Souza <marcos.mage@gmail.com>

Removed the reference of Roman Zippel, last maintainer, of orphaned
HFS filesystem.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/filesystems/hfs.txt |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- lnx1104.orig/Documentation/filesystems/hfs.txt
+++ lnx1104/Documentation/filesystems/hfs.txt
@@ -1,3 +1,4 @@
+Note: This filesystem doesn't have a maintainer.
 
 Macintosh HFS Filesystem for Linux
 ==================================
@@ -76,8 +77,6 @@ hformat that can be used to create HFS f
 Credits
 =======
 
-The HFS drivers was written by Paul H. Hargrovea (hargrove@sccm.Stanford.EDU)
-and is now maintained by Roman Zippel (roman@ardistech.com) at Ardis
-Technologies.
-Roman rewrote large parts of the code and brought in btree routines derived
-from Brad Boyer's hfsplus driver (also maintained by Roman now).
+The HFS drivers was written by Paul H. Hargrovea (hargrove@sccm.Stanford.EDU).
+Roman Zippel (roman@ardistech.com) rewrote large parts of the code and brought
+in btree routines derived from Brad Boyer's hfsplus driver.
