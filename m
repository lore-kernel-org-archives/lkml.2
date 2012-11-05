Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab2KEFMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:12:13 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37007 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2KEFML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:12:11 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: jitendra.kalsaria@qlogic.com
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers: ethernet: qlogic: qlge_dbg.c: Fixed a coding style issue
Date: Sun,  4 Nov 2012 21:11:32 -0800
Message-Id: <1352092292-4413-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl throws error message for the current code. This patch fixes
this coding style issue.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
index 58185b6..10093f0 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
@@ -86,7 +86,7 @@ exit:
 }
 
 /* Read out the SERDES registers */
-static int ql_read_serdes_reg(struct ql_adapter *qdev, u32 reg, u32 * data)
+static int ql_read_serdes_reg(struct ql_adapter *qdev, u32 reg, u32 *data)
 {
 	int status;
 
@@ -364,7 +364,7 @@ exit:
 /* Read the 400 xgmac control/statistics registers
  * skipping unused locations.
  */
-static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 * buf,
+static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 					unsigned int other_function)
 {
 	int status = 0;
@@ -405,7 +405,7 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 * buf,
 	return status;
 }
 
-static int ql_get_ets_regs(struct ql_adapter *qdev, u32 * buf)
+static int ql_get_ets_regs(struct ql_adapter *qdev, u32 *buf)
 {
 	int status = 0;
 	int i;
@@ -423,7 +423,7 @@ static int ql_get_ets_regs(struct ql_adapter *qdev, u32 * buf)
 	return status;
 }
 
-static void ql_get_intr_states(struct ql_adapter *qdev, u32 * buf)
+static void ql_get_intr_states(struct ql_adapter *qdev, u32 *buf)
 {
 	int i;
 
@@ -434,7 +434,7 @@ static void ql_get_intr_states(struct ql_adapter *qdev, u32 * buf)
 	}
 }
 
-static int ql_get_cam_entries(struct ql_adapter *qdev, u32 * buf)
+static int ql_get_cam_entries(struct ql_adapter *qdev, u32 *buf)
 {
 	int i, status;
 	u32 value[3];
@@ -471,7 +471,7 @@ err:
 	return status;
 }
 
-static int ql_get_routing_entries(struct ql_adapter *qdev, u32 * buf)
+static int ql_get_routing_entries(struct ql_adapter *qdev, u32 *buf)
 {
 	int status;
 	u32 value, i;
@@ -496,7 +496,7 @@ err:
 }
 
 /* Read the MPI Processor shadow registers */
-static int ql_get_mpi_shadow_regs(struct ql_adapter *qdev, u32 * buf)
+static int ql_get_mpi_shadow_regs(struct ql_adapter *qdev, u32 *buf)
 {
 	u32 i;
 	int status;
@@ -515,7 +515,7 @@ end:
 }
 
 /* Read the MPI Processor core registers */
-static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 * buf,
+static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
 				u32 offset, u32 count)
 {
 	int i, status = 0;
-- 
1.7.9.5

