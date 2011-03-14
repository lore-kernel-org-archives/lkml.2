Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1CNLGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:06:46 -0400
Received: from nm7.bullet.mail.sp2.yahoo.com ([98.139.91.77]:23503 "HELO
	nm7.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753423Ab1CNLGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:06:42 -0400
X-Yahoo-Newman-Id: 376280.92293.bm@omp1056.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: bNB07B0VM1lCfuqKOzKR4xTM8kiTU1b7NznXFFULy96b4sZ
 WrUqbjnN7g_Bl1P4XjFx_t6u4mmOQhd0auDNnqmoSO4m3HCNnJsXNnfYAWER
 xkgYz.wGMdotXaajuxOj_lHplRLqHfP2VYfznKBYXaUFx2jNdd3z2Ss_HVnQ
 1Pnyyxjt9h3QTaSYjnWBQDS8qMFPXC2o.5qqwGGFea_g9zFqGCvJZpTMOYzs
 GoCgtW.vxnwkN1fyd0AGVjXJi5CVVvI9SsfCLSfftO64Mnn5YJaPJHLzAOpF
 brly1GXelquWUnOca4r9wTPDmUPkapvDYmHru_EEVqwC.WH1SFbrMincMihZ
 4dIM8P.VfMSP52qQE.xmQgG3So7AGqbuZgMU7ixpKWTgVXDDm14QXDVwT4yR
 7Qj4z2yDalyE-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/21] target: remove EXTRA_CFLAGS
Date: Mon, 14 Mar 2011 04:05:58 -0700
Message-Id: <1300100775-10012-5-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Add the current directory is superflous in general, and no includes in
drivers/scsi are needed either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 973bb19..050ee65 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,4 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
 
 target_core_mod-y		:= target_core_configfs.o \
 				   target_core_device.o \
-- 
1.7.4.1

