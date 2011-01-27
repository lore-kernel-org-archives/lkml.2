Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1A0TKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:10:34 -0500
Received: from nm19-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.59]:45772 "HELO
	nm19-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753141Ab1A0TKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:10:32 -0500
X-Yahoo-Newman-Id: 284702.35232.bm@omp1047.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Rbw7E5YVM1nG5YYhpwCXnkEU0EyBVgqiXjfsrrjAOi797Ay
 UzQ0-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/4] gfs2: Remove 'select SYSFS ...' from Kconfig
Date: Thu, 27 Jan 2011 11:10:27 -0800
Message-Id: <1296155430-3796-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
References: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

With CONFIGFS_FS now doing 'select SYSFS' by default, the extra
'select SYSFS if GFS2_FS_LOCKING_DLM' for GFS2_FS is now unnecessary.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/gfs2/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index c465ae0..ff0a8eb 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -3,7 +3,6 @@ config GFS2_FS
 	depends on (64BIT || LBDAF)
 	select DLM if GFS2_FS_LOCKING_DLM
 	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
-	select SYSFS if GFS2_FS_LOCKING_DLM
 	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
-- 
1.7.3.5

