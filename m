Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1EWU5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:57:10 -0400
Received: from nm5-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.112]:24543
	"HELO nm5-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753052Ab1EWU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:57:07 -0400
X-Yahoo-Newman-Id: 158044.93591.bm@omp1019.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: VAnXkckVM1koLz5aee81odoEbnyli2pu3scdxSv_iRcXdwK
 4VIhw93VccW.AgrV6XjFIkIzA4pBuH8pIYs76V7gB66PTIqWT5Cwlcc289a6
 u7Qw.zWC8EqgMYFYhilmgDgTyoxCxyItSVyU.7zIzGLUhTUrQE6.Uwm92cnB
 4O.8QZkYj1HicQM.tvUg0z92LpnUMRuuWcArAHk_3H44V9u.w0gAJ0SHszY7
 gsMf2XfHwHSOiJzmZb2098wUpCfqVbIjpUgr5LOjX6lp_APOH7oNFrqXoR0o
 6PmXewTzjF467fsLUrwlpDaJEPSCXf0ADuh1vQEgRYRd1b8M2Auwz5E6wMrL
 UfMBZgKXBGGn2LyL.mcrM4N9vtUmej3u_XCgukyWz9yTL_dLb6JORSExCIBQ
 IZDV7f6o3HmbGsGZc376Sc9BMUgqngE_ScSHRCzWZPHJpsmUaW8LSS0KqDyn
 308uP
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] MAINTAINERS: Add drivers/target/ entry
Date: Mon, 23 May 2011 13:56:26 -0700
Message-Id: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 20be668..a831859 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6039,6 +6039,16 @@ F:	Documentation/accounting/taskstats*
 F:	include/linux/taskstats*
 F:	kernel/taskstats.c
 
+TARGET SUBSYSTEM
+M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
+L:	linux-scsi@vger.kernel.org
+L:	http://groups.google.com/group/linux-iscsi-target-dev
+W:	http://www.linux-iscsi.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
+S:	Supported
+F:	drivers/target/
+F:	include/target/
+
 TC CLASSIFIER
 M:	Jamal Hadi Salim <hadi@cyberus.ca>
 L:	netdev@vger.kernel.org
-- 
1.7.5.2

