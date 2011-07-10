Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1GJVt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 17:49:58 -0400
Received: from gw.minian.org ([83.96.227.91]:48780 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752707Ab1GJVt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 17:49:58 -0400
From: Edwin van Vliet <edwin@cheatah.nl>
To: roland@kernel.org
Cc: mike.marciniszyn@qlogic.com, mitko@qlogic.com, ralph.campbell@qlogic.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH] drivers/infiniband/hw/qib/qib_iba7322: remove double define
Date: Sun, 10 Jul 2011 23:49:47 +0200
Message-Id: <1310334587-26731-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Double define removed.

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 8ec5237..821226c 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -397,7 +397,6 @@ MODULE_PARM_DESC(txselect, \
 #define crp_txdroppedpkt CREG_IDX(TxDroppedPktCnt)
 #define crp_txhdrerr CREG_IDX(TxHeadersErrCnt)
 #define crp_txlenerr CREG_IDX(TxLenErrCnt)
-#define crp_txlenerr CREG_IDX(TxLenErrCnt)
 #define crp_txminmaxlenerr CREG_IDX(TxMaxMinLenErrCnt)
 #define crp_txsdmadesc CREG_IDX(TxSDmaDescCnt)
 #define crp_txunderrun CREG_IDX(TxUnderrunCnt)
-- 
1.7.5.4

