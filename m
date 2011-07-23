Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1GWBJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:09:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59522 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1GWBI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:08:59 -0400
Message-ID: <4E2A1F21.5060604@gmail.com>
Date: Sat, 23 Jul 2011 09:08:49 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext3.txt: update the links in the section "useful links"
 to the latest ones
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.0.

In Documentation/filesystems/ext3.txt, the section "useful links"
provides two links which link to ibm developerworks articles. While
the second one can be redirected to the latest one, the first one
   http://www.ibm.com/developerworks/library/l-fs7.html
fails to be redirected.

Update the 2 links to the latest ones.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 Documentation/filesystems/ext3.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 272f80d..a779614 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -227,5 +227,5 @@ kernel source:	<file:fs/ext3/>
 programs: 	http://e2fsprogs.sourceforge.net/
 		http://ext2resize.sourceforge.net
 
-useful links:	http://www.ibm.com/developerworks/library/l-fs7.html
-		http://www.ibm.com/developerworks/library/l-fs8.html
+useful links:	http://www.ibm.com/developerworks/library/l-fs7/index.html
+        http://www.ibm.com/developerworks/library/l-fs8/index.html
-- 
1.7.1

