Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2BXPdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:33:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab2BXPdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:33:21 -0500
From: Petr Uzel <petr.uzel@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Ravi Anand <ravi.anand@qlogic.com> (supporter:QLOGIC QLA4XXX iS...),
        Vikas Chaudhary <vikas.chaudhary@qlogic.com> (supporter:QLOGIC
	QLA4XXX iS...),
        iscsi-driver@qlogic.com (supporter:QLOGIC QLA4XXX iS...),
        "James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
	SUBSYSTEM),
        Jiri Kosina <trivial@kernel.org> (maintainer:TRIVIAL PATCHES),
        linux-scsi@vger.kernel.org (open list:QLOGIC QLA4XXX iS...)
Subject: [PATCH] [trivial] [resend] [SCSI] qla4xxx: Add missing spaces to error messages
Date: Fri, 24 Feb 2012 16:32:59 +0100
Message-Id: <1330097579-25679-1-git-send-email-petr.uzel@suse.cz>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ce6d3b7..edf5034 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3382,7 +3382,7 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		if (qla4xxx_get_flash(ha, buf_dma, addr,
 				      13 * sizeof(uint8_t)) != QLA_SUCCESS) {
 			DEBUG2(ql4_printk(KERN_ERR, ha, "scsi%ld: %s: Get Flash"
-					  "failed\n", ha->host_no, __func__));
+					  " failed\n", ha->host_no, __func__));
 			ret = QLA_ERROR;
 			goto exit_boot_info_free;
 		}
@@ -3620,7 +3620,7 @@ static int qla4xxx_setup_boot_info(struct scsi_qla_host *ha)
 
 	if (ql4xdisablesysfsboot) {
 		ql4_printk(KERN_INFO, ha,
-			   "%s: syfsboot disabled - driver will trigger login"
+			   "%s: syfsboot disabled - driver will trigger login "
 			   "and publish session for discovery .\n", __func__);
 		return QLA_SUCCESS;
 	}
-- 
1.7.7

