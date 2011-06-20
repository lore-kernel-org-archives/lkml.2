Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1FTI6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:58:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12067 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1FTI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:58:37 -0400
Date: Mon, 20 Jun 2011 10:49:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: [PATCH][Trivial] SCSI, Target, tcm_loop: Remove include duplicate
Message-ID: <alpine.LNX.2.00.1106201044310.18991@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e66ecd50 added a duplicate include of scsi/scsi_tcq.h to 
drivers/target/loopback/tcm_loop.c - this patch removes the duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tcm_loop.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index dee2a2c..ee95903 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -31,7 +31,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

