Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1GORcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:32:02 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60240
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754263Ab1GORaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 107/117] Staging: hv: storvsc: Fix a typo
Date: Fri, 15 Jul 2011 10:47:35 -0700
Message-Id: <1310752065-27895-107-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in a function name.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9c2bb56..2d7bb41 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1163,9 +1163,9 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 
 
 /*
- * storvsc_commmand_completion - Command completion processing
+ * storvsc_command_completion - Command completion processing
  */
-static void storvsc_commmand_completion(struct hv_storvsc_request *request)
+static void storvsc_command_completion(struct hv_storvsc_request *request)
 {
 	struct storvsc_cmd_request *cmd_request =
 		(struct storvsc_cmd_request *)request->context;
@@ -1273,7 +1273,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 		break;
 	}
 
-	request->on_io_completion = storvsc_commmand_completion;
+	request->on_io_completion = storvsc_command_completion;
 	request->context = cmd_request;/* scmnd; */
 
 	vm_srb->port_number = host_dev->port;
-- 
1.7.4.1

