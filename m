Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993440Ab2K3TZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:25:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:58320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992671Ab2K3S4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xiangliang Yu <yuxiangl@marvell.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 06/56] [SCSI] mvsas: remove unused variable in mvs_task_exec()
Date: Fri, 30 Nov 2012 10:54:58 -0800
Message-Id: <20121130185118.986193031@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit cca85013ef54f66eb4616e6f3860549a96c8338b upstream.

We don't use "dev" any more after 07ec747a5f ("libsas: remove
ata_port.lock management duties from lldds") and it causes a compile
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi = NULL;
 	u32 rc = 0;
 	u32 pass = 0;


