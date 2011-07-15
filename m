Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab1GOIom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:44:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:31150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1GOIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,534,1304319600"; 
   d="scan'208";a="27559529"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] scsi: cxgbi: use native DIV_ROUND_UP macro
Date: Fri, 15 Jul 2011 11:44:02 +0300
Message-Id: <0459b9438da78289a8143367f4778d5fc89af3e2.1310719270.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f3a4cd7..5f41b9d 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -16,6 +16,7 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/kernel.h>
 #include <scsi/scsi_host.h>
 #include <net/tcp.h>
 #include <net/dst.h>
@@ -169,7 +170,6 @@ static struct scsi_transport_template *cxgb4i_stt;
  * The section below implments CPLs that related to iscsi tcp connection
  * open/close/abort and data send/receive.
  */
-#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
 #define RCV_BUFSIZ_MASK		0x3FFU
 #define MAX_IMM_TX_PKT_LEN	128
 
-- 
1.7.5.4

