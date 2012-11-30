Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2K3RD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:03:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43650 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2K3RDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:03:55 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 26/32] staging: wlags49_h2: wl_priv: fixes case statement styling issues
Date: Fri, 30 Nov 2012 18:58:51 +0200
Message-Id: <1354294737-5735-26-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes issues related to the styling of case statements.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index e2615a1..093e1ea 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -136,27 +136,27 @@ int wvlan_uil(struct uilreq *urq, struct wl_private *lp)
 	DBG_ENTER(DbgInfo);
 
 	switch (urq->command) {
-	  case UIL_FUN_CONNECT:
+	case UIL_FUN_CONNECT:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_CONNECT\n");
 		ioctl_ret = wvlan_uil_connect(urq, lp);
 		break;
-	  case UIL_FUN_DISCONNECT:
+	case UIL_FUN_DISCONNECT:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_DISCONNECT\n");
 		ioctl_ret = wvlan_uil_disconnect(urq, lp);
 		break;
-	  case UIL_FUN_ACTION:
+	case UIL_FUN_ACTION:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_ACTION\n");
 		ioctl_ret = wvlan_uil_action(urq, lp);
 		break;
-	  case UIL_FUN_SEND_DIAG_MSG:
+	case UIL_FUN_SEND_DIAG_MSG:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_SEND_DIAG_MSG\n");
 		ioctl_ret = wvlan_uil_send_diag_msg(urq, lp);
 		break;
-	  case UIL_FUN_GET_INFO:
+	case UIL_FUN_GET_INFO:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_GET_INFO\n");
 		ioctl_ret = wvlan_uil_get_info(urq, lp);
 		break;
-	  case UIL_FUN_PUT_INFO:
+	case UIL_FUN_PUT_INFO:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_PUT_INFO\n");
 		ioctl_ret = wvlan_uil_put_info(urq, lp);
 		break;
@@ -2047,22 +2047,22 @@ int wvlan_rts(struct rtsreq *rrq, __u32 io_base)
 	DBG_PRINT("io_base: 0x%08x\n", io_base);
 
 	switch (rrq->typ) {
-	  case WL_IOCTL_RTS_READ:
+	case WL_IOCTL_RTS_READ:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_READ\n");
 		rrq->data[0] = IN_PORT_WORD(io_base + rrq->reg);
 		DBG_TRACE(DbgInfo, "  reg 0x%04x ==> 0x%04x\n", rrq->reg, CNV_LITTLE_TO_SHORT(rrq->data[0]));
 		break;
-	  case WL_IOCTL_RTS_WRITE:
+	case WL_IOCTL_RTS_WRITE:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_WRITE\n");
 		OUT_PORT_WORD(io_base + rrq->reg, rrq->data[0]);
 		DBG_TRACE(DbgInfo, "  reg 0x%04x <== 0x%04x\n", rrq->reg, CNV_LITTLE_TO_SHORT(rrq->data[0]));
 		break;
-	  case WL_IOCTL_RTS_BATCH_READ:
+	case WL_IOCTL_RTS_BATCH_READ:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_BATCH_READ\n");
 		IN_PORT_STRING_16(io_base + rrq->reg, rrq->data, rrq->len);
 		DBG_TRACE(DbgInfo, "  reg 0x%04x ==> %d bytes\n", rrq->reg, rrq->len * sizeof(__u16));
 		break;
-	  case WL_IOCTL_RTS_BATCH_WRITE:
+	case WL_IOCTL_RTS_BATCH_WRITE:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_BATCH_WRITE\n");
 		OUT_PORT_STRING_16(io_base + rrq->reg, rrq->data, rrq->len);
 		DBG_TRACE(DbgInfo, "  reg 0x%04x <== %d bytes\n", rrq->reg, rrq->len * sizeof(__u16));
-- 
1.7.10.4

