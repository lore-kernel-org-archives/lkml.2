Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031100Ab1EWVLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:11:20 -0400
Received: from nm22-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.137]:23611
	"HELO nm22-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031067Ab1EWVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:11:09 -0400
X-Yahoo-Newman-Id: 775221.60926.bm@omp1004.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 6zr3wdUVM1kpMiAeIeCktKJz_GqPdTewb1ZLlk4mcAtyfqC
 3cuLvxW5Lgkf6r.Kx9orVY2gD5yTk8jVu5giY8sk._cNZ6vX3RTysuVh22Ts
 EgXjUq7f4NujzwMpoxQzwTZaFLPn4LnCfjtRLGU1GdNeRwhrtLP2rebgsO9o
 GwhaRTPfywlfQUcV9hQ9jguFgG_ZY33QPWfEssKQGLDJ1_mGMd61nCXt.uwZ
 e6D8_Clz5YRJSZ53JRz0kPtaZ9uAvh.AEKCHbjM7IQc2PcUhS7e94s5mBo_w
 v78_Zz9.FYEUwFXRcchnMhc9B9UoTGkOr_cowXxZmQIYmTcI5eTs5ME8zFp1
 un5PC69GrA4PSHpuKBsiVE0pAP7PGdJ5a0DLydg_TwjFJKJcc2XaSzF4hESg
 Vdr2ft66eknF8NzdkJbQYVJHE4rvePzlMJjfX8CaMcdjPyA6qQp8xZ7PirJT
 omZMILFNsX4ucDa4y
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
Date: Mon, 23 May 2011 14:10:32 -0700
Message-Id: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 20be668..16e9861 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6032,6 +6032,17 @@ F:	Documentation/filesystems/sysv-fs.txt
 F:	fs/sysv/
 F:	include/linux/sysv_fs.h
 
+TARGET SUBSYSTEM
+M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
+L:	linux-scsi@vger.kernel.org
+L:	http://groups.google.com/group/linux-iscsi-target-dev
+W:	http://www.linux-iscsi.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
+S:	Supported
+F:	drivers/target/
+F:	include/target/
+F:	Documentation/target/
+
 TASKSTATS STATISTICS INTERFACE
 M:	Balbir Singh <balbir@linux.vnet.ibm.com>
 S:	Maintained
-- 
1.7.5.2

