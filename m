Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2BQN5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:57:48 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37381
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2BQN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:57:47 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: andrew.vasquez@qlogic.com, linux-driver@qlogic.com,
        linux-scsi@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] qla2xxx: Fix typo in qla_mbx.c
Date: Fri, 17 Feb 2012 22:57:20 +0900
Message-Id: <1329487040-1828-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "occured" to "occurred" in
drivers/scsi/qla2xxx/qla_mbx.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 34344d3..c0622b6d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -313,7 +313,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101c,
-				    "Mailbox cmd timeout occured. "
+				    "Mailbox cmd timeout occurred. "
 				    "Scheduling ISP abort eeh_busy=0x%x.\n",
 					ha->flags.eeh_busy);
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -337,7 +337,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101e,
-				    "Mailbox cmd timeout occured. "
+				    "Mailbox cmd timeout occurred. "
 				    "Scheduling ISP abort.\n");
 
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
-- 
1.7.4.4

