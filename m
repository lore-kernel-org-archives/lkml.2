Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0IKDNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:13:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61132 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0IKDMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m9/YS4OR9IB94kEMKluDmml3bFeqnkIztqRLEnBccXv8R/IpHHp4zoRJZdYcL7LoJz
         4naGeMq9GyhjmHyHuhOT6hStpU3wl6a3Xu36q2lgDSN0NC4aD8vn5z/pPg1i/cn5O4m2
         ls3G1DQ1Unre7eMp9TQbYCb6pozjoqgQ7n5Jg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/11]fs/reiserfs/Kconfig Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:50 -0700
Message-Id: <1284174771-7033-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
References: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.
Note:not sure if this is the bes solution for this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/reiserfs/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
index 513f431..b395d95 100644
--- a/fs/reiserfs/Kconfig
+++ b/fs/reiserfs/Kconfig
@@ -10,7 +10,7 @@ config REISERFS_FS
 
 	  In general, ReiserFS is as fast as ext2, but is very efficient with
 	  large directories and small files.  Additional patches are needed
-	  for NFS and quotas, please see <http://www.namesys.com/> for links.
+	  for NFS and quotas, please see <http://en.wikipedia.org/wiki/Namesys>.
 
 	  It is more easily extended to have features currently found in
 	  database and keyword search systems than block allocation based file
@@ -18,7 +18,7 @@ config REISERFS_FS
 	  plugins consistent with our motto ``It takes more than a license to
 	  make source code open.''
 
-	  Read <http://www.namesys.com/> to learn more about reiserfs.
+	  Read <http://en.wikipedia.org/wiki/Namesys> to learn more about reiserfs.
 
 	  Sponsored by Threshold Networks, Emusic.com, and Bigstorage.com.
 
-- 
1.7.2.1

