Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0GCWqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:46:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab0GCWqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XoCz7A5zD//jBFLDiVqZzS6x2yRIulHjvsRF4eFkkuMbWC7LyqsKX6FmeWFGuyL02k
         u7Lz4RvxYd53Hcfi+OQrUrnQPUTYLy47ofkx3T9ONtAzTFg6Yr5TOEGtFm6XNPPTfCaU
         5kMiV8NVc1Bcq+N9o3CjbUmKPgs+Eu+WXo7sw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Documentation:Changes update broken web addresses
Date: Sat,  3 Jul 2010 15:46:13 -0700
Message-Id: <1278197173-14816-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found some web addresses not responding, giving the cannot 
connect error when trying to load them. The below patch updates
the addresses that are not connecting with the best that I can find,  
and also fixes a couple of addresses, so people can either choose an older
version of the package and/or a newer version(i.e. ppp).

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/Changes |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index eca9f6e..4fb88f1 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -331,7 +331,7 @@ o  <ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/modules/>
 
 Mkinitrd
 --------
-o  <ftp://rawhide.redhat.com/pub/rawhide/SRPMS/SRPMS/>
+o  <https://code.launchpad.net/initrd-tools/main>
 
 E2fsprogs
 ---------
@@ -343,11 +343,11 @@ o  <http://jfs.sourceforge.net/>
 
 Reiserfsprogs
 -------------
-o  <http://www.namesys.com/pub/reiserfsprogs/reiserfsprogs-3.6.3.tar.gz>
+o  <http://www.kernel.org/pub/linux/utils/fs/reiserfs/>
 
 Xfsprogs
 --------
-o  <ftp://oss.sgi.com/projects/xfs/download/>
+o  <ftp://oss.sgi.com/projects/xfs/>
 
 Pcmciautils
 -----------
@@ -387,18 +387,18 @@ o <http://sourceforge.net/projects/fuse>
 
 mcelog
 ------
-o <ftp://ftp.kernel.org/pub/linux/utils/cpu/mce/mcelog/>
+o <ftp://ftp.kernel.org/pub/linux/utils/cpu/mce/>
 
 Networking
 **********
 
 PPP
 ---
-o  <ftp://ftp.samba.org/pub/ppp/ppp-2.4.0.tar.gz>
+o  <ftp://ftp.samba.org/pub/ppp/>
 
 Isdn4k-utils
 ------------
-o  <ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/isdn4k-utils.v3.1pre1.tar.gz>
+o  <ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/>
 
 NFS-utils
 ---------
-- 
1.7.1.rc1.21.gf3bd6

