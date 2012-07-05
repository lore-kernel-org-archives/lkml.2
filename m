Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2GEUgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:36:31 -0400
Received: from nm5-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.204]:37749 "HELO
	nm5-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405Ab2GEUg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:36:26 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 16:36:26 EDT
X-Yahoo-Newman-Id: 102907.11247.bm@smtp224.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tsMhdQAVM1lSV33whyZwkOTZIw89RKix9yTu12TcZxDNacf
 Ny5zeZccjyV5D9xIznarGuOv90uU3vd.FxGeTrGNPe_h.4GGcxoyP8sKzJmB
 6pYU8YmIcK50QgcjKa.liIHsOXq_8JW69fCOGdeGyiwFt9EWSNIt2jWIEC4o
 7s7mXu6NcCVlHH4Zv37.6GRGsGotWTf2mlXDGXWk3iYnGXtEc7TD7tjbPPRq
 UFXRBhFO8RTGT.U4Fj1wHbAtgrgc3XyK5_WU4ZVIMJOdi6zxtN.UrRKlopvc
 bYnAq3Px6lqyqtqHFV0cUI5QeSiFCIMZ0Lw1_vjknTxsvCw21b.DTSMdCpNs
 875YnBZVStZkfdcPdGpenLG5KAy5CwmtNzOG9VS.nXcYhaNin43XhSXZ2Ffg
 u0rTek_yWbkyDk9oIFEOxA8iRSw1EtZJM0lWmeJK0ACc-
X-Yahoo-SMTP: TwWbSbyswBC.ucnsH..TBqL4oTo-
From: Brad Arrington <bradla8@yahoo.com>
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Cc: Brad Arrington <bradla8@yahoo.com>
Subject: [PATCH 1/1] ACL: increase the #define XFS_ACL_MAX_ENTRIES to 128 The xfsprogs xfs_repair will have to be increased also if this is okay.
Date: Thu,  5 Jul 2012 13:33:11 -0700
Message-Id: <1341520391-9704-1-git-send-email-bradla8@yahoo.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Brad Arrington <bradla8@yahoo.com>
---
 fs/xfs/xfs_acl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 39632d9..716d4d2 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -22,7 +22,7 @@ struct inode;
 struct posix_acl;
 struct xfs_inode;
 
-#define XFS_ACL_MAX_ENTRIES 25
+#define XFS_ACL_MAX_ENTRIES 128
 #define XFS_ACL_NOT_PRESENT (-1)
 
 /* On-disk XFS access control list structure */
-- 
1.7.10.4

