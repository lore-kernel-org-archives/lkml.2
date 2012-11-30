Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031265Ab2K3RKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:10:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58472 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031252Ab2K3RKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:10:46 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 23/32] staging: wlags49_h2: wl_priv: fixes spacing around parentheses
Date: Fri, 30 Nov 2012 18:58:48 +0200
Message-Id: <1354294737-5735-23-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes many instances where the spacing in and around
parentheses was applied incorrectly.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |  758 +++++++++++++++++-----------------
 1 file changed, 379 insertions(+), 379 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 87e1e41..df2525f 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -81,17 +81,17 @@
 #include <wl_util.h>
 #include <wl_netdev.h>
 
-int wvlan_uil_connect( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_action( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_block( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_unblock( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp );
-int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp );
+int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_disconnect(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_action(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_block(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_unblock(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_send_diag_msg(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp);
+int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp);
 
-int cfg_driver_info( struct uilreq *urq, struct wl_private *lp );
-int cfg_driver_identity( struct uilreq *urq, struct wl_private *lp );
+int cfg_driver_info(struct uilreq *urq, struct wl_private *lp);
+int cfg_driver_identity(struct uilreq *urq, struct wl_private *lp);
 
 
 /*******************************************************************************
@@ -127,45 +127,45 @@ extern dbg_info_t *DbgInfo;
  *      errno value otherwise
  *
  ******************************************************************************/
-int wvlan_uil( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil(struct uilreq *urq, struct wl_private *lp)
 {
 	int ioctl_ret = 0;
 	/*------------------------------------------------------------------------*/
 
-	DBG_FUNC( "wvlan_uil" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil");
+	DBG_ENTER(DbgInfo);
 
-	switch( urq->command ) {
+	switch(urq->command) {
 	  case UIL_FUN_CONNECT:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_CONNECT\n");
-		ioctl_ret = wvlan_uil_connect( urq, lp );
+		ioctl_ret = wvlan_uil_connect(urq, lp);
 		break;
 	  case UIL_FUN_DISCONNECT:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_DISCONNECT\n");
-		ioctl_ret = wvlan_uil_disconnect( urq, lp );
+		ioctl_ret = wvlan_uil_disconnect(urq, lp);
 		break;
 	  case UIL_FUN_ACTION:
-		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_ACTION\n" );
-		ioctl_ret = wvlan_uil_action( urq, lp );
+		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_ACTION\n");
+		ioctl_ret = wvlan_uil_action(urq, lp);
 		break;
 	  case UIL_FUN_SEND_DIAG_MSG:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_SEND_DIAG_MSG\n");
-		ioctl_ret = wvlan_uil_send_diag_msg( urq, lp );
+		ioctl_ret = wvlan_uil_send_diag_msg(urq, lp);
 		break;
 	  case UIL_FUN_GET_INFO:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_GET_INFO\n");
-		ioctl_ret = wvlan_uil_get_info( urq, lp );
+		ioctl_ret = wvlan_uil_get_info(urq, lp);
 		break;
 	  case UIL_FUN_PUT_INFO:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- WVLAN2_UIL_PUT_INFO\n");
-		ioctl_ret = wvlan_uil_put_info( urq, lp );
+		ioctl_ret = wvlan_uil_put_info(urq, lp);
 		break;
 	default:
-		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- UNSUPPORTED UIL CODE: 0x%X", urq->command );
+		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_UIL -- UNSUPPORTED UIL CODE: 0x%X", urq->command);
 		ioctl_ret = -EOPNOTSUPP;
 		break;
 	}
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return ioctl_ret;
 } // wvlan_uil
 /*============================================================================*/
@@ -192,26 +192,26 @@ int wvlan_uil( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_connect( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_uil_connect" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_connect");
+	DBG_ENTER(DbgInfo);
 
 
-	if( !( lp->flags & WVLAN2_UIL_CONNECTED )) {
+	if(!(lp->flags & WVLAN2_UIL_CONNECTED)) {
 		lp->flags |= WVLAN2_UIL_CONNECTED;
-		urq->hcfCtx = &( lp->hcfCtx );
+		urq->hcfCtx = &(lp->hcfCtx);
 		urq->result = UIL_SUCCESS;
 	} else {
-		DBG_WARNING( DbgInfo, "UIL_ERR_IN_USE\n" );
+		DBG_WARNING(DbgInfo, "UIL_ERR_IN_USE\n");
 		urq->result = UIL_ERR_IN_USE;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_connect
 /*============================================================================*/
@@ -238,17 +238,17 @@ int wvlan_uil_connect( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_disconnect(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_uil_disconnect" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_disconnect");
+	DBG_ENTER(DbgInfo);
 
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
 		if (lp->flags & WVLAN2_UIL_CONNECTED) {
 			lp->flags &= ~WVLAN2_UIL_CONNECTED;
 			/*
@@ -262,11 +262,11 @@ int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp )
 		urq->hcfCtx = NULL;
 		urq->result = UIL_SUCCESS;
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_disconnect
 /*============================================================================*/
@@ -293,58 +293,58 @@ int wvlan_uil_disconnect( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_action( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_action(struct uilreq *urq, struct wl_private *lp)
 {
 	int     result = 0;
 	ltv_t   *ltv;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_uil_action" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_action");
+	DBG_ENTER(DbgInfo);
 
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
 		/* Make sure there's an LTV in the request buffer */
 		ltv = (ltv_t *)urq->data;
-		if( ltv != NULL ) {
+		if(ltv != NULL) {
 			/* Switch on the Type field of the LTV contained in the request
 			   buffer */
-			switch( ltv->typ ) {
+			switch(ltv->typ) {
 			case UIL_ACT_BLOCK:
-				DBG_TRACE( DbgInfo, "UIL_ACT_BLOCK\n" );
-				result = wvlan_uil_block( urq, lp );
+				DBG_TRACE(DbgInfo, "UIL_ACT_BLOCK\n");
+				result = wvlan_uil_block(urq, lp);
 				break;
 			case UIL_ACT_UNBLOCK:
-				DBG_TRACE( DbgInfo, "UIL_ACT_UNBLOCK\n" );
-				result = wvlan_uil_unblock( urq, lp );
+				DBG_TRACE(DbgInfo, "UIL_ACT_UNBLOCK\n");
+				result = wvlan_uil_unblock(urq, lp);
 				break;
 			case UIL_ACT_SCAN:
-				DBG_TRACE( DbgInfo, "UIL_ACT_SCAN\n" );
-				urq->result = hcf_action( &( lp->hcfCtx ), MDD_ACT_SCAN );
+				DBG_TRACE(DbgInfo, "UIL_ACT_SCAN\n");
+				urq->result = hcf_action(&(lp->hcfCtx), MDD_ACT_SCAN);
 				break;
 			case UIL_ACT_APPLY:
-				DBG_TRACE( DbgInfo, "UIL_ACT_APPLY\n" );
-				urq->result = wl_apply( lp );
+				DBG_TRACE(DbgInfo, "UIL_ACT_APPLY\n");
+				urq->result = wl_apply(lp);
 				break;
 			case UIL_ACT_RESET:
-				DBG_TRACE( DbgInfo, "UIL_ACT_RESET\n" );
-				urq->result = wl_go( lp );
+				DBG_TRACE(DbgInfo, "UIL_ACT_RESET\n");
+				urq->result = wl_go(lp);
 				break;
 			default:
-				DBG_WARNING( DbgInfo, "Unknown action code: 0x%x\n", ltv->typ );
+				DBG_WARNING(DbgInfo, "Unknown action code: 0x%x\n", ltv->typ);
 				break;
 			}
 		} else {
-			DBG_ERROR( DbgInfo, "Bad LTV for this action\n" );
+			DBG_ERROR(DbgInfo, "Bad LTV for this action\n");
 			urq->result = UIL_ERR_LEN;
 		}
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_action
 /*============================================================================*/
@@ -373,32 +373,32 @@ int wvlan_uil_action( struct uilreq *urq, struct wl_private *lp )
  *
  ******************************************************************************/
 
-int wvlan_uil_block( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_block(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_uil_block" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_block");
+	DBG_ENTER(DbgInfo);
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
-		if( capable( CAP_NET_ADMIN )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
+		if(capable(CAP_NET_ADMIN)) {
 			lp->flags |= WVLAN2_UIL_BUSY;
 			netif_stop_queue(lp->dev);
-			WL_WDS_NETIF_STOP_QUEUE( lp );
+			WL_WDS_NETIF_STOP_QUEUE(lp);
 			urq->result = UIL_SUCCESS;
 		} else {
-			DBG_ERROR( DbgInfo, "EPERM\n" );
+			DBG_ERROR(DbgInfo, "EPERM\n");
 			urq->result = UIL_FAILURE;
 			result = -EPERM;
 		}
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_block
 /*============================================================================*/
@@ -425,33 +425,33 @@ int wvlan_uil_block( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_unblock( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_unblock(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_uil_unblock" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_unblock");
+	DBG_ENTER(DbgInfo);
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
-		if( capable( CAP_NET_ADMIN )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
+		if(capable(CAP_NET_ADMIN)) {
 			if (lp->flags & WVLAN2_UIL_BUSY) {
 				lp->flags &= ~WVLAN2_UIL_BUSY;
 				netif_wake_queue(lp->dev);
-				WL_WDS_NETIF_WAKE_QUEUE( lp );
+				WL_WDS_NETIF_WAKE_QUEUE(lp);
 			}
 		} else {
-			DBG_ERROR( DbgInfo, "EPERM\n" );
+			DBG_ERROR(DbgInfo, "EPERM\n");
 			urq->result = UIL_FAILURE;
 			result = -EPERM;
 		}
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_unblock
 /*============================================================================*/
@@ -478,18 +478,18 @@ int wvlan_uil_unblock( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_send_diag_msg(struct uilreq *urq, struct wl_private *lp)
 {
 	int         result = 0;
 	DESC_STRCT  Descp[1];
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_uil_send_diag_msg" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_send_diag_msg");
+	DBG_ENTER(DbgInfo);
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
-		if( capable( CAP_NET_ADMIN )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
+		if(capable(CAP_NET_ADMIN)) {
 			if ((urq->data != NULL) && (urq->len != 0)) {
 				if (lp->hcfCtx.IFB_RscInd != 0) {
 					u_char *data;
@@ -497,28 +497,28 @@ int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp )
 					// Verify the user buffer
 					result = verify_area(VERIFY_READ, urq->data, urq->len);
 					if (result != 0) {
-						DBG_ERROR( DbgInfo, "verify_area failed, result: %d\n", result );
+						DBG_ERROR(DbgInfo, "verify_area failed, result: %d\n", result);
 						urq->result = UIL_FAILURE;
-						DBG_LEAVE( DbgInfo );
+						DBG_LEAVE(DbgInfo);
 						return result;
 					}
 
 					data = kmalloc(urq->len, GFP_KERNEL);
 					if (data != NULL) {
-						memset( Descp, 0, sizeof( DESC_STRCT ));
-						memcpy( data, urq->data, urq->len );
+						memset(Descp, 0, sizeof(DESC_STRCT));
+						memcpy(data, urq->data, urq->len);
 
 						Descp[0].buf_addr       = (wci_bufp)data;
 						Descp[0].BUF_CNT        = urq->len;
 						Descp[0].next_desc_addr = 0;    // terminate list
 
-						hcf_send_msg( &(lp->hcfCtx),  &Descp[0], HCF_PORT_0 );
-						kfree( data );
+						hcf_send_msg(&(lp->hcfCtx),  &Descp[0], HCF_PORT_0);
+						kfree(data);
 					} else {
-						DBG_ERROR( DbgInfo, "ENOMEM\n" );
+						DBG_ERROR(DbgInfo, "ENOMEM\n");
 						urq->result = UIL_FAILURE;
 						result = -ENOMEM;
-						DBG_LEAVE( DbgInfo );
+						DBG_LEAVE(DbgInfo);
 						return result;
 					}
 
@@ -530,16 +530,16 @@ int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp )
 				urq->result = UIL_FAILURE;
 			}
 		} else {
-			DBG_ERROR( DbgInfo, "EPERM\n" );
+			DBG_ERROR(DbgInfo, "EPERM\n");
 			urq->result = UIL_FAILURE;
 			result = -EPERM;
 		}
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_send_diag_msg
 /*============================================================================*/
@@ -564,7 +564,7 @@ int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 {
 	int                     result = 0;
 	ltv_t                   *pLtv;
@@ -575,94 +575,94 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 	hcf_16                  hcfPort  = HCF_PORT_0;
 #endif  /* USE_WDS */
 	/*------------------------------------------------------------------------*/
-	DBG_FUNC( "wvlan_uil_put_info" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_put_info");
+	DBG_ENTER(DbgInfo);
 
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
-		if( capable( CAP_NET_ADMIN )) {
-			if(( urq->data != NULL ) && ( urq->len != 0 )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
+		if(capable(CAP_NET_ADMIN)) {
+			if((urq->data != NULL) && (urq->len != 0)) {
 				/* Make sure that we have at least a command and length to send. */
-				if( urq->len < ( sizeof( hcf_16 ) * 2 )) {
-					urq->len = sizeof( lp->ltvRecord );
+				if(urq->len < (sizeof(hcf_16) * 2)) {
+					urq->len = sizeof(lp->ltvRecord);
 					urq->result = UIL_ERR_LEN;
-					DBG_ERROR( DbgInfo, "No Length/Type in LTV!!!\n" );
-					DBG_ERROR( DbgInfo, "UIL_ERR_LEN\n" );
-					DBG_LEAVE( DbgInfo );
+					DBG_ERROR(DbgInfo, "No Length/Type in LTV!!!\n");
+					DBG_ERROR(DbgInfo, "UIL_ERR_LEN\n");
+					DBG_LEAVE(DbgInfo);
 					return result;
 				}
 
 				/* Verify the user buffer */
-				result = verify_area( VERIFY_READ, urq->data, urq->len );
-				if( result != 0 ) {
+				result = verify_area(VERIFY_READ, urq->data, urq->len);
+				if(result != 0) {
 					urq->result = UIL_FAILURE;
-					DBG_ERROR( DbgInfo, "verify_area(), VERIFY_READ FAILED\n" );
-					DBG_LEAVE( DbgInfo );
+					DBG_ERROR(DbgInfo, "verify_area(), VERIFY_READ FAILED\n");
+					DBG_LEAVE(DbgInfo);
 					return result;
 				}
 
 				/* Get only the command and length information. */
-				copy_from_user( &( lp->ltvRecord ), urq->data, sizeof( hcf_16 ) * 2 );
+				copy_from_user(&(lp->ltvRecord), urq->data, sizeof(hcf_16) * 2);
 
 				/* Make sure the incoming LTV record length is within the bounds of the
 				   IOCTL length */
-				if((( lp->ltvRecord.len + 1 ) * sizeof( hcf_16 )) > urq->len ) {
-					urq->len = sizeof( lp->ltvRecord );
+				if(((lp->ltvRecord.len + 1) * sizeof(hcf_16)) > urq->len) {
+					urq->len = sizeof(lp->ltvRecord);
 					urq->result = UIL_ERR_LEN;
-					DBG_ERROR( DbgInfo, "UIL_ERR_LEN\n" );
-					DBG_LEAVE( DbgInfo );
+					DBG_ERROR(DbgInfo, "UIL_ERR_LEN\n");
+					DBG_LEAVE(DbgInfo);
 					return result;
 				}
 
 				/* If the requested length is greater than the size of our local
 				   LTV record, try to allocate it from the kernel stack.
 				   Otherwise, we just use our local LTV record. */
-				if( urq->len > sizeof( lp->ltvRecord )) {
+				if(urq->len > sizeof(lp->ltvRecord)) {
 					pLtv = kmalloc(urq->len, GFP_KERNEL);
 					if (pLtv != NULL) {
 						ltvAllocated = TRUE;
 					} else {
-						DBG_ERROR( DbgInfo, "Alloc FAILED\n" );
-						urq->len = sizeof( lp->ltvRecord );
+						DBG_ERROR(DbgInfo, "Alloc FAILED\n");
+						urq->len = sizeof(lp->ltvRecord);
 						urq->result = UIL_ERR_LEN;
 						result = -ENOMEM;
-						DBG_LEAVE( DbgInfo );
+						DBG_LEAVE(DbgInfo);
 						return result;
 					}
 				} else {
-					pLtv = &( lp->ltvRecord );
+					pLtv = &(lp->ltvRecord);
 				}
 
 				/* Copy the data from the user's buffer into the local LTV
 				   record data area. */
-				copy_from_user( pLtv, urq->data, urq->len );
+				copy_from_user(pLtv, urq->data, urq->len);
 
 
 				/* We need to snoop the commands to see if there is anything we
 				   need to store for the purposes of a reset or start/stop
 				   sequence. Perform endian translation as needed */
-				switch( pLtv->typ ) {
+				switch(pLtv->typ) {
 				case CFG_CNF_PORT_TYPE:
 					lp->PortType    = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_OWN_MAC_ADDR:
 					/* TODO: determine if we are going to store anything based on this */
 					break;
 				case CFG_CNF_OWN_CHANNEL:
 					lp->Channel     = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				/* CFG_CNF_OWN_SSID currently same as CNF_DESIRED_SSID. Do we
 				   need separate storage for this? */
 				//case CFG_CNF_OWN_SSID:
 				case CFG_CNF_OWN_ATIM_WINDOW:
 					lp->atimWindow  = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_SYSTEM_SCALE:
 					lp->DistanceBetweenAPs  = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 
 				case CFG_CNF_MAX_DATA_LEN:
 					/* TODO: determine if we are going to store anything based
@@ -670,55 +670,55 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					break;
 				case CFG_CNF_PM_ENABLED:
 					lp->PMEnabled   = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_MCAST_RX:
 					lp->MulticastReceive    = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_MAX_SLEEP_DURATION:
 					lp->MaxSleepDuration    = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_HOLDOVER_DURATION:
 					lp->holdoverDuration    = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_OWN_NAME:
-					memset( lp->StationName, 0, sizeof( lp->StationName ));
-					memcpy( (void *)lp->StationName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
-					pLtv->u.u16[0] = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					memset(lp->StationName, 0, sizeof(lp->StationName));
+					memcpy((void *)lp->StationName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					pLtv->u.u16[0] = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_LOAD_BALANCING:
 					lp->loadBalancing       = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_MEDIUM_DISTRIBUTION:
 					lp->mediumDistribution  = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #ifdef WARP
 				case CFG_CNF_TX_POW_LVL:
 					lp->txPowLevel          = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				//case CFG_CNF_SHORT_RETRY_LIMIT:    // Short Retry Limit
 				//case 0xFC33:    // Long Retry Limit
 				case CFG_SUPPORTED_RATE_SET_CNTL:        // Supported Rate Set Control
 					lp->srsc[0]             = pLtv->u.u16[0];
 					lp->srsc[1]             = pLtv->u.u16[1];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
-					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE( pLtv->u.u16[1] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
+					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE(pLtv->u.u16[1]);
 					break;
 				case CFG_BASIC_RATE_SET_CNTL:        // Basic Rate Set Control
 					lp->brsc[0]             = pLtv->u.u16[0];
 					lp->brsc[1]             = pLtv->u.u16[1];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
-					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE( pLtv->u.u16[1] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
+					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE(pLtv->u.u16[1]);
 					break;
 				case CFG_CNF_CONNECTION_CNTL:
 					lp->connectionControl   = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				//case CFG_PROBE_DATA_RATE:
 #endif  // HERMES25
@@ -728,76 +728,76 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 
 				case CFG_CNF_OWN_DTIM_PERIOD:
 					lp->DTIMPeriod  = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #ifdef WARP
 				case CFG_CNF_OWN_BEACON_INTERVAL:        // Own Beacon Interval
 					lp->ownBeaconInterval   = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #endif // WARP
 				case CFG_COEXISTENSE_BEHAVIOUR:         // Coexistence behavior
 					lp->coexistence         = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #ifdef USE_WDS
 				case CFG_CNF_WDS_ADDR1:
-					memcpy( &lp->wds_port[0].wdsAddress, &pLtv->u.u8[0], ETH_ALEN );
+					memcpy(&lp->wds_port[0].wdsAddress, &pLtv->u.u8[0], ETH_ALEN);
 					hcfPort = HCF_PORT_1;
 					break;
 				case CFG_CNF_WDS_ADDR2:
-					memcpy( &lp->wds_port[1].wdsAddress, &pLtv->u.u8[0], ETH_ALEN );
+					memcpy(&lp->wds_port[1].wdsAddress, &pLtv->u.u8[0], ETH_ALEN);
 					hcfPort = HCF_PORT_2;
 					break;
 				case CFG_CNF_WDS_ADDR3:
-					memcpy( &lp->wds_port[2].wdsAddress, &pLtv->u.u8[0], ETH_ALEN );
+					memcpy(&lp->wds_port[2].wdsAddress, &pLtv->u.u8[0], ETH_ALEN);
 					hcfPort = HCF_PORT_3;
 					break;
 				case CFG_CNF_WDS_ADDR4:
-					memcpy( &lp->wds_port[3].wdsAddress, &pLtv->u.u8[0], ETH_ALEN );
+					memcpy(&lp->wds_port[3].wdsAddress, &pLtv->u.u8[0], ETH_ALEN);
 					hcfPort = HCF_PORT_4;
 					break;
 				case CFG_CNF_WDS_ADDR5:
-					memcpy( &lp->wds_port[4].wdsAddress, &pLtv->u.u8[0], ETH_ALEN );
+					memcpy(&lp->wds_port[4].wdsAddress, &pLtv->u.u8[0], ETH_ALEN);
 					hcfPort = HCF_PORT_5;
 					break;
 				case CFG_CNF_WDS_ADDR6:
-					memcpy( &lp->wds_port[5].wdsAddress, &pLtv->u.u8[0], ETH_ALEN );
+					memcpy(&lp->wds_port[5].wdsAddress, &pLtv->u.u8[0], ETH_ALEN);
 					hcfPort = HCF_PORT_6;
 					break;
 #endif  /* USE_WDS */
 
 				case CFG_CNF_MCAST_PM_BUF:
 					lp->multicastPMBuffering    = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_REJECT_ANY:
 					lp->RejectAny   = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #endif
 
 				case CFG_CNF_ENCRYPTION:
 					lp->EnableEncryption    = pLtv->u.u16[0];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_CNF_AUTHENTICATION:
 					lp->authentication  = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
 		//;?should we restore this to allow smaller memory footprint
 
 				//case CFG_CNF_EXCL_UNENCRYPTED:
 					//lp->ExcludeUnencrypted  = pLtv->u.u16[0];
-					//pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					//pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					//break;
 				case CFG_CNF_MCAST_RATE:
 					/* TODO: determine if we are going to store anything based on this */
 					break;
 				case CFG_CNF_INTRA_BSS_RELAY:
 					lp->intraBSSRelay   = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #endif
 
@@ -819,14 +819,14 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 				case CFG_CNF_OWN_SSID:
 				//case CNF_DESIRED_SSID:
 				case CFG_DESIRED_SSID:
-					memset( lp->NetworkName, 0, sizeof( lp->NetworkName ));
-					memcpy( (void *)lp->NetworkName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0] );
-					pLtv->u.u16[0] = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					memset(lp->NetworkName, 0, sizeof(lp->NetworkName));
+					memcpy((void *)lp->NetworkName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					pLtv->u.u16[0] = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 
 					/* take care of the special network name "ANY" case */
-					if(( strlen( &pLtv->u.u8[2]        ) == 0 ) ||
-					   ( strcmp( &pLtv->u.u8[2], "ANY" ) == 0 ) ||
-					   ( strcmp( &pLtv->u.u8[2], "any" ) == 0 )) {
+					if((strlen(&pLtv->u.u8[2]       ) == 0) ||
+					   (strcmp(&pLtv->u.u8[2], "ANY") == 0) ||
+					   (strcmp(&pLtv->u.u8[2], "any") == 0)) {
 						/* set the SSID_STRCT llen field (u16[0]) to zero, and the
 						effectually null the string u8[2] */
 						pLtv->u.u16[0] = 0;
@@ -838,17 +838,17 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					break;
 				case CFG_CREATE_IBSS:
 					lp->CreateIBSS  = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_RTS_THRH:
 					lp->RTSThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_TX_RATE_CNTL:
 					lp->TxRateControl[0]    = pLtv->u.u16[0];
 					lp->TxRateControl[1]    = pLtv->u.u16[1];
-					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
-					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE( pLtv->u.u16[1] );
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
+					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE(pLtv->u.u16[1]);
 					break;
 				case CFG_PROMISCUOUS_MODE:
 					/* TODO: determine if we are going to store anything based on this */
@@ -860,71 +860,71 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 		//;?should we restore this to allow smaller memory footprint
 				case CFG_RTS_THRH0:
 					lp->RTSThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_TX_RATE_CNTL0:
 //;?no idea what this should be, get going so comment it out					lp->TxRateControl   = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #ifdef USE_WDS
 				case CFG_RTS_THRH1:
 					lp->wds_port[0].rtsThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                         = HCF_PORT_1;
 					break;
 				case CFG_RTS_THRH2:
 					lp->wds_port[1].rtsThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                         = HCF_PORT_2;
 					break;
 				case CFG_RTS_THRH3:
 					lp->wds_port[2].rtsThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                         = HCF_PORT_3;
 					break;
 				case CFG_RTS_THRH4:
 					lp->wds_port[3].rtsThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                         = HCF_PORT_4;
 					break;
 				case CFG_RTS_THRH5:
 					lp->wds_port[4].rtsThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                         = HCF_PORT_5;
 					break;
 				case CFG_RTS_THRH6:
 					lp->wds_port[5].rtsThreshold    = pLtv->u.u16[0];
-					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]                  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                         = HCF_PORT_6;
 					break;
 				case CFG_TX_RATE_CNTL1:
 					lp->wds_port[0].txRateCntl  = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                     = HCF_PORT_1;
 					break;
 				case CFG_TX_RATE_CNTL2:
 					lp->wds_port[1].txRateCntl  = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                     = HCF_PORT_2;
 					break;
 				case CFG_TX_RATE_CNTL3:
 					lp->wds_port[2].txRateCntl  = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                     = HCF_PORT_3;
 					break;
 				case CFG_TX_RATE_CNTL4:
 					lp->wds_port[3].txRateCntl  = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                     = HCF_PORT_4;
 					break;
 				case CFG_TX_RATE_CNTL5:
 					lp->wds_port[4].txRateCntl  = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                     = HCF_PORT_5;
 					break;
 				case CFG_TX_RATE_CNTL6:
 					lp->wds_port[5].txRateCntl  = pLtv->u.u16[0];
-					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]              = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					hcfPort                     = HCF_PORT_6;
 					break;
 #endif  /* USE_WDS */
@@ -934,18 +934,18 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					{
 						CFG_DEFAULT_KEYS_STRCT *pKeys = (CFG_DEFAULT_KEYS_STRCT *)pLtv;
 
-						pKeys->key[0].len = CNV_INT_TO_LITTLE( pKeys->key[0].len );
-						pKeys->key[1].len = CNV_INT_TO_LITTLE( pKeys->key[1].len );
-						pKeys->key[2].len = CNV_INT_TO_LITTLE( pKeys->key[2].len );
-						pKeys->key[3].len = CNV_INT_TO_LITTLE( pKeys->key[3].len );
+						pKeys->key[0].len = CNV_INT_TO_LITTLE(pKeys->key[0].len);
+						pKeys->key[1].len = CNV_INT_TO_LITTLE(pKeys->key[1].len);
+						pKeys->key[2].len = CNV_INT_TO_LITTLE(pKeys->key[2].len);
+						pKeys->key[3].len = CNV_INT_TO_LITTLE(pKeys->key[3].len);
 
-						memcpy( (void *)&(lp->DefaultKeys), (void *)pKeys,
-								sizeof( CFG_DEFAULT_KEYS_STRCT ));
+						memcpy((void *)&(lp->DefaultKeys), (void *)pKeys,
+								sizeof(CFG_DEFAULT_KEYS_STRCT));
 					}
 					break;
 				case CFG_TX_KEY_ID:
 					lp->TransmitKeyID   = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_SCAN_SSID:
 					/* TODO: determine if we are going to store anything based on this */
@@ -1001,16 +1001,16 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 				case CFG_SUPPORTED_DATA_RATES:
 					break;
 				case CFG_AP_MODE:
-//;?				lp->DownloadFirmware = ( pLtv->u.u16[0] ) + 1;
-					DBG_ERROR( DbgInfo, "set CFG_AP_MODE no longer supported\n" );
+//;?				lp->DownloadFirmware = (pLtv->u.u16[0]) + 1;
+					DBG_ERROR(DbgInfo, "set CFG_AP_MODE no longer supported\n");
 					break;
 				case CFG_ENCRYPT_STRING:
 					/* TODO: ENDIAN TRANSLATION HERE??? */
-					memset( lp->szEncryption, 0, sizeof( lp->szEncryption ));
-					memcpy( (void *)lp->szEncryption,  (void *)&pLtv->u.u8[0],
-							( pLtv->len * sizeof( hcf_16 )) );
-					wl_wep_decode( CRYPT_CODE, &sEncryption,
-								    lp->szEncryption );
+					memset(lp->szEncryption, 0, sizeof(lp->szEncryption));
+					memcpy((void *)lp->szEncryption,  (void *)&pLtv->u.u8[0],
+							(pLtv->len * sizeof(hcf_16)));
+					wl_wep_decode(CRYPT_CODE, &sEncryption,
+								    lp->szEncryption);
 
 					/* the Linux driver likes to use 1-4 for the key IDs, and then
 					convert to 0-3 when sending to the card.  The Windows code
@@ -1022,34 +1022,34 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					lp->TransmitKeyID    = sEncryption.wTxKeyID + 1;
 					lp->EnableEncryption = sEncryption.wEnabled;
 
-					memcpy( &lp->DefaultKeys, &sEncryption.EncStr,
-							sizeof( CFG_DEFAULT_KEYS_STRCT ));
+					memcpy(&lp->DefaultKeys, &sEncryption.EncStr,
+							sizeof(CFG_DEFAULT_KEYS_STRCT));
 					break;
 				/*case CFG_COUNTRY_STRING:
-					memset( lp->countryString, 0, sizeof( lp->countryString ));
-					memcpy( (void *)lp->countryString, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
+					memset(lp->countryString, 0, sizeof(lp->countryString));
+					memcpy((void *)lp->countryString, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
 					break;
 				*/
 
 				case CFG_DRIVER_ENABLE:
 					lp->driverEnable    = pLtv->u.u16[0];
-					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_WOLAS_ENABLE:
 					lp->wolasEnable = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_SET_WPA_AUTH_KEY_MGMT_SUITE:
 					lp->AuthKeyMgmtSuite = pLtv->u.u16[0];
-					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_DISASSOCIATE_ADDR:
-					pLtv->u.u16[ETH_ALEN / 2] = CNV_INT_TO_LITTLE( pLtv->u.u16[ETH_ALEN / 2] );
+					pLtv->u.u16[ETH_ALEN / 2] = CNV_INT_TO_LITTLE(pLtv->u.u16[ETH_ALEN / 2]);
 					break;
 				case CFG_ADD_TKIP_DEFAULT_KEY:
 				case CFG_REMOVE_TKIP_DEFAULT_KEY:
 					/* Endian convert the Tx Key Information */
-					pLtv->u.u16[0] = CNV_INT_TO_LITTLE( pLtv->u.u16[0] );
+					pLtv->u.u16[0] = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_ADD_TKIP_MAPPED_KEY:
 					break;
@@ -1066,7 +1066,7 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 				   being sent to the card, as they require a call to
 				   UIL_ACT_APPLY to take effect. Dynamic Entities will be sent
 				   immediately */
-				switch( pLtv->typ ) {
+				switch(pLtv->typ) {
 				case CFG_CNF_PORT_TYPE:
 				case CFG_CNF_OWN_MAC_ADDR:
 				case CFG_CNF_OWN_CHANNEL:
@@ -1129,52 +1129,52 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 					break;
 				/* Deal with this dynamic MSF RID, as it's required for WPA */
 				case CFG_DRIVER_ENABLE:
-					if( lp->driverEnable ) {
-						//hcf_cntl_port( &( lp->hcfCtx ),
-						//               HCF_PORT_ENABLE | HCF_PORT_0 );
-						// //hcf_cntl( &( lp->hcfCtx ),
-						// //         HCF_PORT_ENABLE | HCF_PORT_0 );
-						//hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_ENABLE );
-						// //hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_CONNECT );
-
-						hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_ENABLE | HCF_PORT_0 );
-						hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_CONNECT );
+					if(lp->driverEnable) {
+						//hcf_cntl_port(&(lp->hcfCtx),
+						//               HCF_PORT_ENABLE | HCF_PORT_0);
+						// //hcf_cntl(&(lp->hcfCtx),
+						// //         HCF_PORT_ENABLE | HCF_PORT_0);
+						//hcf_cntl(&(lp->hcfCtx), HCF_CNTL_ENABLE);
+						// //hcf_cntl(&(lp->hcfCtx), HCF_CNTL_CONNECT);
+
+						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_ENABLE | HCF_PORT_0);
+						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_CONNECT);
 					} else {
-						//hcf_cntl_port( &( lp->hcfCtx ),
-						//               HCF_PORT_DISABLE | HCF_PORT_0 );
-						// //hcf_cntl( &( lp->hcfCtx ),
-						// //         HCF_PORT_DISABLE | HCF_PORT_0 );
-						//hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_DISABLE );
-						// //hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_DISCONNECT );
-
-						hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_DISABLE | HCF_PORT_0 );
-						hcf_cntl( &( lp->hcfCtx ), HCF_CNTL_DISCONNECT );
+						//hcf_cntl_port(&(lp->hcfCtx),
+						//               HCF_PORT_DISABLE | HCF_PORT_0);
+						// //hcf_cntl(&(lp->hcfCtx),
+						// //         HCF_PORT_DISABLE | HCF_PORT_0);
+						//hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISABLE);
+						// //hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISCONNECT);
+
+						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISABLE | HCF_PORT_0);
+						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISCONNECT);
 					}
 					break;
 				default:
-    					wl_act_int_off( lp );
+    					wl_act_int_off(lp);
 					urq->result = hcf_put_info(&(lp->hcfCtx), (LTVP) pLtv);
-    					wl_act_int_on( lp );
+    					wl_act_int_on(lp);
 					break;
 				}
 
-				if( ltvAllocated ) {
-					kfree( pLtv );
+				if(ltvAllocated) {
+					kfree(pLtv);
 				}
 			} else {
 				urq->result = UIL_FAILURE;
 			}
 		} else {
-			DBG_ERROR( DbgInfo, "EPERM\n" );
+			DBG_ERROR(DbgInfo, "EPERM\n");
 			urq->result = UIL_FAILURE;
 			result = -EPERM;
 		}
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_put_info
 /*============================================================================*/
@@ -1199,64 +1199,64 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
+int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	int i;
 	/*------------------------------------------------------------------------*/
 
-	DBG_FUNC( "wvlan_uil_get_info" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_uil_get_info");
+	DBG_ENTER(DbgInfo);
 
-	if( urq->hcfCtx == &( lp->hcfCtx )) {
-		if(( urq->data != NULL ) && ( urq->len != 0 )) {
+	if(urq->hcfCtx == &(lp->hcfCtx)) {
+		if((urq->data != NULL) && (urq->len != 0)) {
 			ltv_t      *pLtv;
 			bool_t      ltvAllocated = FALSE;
 
 			/* Make sure that we have at least a command and length */
-			if( urq->len < ( sizeof( hcf_16 ) * 2 )) {
-				urq->len = sizeof( lp->ltvRecord );
-				DBG_ERROR( DbgInfo, "No Length/Type in LTV!!!\n" );
-				DBG_ERROR( DbgInfo, "UIL_ERR_LEN\n" );
+			if(urq->len < (sizeof(hcf_16) * 2)) {
+				urq->len = sizeof(lp->ltvRecord);
+				DBG_ERROR(DbgInfo, "No Length/Type in LTV!!!\n");
+				DBG_ERROR(DbgInfo, "UIL_ERR_LEN\n");
 				urq->result = UIL_ERR_LEN;
-				DBG_LEAVE( DbgInfo );
+				DBG_LEAVE(DbgInfo);
 				return result;
 			}
 
 			/* Verify the user's LTV record header. */
-			result = verify_area( VERIFY_READ, urq->data, sizeof( hcf_16 ) * 2 );
-			if( result != 0 ) {
-				DBG_ERROR( DbgInfo, "verify_area(), VERIFY_READ FAILED\n" );
+			result = verify_area(VERIFY_READ, urq->data, sizeof(hcf_16) * 2);
+			if(result != 0) {
+				DBG_ERROR(DbgInfo, "verify_area(), VERIFY_READ FAILED\n");
 				urq->result = UIL_FAILURE;
-				DBG_LEAVE( DbgInfo );
+				DBG_LEAVE(DbgInfo);
 				return result;
 			}
 
 			/* Get only the command and length information. */
-			result = copy_from_user( &( lp->ltvRecord ), urq->data, sizeof( hcf_16 ) * 2 );
+			result = copy_from_user(&(lp->ltvRecord), urq->data, sizeof(hcf_16) * 2);
 
 			/* Make sure the incoming LTV record length is within the bounds of
 			   the IOCTL length. */
-			if((( lp->ltvRecord.len + 1 ) * sizeof( hcf_16 )) > urq->len ) {
-				DBG_ERROR( DbgInfo, "Incoming LTV too big\n" );
-				urq->len = sizeof( lp->ltvRecord );
+			if(((lp->ltvRecord.len + 1) * sizeof(hcf_16)) > urq->len) {
+				DBG_ERROR(DbgInfo, "Incoming LTV too big\n");
+				urq->len = sizeof(lp->ltvRecord);
 				urq->result = UIL_ERR_LEN;
-				DBG_LEAVE( DbgInfo );
+				DBG_LEAVE(DbgInfo);
 				return result;
 			}
 
 			/* Determine if hcf_get_info() is needed or not */
-			switch ( lp->ltvRecord.typ ) {
+			switch (lp->ltvRecord.typ) {
 			case CFG_NIC_IDENTITY:
-				memcpy( &lp->ltvRecord.u.u8[0], &lp->NICIdentity, sizeof( lp->NICIdentity ));
+				memcpy(&lp->ltvRecord.u.u8[0], &lp->NICIdentity, sizeof(lp->NICIdentity));
 				break;
 			case CFG_PRI_IDENTITY:
-				memcpy( &lp->ltvRecord.u.u8[0], &lp->PrimaryIdentity, sizeof( lp->PrimaryIdentity ));
+				memcpy(&lp->ltvRecord.u.u8[0], &lp->PrimaryIdentity, sizeof(lp->PrimaryIdentity));
 				break;
 			case CFG_AP_MODE:
-				DBG_ERROR( DbgInfo, "set CFG_AP_MODE no longer supported, so is get useful ????\n" );
+				DBG_ERROR(DbgInfo, "set CFG_AP_MODE no longer supported, so is get useful ????\n");
 				lp->ltvRecord.u.u16[0] =
-					CNV_INT_TO_LITTLE( lp->hcfCtx.IFB_FWIdentity.comp_id ) == COMP_ID_FW_AP;
+					CNV_INT_TO_LITTLE(lp->hcfCtx.IFB_FWIdentity.comp_id) == COMP_ID_FW_AP;
 				break;
 			//case CFG_DRV_INFO:
 			case CFG_ENCRYPT_STRING:
@@ -1267,16 +1267,16 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 				urq->result = UIL_FAILURE;
 				break;
 			case CFG_DRV_INFO:
-				DBG_TRACE( DbgInfo, "Intercept CFG_DRV_INFO\n" );
-				result = cfg_driver_info( urq, lp );
+				DBG_TRACE(DbgInfo, "Intercept CFG_DRV_INFO\n");
+				result = cfg_driver_info(urq, lp);
 				break;
 			case CFG_DRV_IDENTITY:
-				DBG_TRACE( DbgInfo, "Intercept CFG_DRV_IDENTITY\n" );
-				result = cfg_driver_identity( urq, lp );
+				DBG_TRACE(DbgInfo, "Intercept CFG_DRV_IDENTITY\n");
+				result = cfg_driver_identity(urq, lp);
 				break;
 			case CFG_IFB:
 				/* IFB can be a security hole */
-				if( !capable( CAP_NET_ADMIN )) {
+				if(!capable(CAP_NET_ADMIN)) {
 					result = -EPERM;
 					break;
 				}
@@ -1287,9 +1287,9 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			default:
 
 				/* Verify the user buffer */
-				result = verify_area( VERIFY_WRITE, urq->data, urq->len );
-				if( result != 0 ) {
-					DBG_ERROR( DbgInfo, "verify_area(), VERIFY_WRITE FAILED\n" );
+				result = verify_area(VERIFY_WRITE, urq->data, urq->len);
+				if(result != 0) {
+					DBG_ERROR(DbgInfo, "verify_area(), VERIFY_WRITE FAILED\n");
 					urq->result = UIL_FAILURE;
 					break;
 				}
@@ -1297,35 +1297,35 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 				/* If the requested length is greater than the size of our local
 				   LTV record, try to allocate it from the kernel stack.
 				   Otherwise, we just use our local LTV record. */
-				if( urq->len > sizeof( lp->ltvRecord )) {
+				if(urq->len > sizeof(lp->ltvRecord)) {
 					pLtv = kmalloc(urq->len, GFP_KERNEL);
 					if (pLtv != NULL) {
 						ltvAllocated = TRUE;
 
 						/* Copy the command/length information into the new buffer. */
-						memcpy( pLtv, &( lp->ltvRecord ), sizeof( hcf_16 ) * 2 );
+						memcpy(pLtv, &(lp->ltvRecord), sizeof(hcf_16) * 2);
 					} else {
-						urq->len = sizeof( lp->ltvRecord );
+						urq->len = sizeof(lp->ltvRecord);
 						urq->result = UIL_ERR_LEN;
-						DBG_ERROR( DbgInfo, "kmalloc FAILED\n" );
-						DBG_ERROR( DbgInfo, "UIL_ERR_LEN\n" );
+						DBG_ERROR(DbgInfo, "kmalloc FAILED\n");
+						DBG_ERROR(DbgInfo, "UIL_ERR_LEN\n");
 						result = -ENOMEM;
 						break;
 					}
 				} else {
-					pLtv = &( lp->ltvRecord );
+					pLtv = &(lp->ltvRecord);
 				}
 
-    				wl_act_int_off( lp );
-				urq->result = hcf_get_info( &( lp->hcfCtx ), (LTVP) pLtv );
-    				wl_act_int_on( lp );
+    				wl_act_int_off(lp);
+				urq->result = hcf_get_info(&(lp->hcfCtx), (LTVP) pLtv);
+    				wl_act_int_on(lp);
 
 				// Copy the LTV into the user's buffer.
-				//copy_to_user( urq->data, pLtv, urq->len );
+				//copy_to_user(urq->data, pLtv, urq->len);
 
-				//if( ltvAllocated )
+				//if(ltvAllocated)
 				//{
-				//    kfree( pLtv );
+				//    kfree(pLtv);
 				//}
 
 				//urq->result = UIL_SUCCESS;
@@ -1333,7 +1333,7 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			}
 
 			/* Handle endian conversion of special fields */
-			switch( lp->ltvRecord.typ ) {
+			switch(lp->ltvRecord.typ) {
 			/* simple int gets just need the first hcf_16 byte flipped */
 			case CFG_CNF_PORT_TYPE:
 			case CFG_CNF_OWN_CHANNEL:
@@ -1406,7 +1406,7 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			case CFG_CUR_CHANNEL:
 			//case CFG_CURRENT_POWER_STATE:
 			//case CFG_CCAMODE:
-			//    lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
+			//    lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
 			//    break;
 			/* name string gets just need the first hcf_16 byte flipped (length of string) */
 			case CFG_CNF_OWN_SSID:
@@ -1415,7 +1415,7 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			case CFG_DESIRED_SSID:
 			case CFG_SCAN_SSID:
 			case CFG_CUR_SSID:
-				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
+				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
 				break;
 			/* non-length counted strings need no byte flipping */
 			case CFG_CNF_OWN_MAC_ADDR:
@@ -1435,11 +1435,11 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			//case CFG_CNF_COUNTRY_INFO:      /* special case, see page 75  of 022486, Rev C. */
 			//case CFG_CURRENT_COUNTRY_INFO:  /* special case, see page 101 of 022486, Rev C. */
 			/*
-				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
-				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[3] );
+				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
+				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[3]);
 
-				for( i = 4; i < lp->ltvRecord.len; i++ ) {
-					lp->ltvRecord.u.u16[i] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[i] );
+				for(i = 4; i < lp->ltvRecord.len; i++) {
+					lp->ltvRecord.u.u16[i] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[i]);
 				}
 				break;
 			*/
@@ -1448,57 +1448,57 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 				{
 					CFG_DEFAULT_KEYS_STRCT *pKeys = (CFG_DEFAULT_KEYS_STRCT *)&lp->ltvRecord.u.u8[0];
 
-					pKeys[0].len = CNV_INT_TO_LITTLE( pKeys[0].len );
-					pKeys[1].len = CNV_INT_TO_LITTLE( pKeys[1].len );
-					pKeys[2].len = CNV_INT_TO_LITTLE( pKeys[2].len );
-					pKeys[3].len = CNV_INT_TO_LITTLE( pKeys[3].len );
+					pKeys[0].len = CNV_INT_TO_LITTLE(pKeys[0].len);
+					pKeys[1].len = CNV_INT_TO_LITTLE(pKeys[1].len);
+					pKeys[2].len = CNV_INT_TO_LITTLE(pKeys[2].len);
+					pKeys[3].len = CNV_INT_TO_LITTLE(pKeys[3].len);
 				}
 				break;
 			case CFG_CNF_MCAST_RATE:
 			case CFG_TX_RATE_CNTL:
 			case CFG_SUPPORTED_RATE_SET_CNTL:    // Supported Rate Set Control
 			case CFG_BASIC_RATE_SET_CNTL:    // Basic Rate Set Control
-				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
-				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[1] );
+				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
+				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[1]);
 				break;
 			case CFG_DL_BUF:
 			case CFG_NIC_IDENTITY:
 			case CFG_COMMS_QUALITY:
 			case CFG_PCF_INFO:
-				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
-				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[1] );
-				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[2] );
+				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
+				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[1]);
+				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[2]);
 				break;
 			case CFG_FW_IDENTITY:
-				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
-				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[1] );
-				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[2] );
-				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[3] );
+				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
+				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[1]);
+				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[2]);
+				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[3]);
 				break;
 			//case CFG_HSI_SUP_RANGE:
 			case CFG_NIC_MFI_SUP_RANGE:
 			case CFG_NIC_CFI_SUP_RANGE:
 			case CFG_NIC_PROFILE:
 			case CFG_FW_SUP_RANGE:
-				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[0] );
-				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[1] );
-				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[2] );
-				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[3] );
-				lp->ltvRecord.u.u16[4] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[4] );
+				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
+				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[1]);
+				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[2]);
+				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[3]);
+				lp->ltvRecord.u.u16[4] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[4]);
 				break;
 			case CFG_MFI_ACT_RANGES_STA:
 			case CFG_CFI_ACT_RANGES_STA:
 			case CFG_CUR_SCALE_THRH:
 			case CFG_AUTHENTICATION_ALGORITHMS:
-				for( i = 0; i < ( lp->ltvRecord.len - 1 ); i++ ) {
-					lp->ltvRecord.u.u16[i] = CNV_INT_TO_LITTLE( lp->ltvRecord.u.u16[i] );
+				for(i = 0; i < (lp->ltvRecord.len - 1); i++) {
+					lp->ltvRecord.u.u16[i] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[i]);
 				}
 				break;
 			/* done at init time, and endian handled then */
 			case CFG_PRI_IDENTITY:
 				break;
 			case CFG_MB_INFO:
-				//wvlanEndianTranslateMailbox( pLtv );
+				//wvlanEndianTranslateMailbox(pLtv);
 				break;
 			/* MSF and HCF RIDS */
 			case CFG_IFB:
@@ -1513,10 +1513,10 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			}
 
 			// Copy the LTV into the user's buffer.
-			copy_to_user( urq->data, &( lp->ltvRecord ), urq->len );
+			copy_to_user(urq->data, &(lp->ltvRecord), urq->len);
 
-			if( ltvAllocated ) {
-				kfree( &( lp->ltvRecord ));
+			if(ltvAllocated) {
+				kfree(&(lp->ltvRecord));
 			}
 
 			urq->result = UIL_SUCCESS;
@@ -1524,11 +1524,11 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 			urq->result = UIL_FAILURE;
 		}
 	} else {
-		DBG_ERROR( DbgInfo, "UIL_ERR_WRONG_IFB\n" );
+		DBG_ERROR(DbgInfo, "UIL_ERR_WRONG_IFB\n");
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // wvlan_uil_get_info
 /*============================================================================*/
@@ -1556,29 +1556,29 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int cfg_driver_info( struct uilreq *urq, struct wl_private *lp )
+int cfg_driver_info(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "cfg_driver_info" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("cfg_driver_info");
+	DBG_ENTER(DbgInfo);
 
 
 	/* Make sure that user buffer can handle the driver information buffer */
-	if( urq->len < sizeof( lp->driverInfo )) {
-		urq->len = sizeof( lp->driverInfo );
+	if(urq->len < sizeof(lp->driverInfo)) {
+		urq->len = sizeof(lp->driverInfo);
 		urq->result = UIL_ERR_LEN;
-		DBG_LEAVE( DbgInfo );
+		DBG_LEAVE(DbgInfo);
 		return result;
 	}
 
 	/* Verify the user buffer. */
-	result = verify_area( VERIFY_WRITE, urq->data, sizeof( lp->driverInfo ));
-	if( result != 0 ) {
+	result = verify_area(VERIFY_WRITE, urq->data, sizeof(lp->driverInfo));
+	if(result != 0) {
 		urq->result = UIL_FAILURE;
-		DBG_LEAVE( DbgInfo );
+		DBG_LEAVE(DbgInfo);
 		return result;
 	}
 
@@ -1586,9 +1586,9 @@ int cfg_driver_info( struct uilreq *urq, struct wl_private *lp )
 
 	// Copy the driver information into the user's buffer.
 	urq->result = UIL_SUCCESS;
-	copy_to_user( urq->data, &( lp->driverInfo ), sizeof( lp->driverInfo ));
+	copy_to_user(urq->data, &(lp->driverInfo), sizeof(lp->driverInfo));
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // cfg_driver_info
 /*============================================================================*/
@@ -1615,37 +1615,37 @@ int cfg_driver_info( struct uilreq *urq, struct wl_private *lp )
  *      UIL_ERR_xxx value otherwise
  *
  ******************************************************************************/
-int cfg_driver_identity( struct uilreq *urq, struct wl_private *lp )
+int cfg_driver_identity(struct uilreq *urq, struct wl_private *lp)
 {
 	int result = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_driver_identity" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_driver_identity");
+	DBG_ENTER(DbgInfo);
 
 
 	/* Make sure that user buffer can handle the driver identity structure. */
-	if( urq->len < sizeof( lp->driverIdentity )) {
-		urq->len = sizeof( lp->driverIdentity );
+	if(urq->len < sizeof(lp->driverIdentity)) {
+		urq->len = sizeof(lp->driverIdentity);
 		urq->result = UIL_ERR_LEN;
-		DBG_LEAVE( DbgInfo );
+		DBG_LEAVE(DbgInfo);
 		return result;
 	}
 
 	/* Verify the user buffer. */
-	result = verify_area( VERIFY_WRITE, urq->data, sizeof( lp->driverIdentity ));
-	if( result != 0 ) {
+	result = verify_area(VERIFY_WRITE, urq->data, sizeof(lp->driverIdentity));
+	if(result != 0) {
 		urq->result = UIL_FAILURE;
-		DBG_LEAVE( DbgInfo );
+		DBG_LEAVE(DbgInfo);
 		return result;
 	}
 
 	/* Copy the driver identity into the user's buffer. */
 	urq->result = UIL_SUCCESS;
-	copy_to_user( urq->data, &( lp->driverIdentity ), sizeof( lp->driverIdentity ));
+	copy_to_user(urq->data, &(lp->driverIdentity), sizeof(lp->driverIdentity));
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return result;
 } // cfg_driver_identity
 /*============================================================================*/
@@ -1690,19 +1690,19 @@ int wvlan_set_netname(struct net_device *dev,
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_set_netname" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_set_netname");
+	DBG_ENTER(DbgInfo);
 
         wl_lock(lp, &flags);
 
-        memset( lp->NetworkName, 0, sizeof( lp->NetworkName ));
-        memcpy( lp->NetworkName, extra, wrqu->data.length);
+        memset(lp->NetworkName, 0, sizeof(lp->NetworkName));
+        memcpy(lp->NetworkName, extra, wrqu->data.length);
 
 	/* Commit the adapter parameters */
 	wl_apply(lp);
         wl_unlock(lp, &flags);
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return ret;
 } // wvlan_set_netname
 /*============================================================================*/
@@ -1742,19 +1742,19 @@ int wvlan_get_netname(struct net_device *dev,
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC( "wvlan_get_netname" );
-        DBG_ENTER( DbgInfo );
+        DBG_FUNC("wvlan_get_netname");
+        DBG_ENTER(DbgInfo);
 
         wl_lock(lp, &flags);
 
         /* Get the current network name */
-        lp->ltvRecord.len = 1 + ( sizeof( *pName ) / sizeof( hcf_16 ));
+        lp->ltvRecord.len = 1 + (sizeof(*pName) / sizeof(hcf_16));
         lp->ltvRecord.typ = CFG_CUR_SSID;
 
-        status = hcf_get_info( &( lp->hcfCtx ), (LTVP)&( lp->ltvRecord ));
+        status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if( status == HCF_SUCCESS ) {
-                pName = (wvName_t *)&( lp->ltvRecord.u.u32 );
+        if(status == HCF_SUCCESS) {
+                pName = (wvName_t *)&(lp->ltvRecord.u.u32);
 
 		memset(extra, '\0', HCF_MAX_NAME_LEN);
 		wrqu->data.length = pName->length;
@@ -1766,7 +1766,7 @@ int wvlan_get_netname(struct net_device *dev,
 
         wl_unlock(lp, &flags);
 
-        DBG_LEAVE( DbgInfo );
+        DBG_LEAVE(DbgInfo);
         return ret;
 } // wvlan_get_netname
 /*============================================================================*/
@@ -1804,20 +1804,20 @@ int wvlan_set_station_nickname(struct net_device *dev,
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC( "wvlan_set_station_nickname" );
-        DBG_ENTER( DbgInfo );
+        DBG_FUNC("wvlan_set_station_nickname");
+        DBG_ENTER(DbgInfo);
 
         wl_lock(lp, &flags);
 
-        memset( lp->StationName, 0, sizeof( lp->StationName ));
+        memset(lp->StationName, 0, sizeof(lp->StationName));
 
-        memcpy( lp->StationName, extra, wrqu->data.length);
+        memcpy(lp->StationName, extra, wrqu->data.length);
 
         /* Commit the adapter parameters */
-        wl_apply( lp );
+        wl_apply(lp);
         wl_unlock(lp, &flags);
 
-        DBG_LEAVE( DbgInfo );
+        DBG_LEAVE(DbgInfo);
         return ret;
 } // wvlan_set_station_nickname
 /*============================================================================*/
@@ -1857,19 +1857,19 @@ int wvlan_get_station_nickname(struct net_device *dev,
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC( "wvlan_get_station_nickname" );
-        DBG_ENTER( DbgInfo );
+        DBG_FUNC("wvlan_get_station_nickname");
+        DBG_ENTER(DbgInfo);
 
-        wl_lock( lp, &flags );
+        wl_lock(lp, &flags);
 
         /* Get the current station name */
-        lp->ltvRecord.len = 1 + ( sizeof( *pName ) / sizeof( hcf_16 ));
+        lp->ltvRecord.len = 1 + (sizeof(*pName) / sizeof(hcf_16));
         lp->ltvRecord.typ = CFG_CNF_OWN_NAME;
 
-        status = hcf_get_info( &( lp->hcfCtx ), (LTVP)&( lp->ltvRecord ));
+        status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if( status == HCF_SUCCESS ) {
-                pName = (wvName_t *)&( lp->ltvRecord.u.u32 );
+        if(status == HCF_SUCCESS) {
+                pName = (wvName_t *)&(lp->ltvRecord.u.u32);
 
 		memset(extra, '\0', HCF_MAX_NAME_LEN);
 		wrqu->data.length = pName->length;
@@ -1881,7 +1881,7 @@ int wvlan_get_station_nickname(struct net_device *dev,
         wl_unlock(lp, &flags);
 
 //out:
-        DBG_LEAVE( DbgInfo );
+        DBG_LEAVE(DbgInfo);
 	return ret;
 } // wvlan_get_station_nickname
 /*============================================================================*/
@@ -1920,15 +1920,15 @@ int wvlan_set_porttype(struct net_device *dev,
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC( "wvlan_set_porttype" );
-        DBG_ENTER( DbgInfo );
+        DBG_FUNC("wvlan_set_porttype");
+        DBG_ENTER(DbgInfo);
 
         wl_lock(lp, &flags);
 
         /* Validate the new value */
         portType = *((__u32 *)extra);
 
-        if( !(( portType == 1 ) || ( portType == 3 ))) {
+        if(!((portType == 1) || (portType == 3))) {
                 ret = -EINVAL;
 		goto out_unlock;
         }
@@ -1936,13 +1936,13 @@ int wvlan_set_porttype(struct net_device *dev,
         lp->PortType = portType;
 
         /* Commit the adapter parameters */
-        wl_apply( lp );
+        wl_apply(lp);
 
 out_unlock:
         wl_unlock(lp, &flags);
 
 //out:
-        DBG_LEAVE( DbgInfo );
+        DBG_LEAVE(DbgInfo);
         return ret;
 }
 
@@ -1982,21 +1982,21 @@ int wvlan_get_porttype(struct net_device *dev,
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC( "wvlan_get_porttype" );
-        DBG_ENTER( DbgInfo );
+        DBG_FUNC("wvlan_get_porttype");
+        DBG_ENTER(DbgInfo);
 
-        wl_lock( lp, &flags );
+        wl_lock(lp, &flags);
 
         /* Get the current port type */
-        lp->ltvRecord.len = 1 + ( sizeof( *pPortType ) / sizeof( hcf_16 ));
+        lp->ltvRecord.len = 1 + (sizeof(*pPortType) / sizeof(hcf_16));
         lp->ltvRecord.typ = CFG_CNF_PORT_TYPE;
 
-        status = hcf_get_info( &( lp->hcfCtx ), (LTVP)&( lp->ltvRecord ));
+        status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if( status == HCF_SUCCESS ) {
-                pPortType = (hcf_16 *)&( lp->ltvRecord.u.u32 );
+        if(status == HCF_SUCCESS) {
+                pPortType = (hcf_16 *)&(lp->ltvRecord.u.u32);
 
-                *pData = CNV_LITTLE_TO_INT( *pPortType );
+                *pData = CNV_LITTLE_TO_INT(*pPortType);
         } else {
             ret = -EFAULT;
 	}
@@ -2004,7 +2004,7 @@ int wvlan_get_porttype(struct net_device *dev,
         wl_unlock(lp, &flags);
 
 //out:
-        DBG_LEAVE( DbgInfo );
+        DBG_LEAVE(DbgInfo);
         return ret;
 } // wvlan_get_porttype
 /*============================================================================*/
@@ -2034,47 +2034,47 @@ int wvlan_get_porttype(struct net_device *dev,
  *      errno value otherwise
  *
  ******************************************************************************/
-int wvlan_rts( struct rtsreq *rrq, __u32 io_base )
+int wvlan_rts(struct rtsreq *rrq, __u32 io_base)
 {
 	int ioctl_ret = 0;
 	/*------------------------------------------------------------------------*/
 
 
-	DBG_FUNC( "wvlan_rts" );
-	DBG_ENTER( DbgInfo );
+	DBG_FUNC("wvlan_rts");
+	DBG_ENTER(DbgInfo);
 
 
-	DBG_PRINT( "io_base: 0x%08x\n", io_base );
+	DBG_PRINT("io_base: 0x%08x\n", io_base);
 
-	switch( rrq->typ ) {
+	switch(rrq->typ) {
 	  case WL_IOCTL_RTS_READ:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_READ\n");
-		rrq->data[0] = IN_PORT_WORD( io_base + rrq->reg );
-		DBG_TRACE( DbgInfo, "  reg 0x%04x ==> 0x%04x\n", rrq->reg, CNV_LITTLE_TO_SHORT( rrq->data[0] ) );
+		rrq->data[0] = IN_PORT_WORD(io_base + rrq->reg);
+		DBG_TRACE(DbgInfo, "  reg 0x%04x ==> 0x%04x\n", rrq->reg, CNV_LITTLE_TO_SHORT(rrq->data[0]));
 		break;
 	  case WL_IOCTL_RTS_WRITE:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_WRITE\n");
-		OUT_PORT_WORD( io_base + rrq->reg, rrq->data[0] );
-		DBG_TRACE( DbgInfo, "  reg 0x%04x <== 0x%04x\n", rrq->reg, CNV_LITTLE_TO_SHORT( rrq->data[0] ) );
+		OUT_PORT_WORD(io_base + rrq->reg, rrq->data[0]);
+		DBG_TRACE(DbgInfo, "  reg 0x%04x <== 0x%04x\n", rrq->reg, CNV_LITTLE_TO_SHORT(rrq->data[0]));
 		break;
 	  case WL_IOCTL_RTS_BATCH_READ:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_BATCH_READ\n");
-		IN_PORT_STRING_16( io_base + rrq->reg, rrq->data, rrq->len );
-		DBG_TRACE( DbgInfo, "  reg 0x%04x ==> %d bytes\n", rrq->reg, rrq->len * sizeof (__u16 ) );
+		IN_PORT_STRING_16(io_base + rrq->reg, rrq->data, rrq->len);
+		DBG_TRACE(DbgInfo, "  reg 0x%04x ==> %d bytes\n", rrq->reg, rrq->len * sizeof (__u16));
 		break;
 	  case WL_IOCTL_RTS_BATCH_WRITE:
 		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- WL_IOCTL_RTS_BATCH_WRITE\n");
-		OUT_PORT_STRING_16( io_base + rrq->reg, rrq->data, rrq->len );
-		DBG_TRACE( DbgInfo, "  reg 0x%04x <== %d bytes\n", rrq->reg, rrq->len * sizeof (__u16) );
+		OUT_PORT_STRING_16(io_base + rrq->reg, rrq->data, rrq->len);
+		DBG_TRACE(DbgInfo, "  reg 0x%04x <== %d bytes\n", rrq->reg, rrq->len * sizeof (__u16));
 		break;
 	default:
 
-		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- UNSUPPORTED RTS CODE: 0x%X", rrq->typ );
+		DBG_TRACE(DbgInfo, "IOCTL: WVLAN2_IOCTL_RTS -- UNSUPPORTED RTS CODE: 0x%X", rrq->typ);
 		ioctl_ret = -EOPNOTSUPP;
 		break;
 	}
 
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return ioctl_ret;
 } // wvlan_rts
 /*============================================================================*/
-- 
1.7.10.4

