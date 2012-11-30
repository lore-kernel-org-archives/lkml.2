Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031249Ab2K3RKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:10:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58472 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2K3RK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:10:27 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 24/32] staging: wlags49_h2: wl_priv: fixes parentheses styling issues
Date: Fri, 30 Nov 2012 18:58:49 +0200
Message-Id: <1354294737-5735-24-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes further parentheses styling issues as identified
by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |   92 +++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index df2525f..23403e9 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -135,7 +135,7 @@ int wvlan_uil(struct uilreq *urq, struct wl_private *lp)
 	DBG_FUNC("wvlan_uil");
 	DBG_ENTER(DbgInfo);
 
-	switch(urq->command) {
+	switch (urq->command) {
 	  case UIL_FUN_CONNECT:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_CONNECT\n");
 		ioctl_ret = wvlan_uil_connect(urq, lp);
@@ -202,7 +202,7 @@ int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp)
 	DBG_ENTER(DbgInfo);
 
 
-	if(!(lp->flags & WVLAN2_UIL_CONNECTED)) {
+	if (!(lp->flags & WVLAN2_UIL_CONNECTED)) {
 		lp->flags |= WVLAN2_UIL_CONNECTED;
 		urq->hcfCtx = &(lp->hcfCtx);
 		urq->result = UIL_SUCCESS;
@@ -248,7 +248,7 @@ int wvlan_uil_disconnect(struct uilreq *urq, struct wl_private *lp)
 	DBG_ENTER(DbgInfo);
 
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
 		if (lp->flags & WVLAN2_UIL_CONNECTED) {
 			lp->flags &= ~WVLAN2_UIL_CONNECTED;
 			/*
@@ -304,13 +304,13 @@ int wvlan_uil_action(struct uilreq *urq, struct wl_private *lp)
 	DBG_ENTER(DbgInfo);
 
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
 		/* Make sure there's an LTV in the request buffer */
 		ltv = (ltv_t *)urq->data;
-		if(ltv != NULL) {
+		if (ltv != NULL) {
 			/* Switch on the Type field of the LTV contained in the request
 			   buffer */
-			switch(ltv->typ) {
+			switch (ltv->typ) {
 			case UIL_ACT_BLOCK:
 				DBG_TRACE(DbgInfo, "UIL_ACT_BLOCK\n");
 				result = wvlan_uil_block(urq, lp);
@@ -382,8 +382,8 @@ int wvlan_uil_block(struct uilreq *urq, struct wl_private *lp)
 	DBG_FUNC("wvlan_uil_block");
 	DBG_ENTER(DbgInfo);
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
-		if(capable(CAP_NET_ADMIN)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
+		if (capable(CAP_NET_ADMIN)) {
 			lp->flags |= WVLAN2_UIL_BUSY;
 			netif_stop_queue(lp->dev);
 			WL_WDS_NETIF_STOP_QUEUE(lp);
@@ -434,8 +434,8 @@ int wvlan_uil_unblock(struct uilreq *urq, struct wl_private *lp)
 	DBG_FUNC("wvlan_uil_unblock");
 	DBG_ENTER(DbgInfo);
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
-		if(capable(CAP_NET_ADMIN)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
+		if (capable(CAP_NET_ADMIN)) {
 			if (lp->flags & WVLAN2_UIL_BUSY) {
 				lp->flags &= ~WVLAN2_UIL_BUSY;
 				netif_wake_queue(lp->dev);
@@ -488,8 +488,8 @@ int wvlan_uil_send_diag_msg(struct uilreq *urq, struct wl_private *lp)
 	DBG_FUNC("wvlan_uil_send_diag_msg");
 	DBG_ENTER(DbgInfo);
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
-		if(capable(CAP_NET_ADMIN)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
+		if (capable(CAP_NET_ADMIN)) {
 			if ((urq->data != NULL) && (urq->len != 0)) {
 				if (lp->hcfCtx.IFB_RscInd != 0) {
 					u_char *data;
@@ -579,11 +579,11 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 	DBG_ENTER(DbgInfo);
 
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
-		if(capable(CAP_NET_ADMIN)) {
-			if((urq->data != NULL) && (urq->len != 0)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
+		if (capable(CAP_NET_ADMIN)) {
+			if ((urq->data != NULL) && (urq->len != 0)) {
 				/* Make sure that we have at least a command and length to send. */
-				if(urq->len < (sizeof(hcf_16) * 2)) {
+				if (urq->len < (sizeof(hcf_16) * 2)) {
 					urq->len = sizeof(lp->ltvRecord);
 					urq->result = UIL_ERR_LEN;
 					DBG_ERROR(DbgInfo, "No Length/Type in LTV!!!\n");
@@ -594,7 +594,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 
 				/* Verify the user buffer */
 				result = verify_area(VERIFY_READ, urq->data, urq->len);
-				if(result != 0) {
+				if (result != 0) {
 					urq->result = UIL_FAILURE;
 					DBG_ERROR(DbgInfo, "verify_area(), VERIFY_READ FAILED\n");
 					DBG_LEAVE(DbgInfo);
@@ -606,7 +606,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 
 				/* Make sure the incoming LTV record length is within the bounds of the
 				   IOCTL length */
-				if(((lp->ltvRecord.len + 1) * sizeof(hcf_16)) > urq->len) {
+				if (((lp->ltvRecord.len + 1) * sizeof(hcf_16)) > urq->len) {
 					urq->len = sizeof(lp->ltvRecord);
 					urq->result = UIL_ERR_LEN;
 					DBG_ERROR(DbgInfo, "UIL_ERR_LEN\n");
@@ -617,7 +617,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				/* If the requested length is greater than the size of our local
 				   LTV record, try to allocate it from the kernel stack.
 				   Otherwise, we just use our local LTV record. */
-				if(urq->len > sizeof(lp->ltvRecord)) {
+				if (urq->len > sizeof(lp->ltvRecord)) {
 					pLtv = kmalloc(urq->len, GFP_KERNEL);
 					if (pLtv != NULL) {
 						ltvAllocated = TRUE;
@@ -641,7 +641,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				/* We need to snoop the commands to see if there is anything we
 				   need to store for the purposes of a reset or start/stop
 				   sequence. Perform endian translation as needed */
-				switch(pLtv->typ) {
+				switch (pLtv->typ) {
 				case CFG_CNF_PORT_TYPE:
 					lp->PortType    = pLtv->u.u16[0];
 					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
@@ -824,7 +824,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					pLtv->u.u16[0] = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 
 					/* take care of the special network name "ANY" case */
-					if((strlen(&pLtv->u.u8[2]       ) == 0) ||
+					if ((strlen(&pLtv->u.u8[2]) == 0) ||
 					   (strcmp(&pLtv->u.u8[2], "ANY") == 0) ||
 					   (strcmp(&pLtv->u.u8[2], "any") == 0)) {
 						/* set the SSID_STRCT llen field (u16[0]) to zero, and the
@@ -1066,7 +1066,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				   being sent to the card, as they require a call to
 				   UIL_ACT_APPLY to take effect. Dynamic Entities will be sent
 				   immediately */
-				switch(pLtv->typ) {
+				switch (pLtv->typ) {
 				case CFG_CNF_PORT_TYPE:
 				case CFG_CNF_OWN_MAC_ADDR:
 				case CFG_CNF_OWN_CHANNEL:
@@ -1129,7 +1129,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					break;
 				/* Deal with this dynamic MSF RID, as it's required for WPA */
 				case CFG_DRIVER_ENABLE:
-					if(lp->driverEnable) {
+					if (lp->driverEnable) {
 						//hcf_cntl_port(&(lp->hcfCtx),
 						//               HCF_PORT_ENABLE | HCF_PORT_0);
 						// //hcf_cntl(&(lp->hcfCtx),
@@ -1158,7 +1158,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					break;
 				}
 
-				if(ltvAllocated) {
+				if (ltvAllocated) {
 					kfree(pLtv);
 				}
 			} else {
@@ -1208,13 +1208,13 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 	DBG_FUNC("wvlan_uil_get_info");
 	DBG_ENTER(DbgInfo);
 
-	if(urq->hcfCtx == &(lp->hcfCtx)) {
-		if((urq->data != NULL) && (urq->len != 0)) {
+	if (urq->hcfCtx == &(lp->hcfCtx)) {
+		if ((urq->data != NULL) && (urq->len != 0)) {
 			ltv_t      *pLtv;
 			bool_t      ltvAllocated = FALSE;
 
 			/* Make sure that we have at least a command and length */
-			if(urq->len < (sizeof(hcf_16) * 2)) {
+			if (urq->len < (sizeof(hcf_16) * 2)) {
 				urq->len = sizeof(lp->ltvRecord);
 				DBG_ERROR(DbgInfo, "No Length/Type in LTV!!!\n");
 				DBG_ERROR(DbgInfo, "UIL_ERR_LEN\n");
@@ -1225,7 +1225,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 
 			/* Verify the user's LTV record header. */
 			result = verify_area(VERIFY_READ, urq->data, sizeof(hcf_16) * 2);
-			if(result != 0) {
+			if (result != 0) {
 				DBG_ERROR(DbgInfo, "verify_area(), VERIFY_READ FAILED\n");
 				urq->result = UIL_FAILURE;
 				DBG_LEAVE(DbgInfo);
@@ -1237,7 +1237,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 
 			/* Make sure the incoming LTV record length is within the bounds of
 			   the IOCTL length. */
-			if(((lp->ltvRecord.len + 1) * sizeof(hcf_16)) > urq->len) {
+			if (((lp->ltvRecord.len + 1) * sizeof(hcf_16)) > urq->len) {
 				DBG_ERROR(DbgInfo, "Incoming LTV too big\n");
 				urq->len = sizeof(lp->ltvRecord);
 				urq->result = UIL_ERR_LEN;
@@ -1276,7 +1276,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				break;
 			case CFG_IFB:
 				/* IFB can be a security hole */
-				if(!capable(CAP_NET_ADMIN)) {
+				if (!capable(CAP_NET_ADMIN)) {
 					result = -EPERM;
 					break;
 				}
@@ -1288,7 +1288,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 
 				/* Verify the user buffer */
 				result = verify_area(VERIFY_WRITE, urq->data, urq->len);
-				if(result != 0) {
+				if (result != 0) {
 					DBG_ERROR(DbgInfo, "verify_area(), VERIFY_WRITE FAILED\n");
 					urq->result = UIL_FAILURE;
 					break;
@@ -1297,7 +1297,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				/* If the requested length is greater than the size of our local
 				   LTV record, try to allocate it from the kernel stack.
 				   Otherwise, we just use our local LTV record. */
-				if(urq->len > sizeof(lp->ltvRecord)) {
+				if (urq->len > sizeof(lp->ltvRecord)) {
 					pLtv = kmalloc(urq->len, GFP_KERNEL);
 					if (pLtv != NULL) {
 						ltvAllocated = TRUE;
@@ -1333,7 +1333,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			}
 
 			/* Handle endian conversion of special fields */
-			switch(lp->ltvRecord.typ) {
+			switch (lp->ltvRecord.typ) {
 			/* simple int gets just need the first hcf_16 byte flipped */
 			case CFG_CNF_PORT_TYPE:
 			case CFG_CNF_OWN_CHANNEL:
@@ -1490,7 +1490,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			case CFG_CFI_ACT_RANGES_STA:
 			case CFG_CUR_SCALE_THRH:
 			case CFG_AUTHENTICATION_ALGORITHMS:
-				for(i = 0; i < (lp->ltvRecord.len - 1); i++) {
+				for (i = 0; i < (lp->ltvRecord.len - 1); i++) {
 					lp->ltvRecord.u.u16[i] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[i]);
 				}
 				break;
@@ -1515,7 +1515,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			// Copy the LTV into the user's buffer.
 			copy_to_user(urq->data, &(lp->ltvRecord), urq->len);
 
-			if(ltvAllocated) {
+			if (ltvAllocated) {
 				kfree(&(lp->ltvRecord));
 			}
 
@@ -1567,7 +1567,7 @@ int cfg_driver_info(struct uilreq *urq, struct wl_private *lp)
 
 
 	/* Make sure that user buffer can handle the driver information buffer */
-	if(urq->len < sizeof(lp->driverInfo)) {
+	if (urq->len < sizeof(lp->driverInfo)) {
 		urq->len = sizeof(lp->driverInfo);
 		urq->result = UIL_ERR_LEN;
 		DBG_LEAVE(DbgInfo);
@@ -1576,7 +1576,7 @@ int cfg_driver_info(struct uilreq *urq, struct wl_private *lp)
 
 	/* Verify the user buffer. */
 	result = verify_area(VERIFY_WRITE, urq->data, sizeof(lp->driverInfo));
-	if(result != 0) {
+	if (result != 0) {
 		urq->result = UIL_FAILURE;
 		DBG_LEAVE(DbgInfo);
 		return result;
@@ -1626,7 +1626,7 @@ int cfg_driver_identity(struct uilreq *urq, struct wl_private *lp)
 
 
 	/* Make sure that user buffer can handle the driver identity structure. */
-	if(urq->len < sizeof(lp->driverIdentity)) {
+	if (urq->len < sizeof(lp->driverIdentity)) {
 		urq->len = sizeof(lp->driverIdentity);
 		urq->result = UIL_ERR_LEN;
 		DBG_LEAVE(DbgInfo);
@@ -1635,7 +1635,7 @@ int cfg_driver_identity(struct uilreq *urq, struct wl_private *lp)
 
 	/* Verify the user buffer. */
 	result = verify_area(VERIFY_WRITE, urq->data, sizeof(lp->driverIdentity));
-	if(result != 0) {
+	if (result != 0) {
 		urq->result = UIL_FAILURE;
 		DBG_LEAVE(DbgInfo);
 		return result;
@@ -1753,7 +1753,7 @@ int wvlan_get_netname(struct net_device *dev,
 
         status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if(status == HCF_SUCCESS) {
+        if (status == HCF_SUCCESS) {
                 pName = (wvName_t *)&(lp->ltvRecord.u.u32);
 
 		memset(extra, '\0', HCF_MAX_NAME_LEN);
@@ -1868,7 +1868,7 @@ int wvlan_get_station_nickname(struct net_device *dev,
 
         status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if(status == HCF_SUCCESS) {
+        if (status == HCF_SUCCESS) {
                 pName = (wvName_t *)&(lp->ltvRecord.u.u32);
 
 		memset(extra, '\0', HCF_MAX_NAME_LEN);
@@ -1928,7 +1928,7 @@ int wvlan_set_porttype(struct net_device *dev,
         /* Validate the new value */
         portType = *((__u32 *)extra);
 
-        if(!((portType == 1) || (portType == 3))) {
+        if (!((portType == 1) || (portType == 3))) {
                 ret = -EINVAL;
 		goto out_unlock;
         }
@@ -1993,7 +1993,7 @@ int wvlan_get_porttype(struct net_device *dev,
 
         status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if(status == HCF_SUCCESS) {
+        if (status == HCF_SUCCESS) {
                 pPortType = (hcf_16 *)&(lp->ltvRecord.u.u32);
 
                 *pData = CNV_LITTLE_TO_INT(*pPortType);
@@ -2046,7 +2046,7 @@ int wvlan_rts(struct rtsreq *rrq, __u32 io_base)
 
 	DBG_PRINT("io_base: 0x%08x\n", io_base);
 
-	switch(rrq->typ) {
+	switch (rrq->typ) {
 	  case WL_IOCTL_RTS_READ:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_READ\n");
 		rrq->data[0] = IN_PORT_WORD(io_base + rrq->reg);
@@ -2060,12 +2060,12 @@ int wvlan_rts(struct rtsreq *rrq, __u32 io_base)
 	  case WL_IOCTL_RTS_BATCH_READ:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_BATCH_READ\n");
 		IN_PORT_STRING_16(io_base + rrq->reg, rrq->data, rrq->len);
-		DBG_TRACE(DbgInfo, "  reg 0x%04x ==> %d bytes\n", rrq->reg, rrq->len * sizeof (__u16));
+		DBG_TRACE(DbgInfo, "  reg 0x%04x ==> %d bytes\n", rrq->reg, rrq->len * sizeof(__u16));
 		break;
 	  case WL_IOCTL_RTS_BATCH_WRITE:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_BATCH_WRITE\n");
 		OUT_PORT_STRING_16(io_base + rrq->reg, rrq->data, rrq->len);
-		DBG_TRACE(DbgInfo, "  reg 0x%04x <== %d bytes\n", rrq->reg, rrq->len * sizeof (__u16));
+		DBG_TRACE(DbgInfo, "  reg 0x%04x <== %d bytes\n", rrq->reg, rrq->len * sizeof(__u16));
 		break;
 	default:
 
-- 
1.7.10.4

