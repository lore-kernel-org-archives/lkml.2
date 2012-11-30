Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab2K3RJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:09:47 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36266 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab2K3RJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:09:43 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 29/32] staging: wlags49_h2: wl_priv: converts C99 // comments
Date: Fri, 30 Nov 2012 18:58:54 +0200
Message-Id: <1354294737-5735-29-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts C99 // comments to /* */

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |  259 ++++++++++++++++------------------
 1 file changed, 123 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 193b3cd..c97e0e1 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -99,7 +99,7 @@ int cfg_driver_identity(struct uilreq *urq, struct wl_private *lp);
  ******************************************************************************/
 #if DBG
 extern dbg_info_t *DbgInfo;
-#endif  // DBG
+#endif  /* DBG */
 
 
 
@@ -167,7 +167,7 @@ int wvlan_uil(struct uilreq *urq, struct wl_private *lp)
 	}
 	DBG_LEAVE(DbgInfo);
 	return ioctl_ret;
-} // wvlan_uil
+} /* wvlan_uil */
 /*============================================================================*/
 
 
@@ -213,7 +213,7 @@ int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_connect
+} /* wvlan_uil_connect */
 /*============================================================================*/
 
 
@@ -268,7 +268,7 @@ int wvlan_uil_disconnect(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_disconnect
+} /* wvlan_uil_disconnect */
 /*============================================================================*/
 
 
@@ -346,7 +346,7 @@ int wvlan_uil_action(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_action
+} /* wvlan_uil_action */
 /*============================================================================*/
 
 
@@ -400,7 +400,7 @@ int wvlan_uil_block(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_block
+} /* wvlan_uil_block */
 /*============================================================================*/
 
 
@@ -453,7 +453,7 @@ int wvlan_uil_unblock(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_unblock
+} /* wvlan_uil_unblock */
 /*============================================================================*/
 
 
@@ -494,7 +494,7 @@ int wvlan_uil_send_diag_msg(struct uilreq *urq, struct wl_private *lp)
 				if (lp->hcfCtx.IFB_RscInd != 0) {
 					u_char *data;
 
-					// Verify the user buffer
+					/* Verify the user buffer */
 					result = verify_area(VERIFY_READ, urq->data, urq->len);
 					if (result != 0) {
 						DBG_ERROR(DbgInfo, "verify_area failed, result: %d\n", result);
@@ -510,7 +510,7 @@ int wvlan_uil_send_diag_msg(struct uilreq *urq, struct wl_private *lp)
 
 						Descp[0].buf_addr       = (wci_bufp)data;
 						Descp[0].BUF_CNT        = urq->len;
-						Descp[0].next_desc_addr = 0;    // terminate list
+						Descp[0].next_desc_addr = 0;    /* terminate list */
 
 						hcf_send_msg(&(lp->hcfCtx),  &Descp[0], HCF_PORT_0);
 						kfree(data);
@@ -541,7 +541,7 @@ int wvlan_uil_send_diag_msg(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_send_diag_msg
+} /* wvlan_uil_send_diag_msg */
 /*============================================================================*/
 
 
@@ -655,7 +655,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					break;
 				/* CFG_CNF_OWN_SSID currently same as CNF_DESIRED_SSID. Do we
 				   need separate storage for this? */
-				//case CFG_CNF_OWN_SSID:
+				/* case CFG_CNF_OWN_SSID: */
 				case CFG_CNF_OWN_ATIM_WINDOW:
 					lp->atimWindow  = pLtv->u.u16[0];
 					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
@@ -702,15 +702,15 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					lp->txPowLevel          = pLtv->u.u16[0];
 					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
-				//case CFG_CNF_SHORT_RETRY_LIMIT:    // Short Retry Limit
-				//case 0xFC33:    // Long Retry Limit
-				case CFG_SUPPORTED_RATE_SET_CNTL:        // Supported Rate Set Control
+				/* case CFG_CNF_SHORT_RETRY_LIMIT: */ /* Short Retry Limit */
+				/* case 0xFC33: */   /* Long Retry Limit */
+				case CFG_SUPPORTED_RATE_SET_CNTL:        /* Supported Rate Set Control */
 					lp->srsc[0]             = pLtv->u.u16[0];
 					lp->srsc[1]             = pLtv->u.u16[1];
 					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					pLtv->u.u16[1]          = CNV_INT_TO_LITTLE(pLtv->u.u16[1]);
 					break;
-				case CFG_BASIC_RATE_SET_CNTL:        // Basic Rate Set Control
+				case CFG_BASIC_RATE_SET_CNTL:        /* Basic Rate Set Control */
 					lp->brsc[0]             = pLtv->u.u16[0];
 					lp->brsc[1]             = pLtv->u.u16[1];
 					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
@@ -720,23 +720,23 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					lp->connectionControl   = pLtv->u.u16[0];
 					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
-				//case CFG_PROBE_DATA_RATE:
-#endif  // HERMES25
+				/* case CFG_PROBE_DATA_RATE: */
+#endif  /* HERMES25 */
 
-#if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
-		//;?should we restore this to allow smaller memory footprint
+#if 1 /* ;? (HCF_TYPE) & HCF_TYPE_AP */
+		/* ;?should we restore this to allow smaller memory footprint */
 
 				case CFG_CNF_OWN_DTIM_PERIOD:
 					lp->DTIMPeriod  = pLtv->u.u16[0];
 					pLtv->u.u16[0]  = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #ifdef WARP
-				case CFG_CNF_OWN_BEACON_INTERVAL:        // Own Beacon Interval
+				case CFG_CNF_OWN_BEACON_INTERVAL:        /* Own Beacon Interval */
 					lp->ownBeaconInterval   = pLtv->u.u16[0];
 					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
-#endif // WARP
-				case CFG_COEXISTENSE_BEHAVIOUR:         // Coexistence behavior
+#endif /* WARP */
+				case CFG_COEXISTENSE_BEHAVIOUR:         /* Coexistence behavior */
 					lp->coexistence         = pLtv->u.u16[0];
 					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
@@ -785,13 +785,13 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					lp->authentication  = pLtv->u.u16[0];
 					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
-#if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
-		//;?should we restore this to allow smaller memory footprint
+#if 1 /* ;? (HCF_TYPE) & HCF_TYPE_AP */
+		/* ;?should we restore this to allow smaller memory footprint */
 
-				//case CFG_CNF_EXCL_UNENCRYPTED:
-					//lp->ExcludeUnencrypted  = pLtv->u.u16[0];
-					//pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
-					//break;
+				/* case CFG_CNF_EXCL_UNENCRYPTED:
+					lp->ExcludeUnencrypted  = pLtv->u.u16[0];
+					pLtv->u.u16[0]          = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
+					break; */
 				case CFG_CNF_MCAST_RATE:
 					/* TODO: determine if we are going to store anything based on this */
 					break;
@@ -804,20 +804,20 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				case CFG_CNF_MICRO_WAVE:
 					/* TODO: determine if we are going to store anything based on this */
 					break;
-				//case CFG_CNF_LOAD_BALANCING:
+				/*case CFG_CNF_LOAD_BALANCING:*/
 					/* TODO: determine if we are going to store anything based on this */
-					//break;
-				//case CFG_CNF_MEDIUM_DISTRIBUTION:
+					/* break; */
+				/* case CFG_CNF_MEDIUM_DISTRIBUTION: */
 					/* TODO: determine if we are going to store anything based on this */
-					//break;
-				//case CFG_CNF_RX_ALL_GROUP_ADDRESS:
-					// TODO: determine if we are going to store anything based on this
-					//break;
-				//case CFG_CNF_COUNTRY_INFO:
+					/* break; */
+				/* case CFG_CNF_RX_ALL_GROUP_ADDRESS: */
+					/*  TODO: determine if we are going to store anything based on this */
+					/* break; */
+				/* case CFG_CNF_COUNTRY_INFO: */
 					/* TODO: determine if we are going to store anything based on this */
-					//break;
+					/* break; */
 				case CFG_CNF_OWN_SSID:
-				//case CNF_DESIRED_SSID:
+				/* case CNF_DESIRED_SSID: */
 				case CFG_DESIRED_SSID:
 					memset(lp->NetworkName, 0, sizeof(lp->NetworkName));
 					memcpy((void *)lp->NetworkName, (void *)&pLtv->u.u8[2], (size_t)pLtv->u.u16[0]);
@@ -853,17 +853,17 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				case CFG_PROMISCUOUS_MODE:
 					/* TODO: determine if we are going to store anything based on this */
 					break;
-				//case CFG_WAKE_ON_LAN:
+				/* case CFG_WAKE_ON_LAN: */
 					/* TODO: determine if we are going to store anything based on this */
-					//break;
-#if 1 //;? #if (HCF_TYPE) & HCF_TYPE_AP
-		//;?should we restore this to allow smaller memory footprint
+					/* break; */
+#if 1 /* ;? #if (HCF_TYPE) & HCF_TYPE_AP */
+		/* ;?should we restore this to allow smaller memory footprint */
 				case CFG_RTS_THRH0:
 					lp->RTSThreshold    = pLtv->u.u16[0];
 					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 				case CFG_TX_RATE_CNTL0:
-//;?no idea what this should be, get going so comment it out					lp->TxRateControl   = pLtv->u.u16[0];
+/*;?no idea what this should be, get going so comment it out					lp->TxRateControl   = pLtv->u.u16[0];*/
 					pLtv->u.u16[0]      = CNV_INT_TO_LITTLE(pLtv->u.u16[0]);
 					break;
 #ifdef USE_WDS
@@ -956,7 +956,7 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				/* these RIDS are Info RIDs, and should they be allowed for puts??? */
 				case CFG_MAX_LOAD_TIME:
 				case CFG_DL_BUF:
-				//case CFG_HSI_SUP_RANGE:
+				/* case CFG_HSI_SUP_RANGE: */
 				case CFG_NIC_SERIAL_NUMBER:
 				case CFG_NIC_IDENTITY:
 				case CFG_NIC_MFI_SUP_RANGE:
@@ -982,26 +982,26 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				case CFG_CF_POLLABLE:
 				case CFG_AUTHENTICATION_ALGORITHMS:
 				case CFG_PRIVACY_OPT_IMPLEMENTED:
-				//case CFG_CURRENT_REMOTE_RATES:
-				//case CFG_CURRENT_USED_RATES:
-				//case CFG_CURRENT_SYSTEM_SCALE:
-				//case CFG_CURRENT_TX_RATE1:
-				//case CFG_CURRENT_TX_RATE2:
-				//case CFG_CURRENT_TX_RATE3:
-				//case CFG_CURRENT_TX_RATE4:
-				//case CFG_CURRENT_TX_RATE5:
-				//case CFG_CURRENT_TX_RATE6:
+				/* case CFG_CURRENT_REMOTE_RATES: */
+				/* case CFG_CURRENT_USED_RATES: */
+				/* case CFG_CURRENT_SYSTEM_SCALE: */
+				/* case CFG_CURRENT_TX_RATE1: */
+				/* case CFG_CURRENT_TX_RATE2: */
+				/* case CFG_CURRENT_TX_RATE3: */
+				/* case CFG_CURRENT_TX_RATE4: */
+				/* case CFG_CURRENT_TX_RATE5: */
+				/* case CFG_CURRENT_TX_RATE6: */
 				case CFG_NIC_MAC_ADDR:
 				case CFG_PCF_INFO:
-				//case CFG_CURRENT_COUNTRY_INFO:
+				/* case CFG_CURRENT_COUNTRY_INFO: */
 				case CFG_PHY_TYPE:
 				case CFG_CUR_CHANNEL:
-				//case CFG_CURRENT_POWER_STATE:
-				//case CFG_CCAMODE:
+				/* case CFG_CURRENT_POWER_STATE: */
+				/* case CFG_CCAMODE: */
 				case CFG_SUPPORTED_DATA_RATES:
 					break;
 				case CFG_AP_MODE:
-//;?				lp->DownloadFirmware = (pLtv->u.u16[0]) + 1;
+/*;?				lp->DownloadFirmware = (pLtv->u.u16[0]) + 1; */
 					DBG_ERROR(DbgInfo, "set CFG_AP_MODE no longer supported\n");
 					break;
 				case CFG_ENCRYPT_STRING:
@@ -1084,14 +1084,14 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 #ifdef WARP
 				case CFG_CNF_TX_POW_LVL:
 				case CFG_CNF_CONNECTION_CNTL:
-				//case CFG_PROBE_DATA_RATE:
-#endif // HERMES25
-#if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
-		//;?should we restore this to allow smaller memory footprint
+				/*case CFG_PROBE_DATA_RATE: */
+#endif /* HERMES25 */
+#if 1 /*;? (HCF_TYPE) & HCF_TYPE_AP */
+		/*;?should we restore this to allow smaller memory footprint */
 				case CFG_CNF_OWN_DTIM_PERIOD:
 #ifdef WARP
-				case CFG_CNF_OWN_BEACON_INTERVAL:                    // Own Beacon Interval
-#endif // WARP
+				case CFG_CNF_OWN_BEACON_INTERVAL:                    /* Own Beacon Interval */
+#endif /* WARP */
 #ifdef USE_WDS
 				case CFG_CNF_WDS_ADDR1:
 				case CFG_CNF_WDS_ADDR2:
@@ -1106,8 +1106,8 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 
 				case CFG_CNF_ENCRYPTION:
 				case CFG_CNF_AUTHENTICATION:
-#if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
-		//;?should we restore this to allow smaller memory footprint
+#if 1 /* ;? (HCF_TYPE) & HCF_TYPE_AP */
+		/* ;?should we restore this to allow smaller memory footprint */
 
 				case CFG_CNF_EXCL_UNENCRYPTED:
 				case CFG_CNF_MCAST_RATE:
@@ -1115,14 +1115,14 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 #endif
 
 				case CFG_CNF_MICRO_WAVE:
-				//case CFG_CNF_LOAD_BALANCING:
-				//case CFG_CNF_MEDIUM_DISTRIBUTION:
-				//case CFG_CNF_RX_ALL_GROUP_ADDRESS:
-				//case CFG_CNF_COUNTRY_INFO:
-				//case CFG_COUNTRY_STRING:
+				/* case CFG_CNF_LOAD_BALANCING: */
+				/* case CFG_CNF_MEDIUM_DISTRIBUTION: */
+				/* case CFG_CNF_RX_ALL_GROUP_ADDRESS: */
+				/* case CFG_CNF_COUNTRY_INFO: */
+				/* case CFG_COUNTRY_STRING: */
 				case CFG_AP_MODE:
 				case CFG_ENCRYPT_STRING:
-				//case CFG_DRIVER_ENABLE:
+				/* case CFG_DRIVER_ENABLE: */
 				case CFG_WOLAS_ENABLE:
 				case CFG_MB_INFO:
 				case CFG_IFB:
@@ -1130,23 +1130,9 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 				/* Deal with this dynamic MSF RID, as it's required for WPA */
 				case CFG_DRIVER_ENABLE:
 					if (lp->driverEnable) {
-						//hcf_cntl_port(&(lp->hcfCtx),
-						//               HCF_PORT_ENABLE | HCF_PORT_0);
-						// //hcf_cntl(&(lp->hcfCtx),
-						// //         HCF_PORT_ENABLE | HCF_PORT_0);
-						//hcf_cntl(&(lp->hcfCtx), HCF_CNTL_ENABLE);
-						// //hcf_cntl(&(lp->hcfCtx), HCF_CNTL_CONNECT);
-
 						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_ENABLE | HCF_PORT_0);
 						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_CONNECT);
 					} else {
-						//hcf_cntl_port(&(lp->hcfCtx),
-						//               HCF_PORT_DISABLE | HCF_PORT_0);
-						// //hcf_cntl(&(lp->hcfCtx),
-						// //         HCF_PORT_DISABLE | HCF_PORT_0);
-						//hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISABLE);
-						// //hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISCONNECT);
-
 						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISABLE | HCF_PORT_0);
 						hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISCONNECT);
 					}
@@ -1175,7 +1161,8 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_put_info
+} /* wvlan_uil_put_info */
+
 /*============================================================================*/
 
 /*******************************************************************************
@@ -1257,12 +1244,12 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				lp->ltvRecord.u.u16[0] =
 					CNV_INT_TO_LITTLE(lp->hcfCtx.IFB_FWIdentity.comp_id) == COMP_ID_FW_AP;
 				break;
-			//case CFG_DRV_INFO:
+			/* case CFG_DRV_INFO: */
 			case CFG_ENCRYPT_STRING:
 			case CFG_COUNTRY_STRING:
 			case CFG_DRIVER_ENABLE:
 			case CFG_WOLAS_ENABLE:
-				// TODO: determine if we're going to support these
+				/* TODO: determine if we're going to support these */
 				urq->result = UIL_FAILURE;
 				break;
 			case CFG_DRV_INFO:
@@ -1282,7 +1269,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 
 				/* Else fall through to the default */
 
-			case CFG_FW_IDENTITY:   // For Hermes-1, this is cached
+			case CFG_FW_IDENTITY:   /* For Hermes-1, this is cached */
 			default:
 
 				/* Verify the user buffer */
@@ -1319,15 +1306,15 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				urq->result = hcf_get_info(&(lp->hcfCtx), (LTVP) pLtv);
 				wl_act_int_on(lp);
 
-				// Copy the LTV into the user's buffer.
-				//copy_to_user(urq->data, pLtv, urq->len);
+				/* Copy the LTV into the user's buffer. */
+				/*copy_to_user(urq->data, pLtv, urq->len); */
 
-				//if(ltvAllocated)
-				//{
-				//    kfree(pLtv);
-				//}
+				/*if(ltvAllocated)
+				{
+				    kfree(pLtv);
+				}*/
 
-				//urq->result = UIL_SUCCESS;
+				/* urq->result = UIL_SUCCESS; */
 				break;
 			}
 
@@ -1356,14 +1343,14 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 #ifdef WARP
 			case CFG_CNF_TX_POW_LVL:
 			case CFG_CNF_CONNECTION_CNTL:
-			case CFG_CNF_OWN_BEACON_INTERVAL:                          // Own Beacon Interval
-			case CFG_COEXISTENSE_BEHAVIOUR:                            // Coexistence Behavior
-			//case CFG_CNF_RX_ALL_GROUP_ADDRESS:
-#endif // HERMES25
+			case CFG_CNF_OWN_BEACON_INTERVAL:                          /* Own Beacon Interval */
+			case CFG_COEXISTENSE_BEHAVIOUR:                            /* Coexistence Behavior */
+			/*case CFG_CNF_RX_ALL_GROUP_ADDRESS: */
+#endif /* HERMES25 */
 			case CFG_CREATE_IBSS:
 			case CFG_RTS_THRH:
 			case CFG_PROMISCUOUS_MODE:
-			//case CFG_WAKE_ON_LAN:
+			/*case CFG_WAKE_ON_LAN: */
 			case CFG_RTS_THRH0:
 			case CFG_RTS_THRH1:
 			case CFG_RTS_THRH2:
@@ -1392,25 +1379,25 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			case CFG_MAX_RX_LIFETIME:
 			case CFG_CF_POLLABLE:
 			case CFG_PRIVACY_OPT_IMPLEMENTED:
-			//case CFG_CURRENT_REMOTE_RATES:
-			//case CFG_CURRENT_USED_RATES:
-			//case CFG_CURRENT_SYSTEM_SCALE:
-			//case CFG_CURRENT_TX_RATE1:
-			//case CFG_CURRENT_TX_RATE2:
-			//case CFG_CURRENT_TX_RATE3:
-			//case CFG_CURRENT_TX_RATE4:
-			//case CFG_CURRENT_TX_RATE5:
-			//case CFG_CURRENT_TX_RATE6:
+			/* case CFG_CURRENT_REMOTE_RATES: */
+			/* case CFG_CURRENT_USED_RATES: */
+			/* case CFG_CURRENT_SYSTEM_SCALE: */
+			/* case CFG_CURRENT_TX_RATE1: */
+			/* case CFG_CURRENT_TX_RATE2: */
+			/* case CFG_CURRENT_TX_RATE3: */
+			/* case CFG_CURRENT_TX_RATE4: */
+			/* case CFG_CURRENT_TX_RATE5: */
+			/* case CFG_CURRENT_TX_RATE6: */
 			case CFG_PHY_TYPE:
 			case CFG_CUR_CHANNEL:
-			//case CFG_CURRENT_POWER_STATE:
-			//case CFG_CCAMODE:
-			//    lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
-			//    break;
+			/* case CFG_CURRENT_POWER_STATE: */
+			/* case CFG_CCAMODE: */
+			/*     lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]); */
+			/*     break; */
 			/* name string gets just need the first hcf_16 byte flipped (length of string) */
 			case CFG_CNF_OWN_SSID:
 			case CFG_CNF_OWN_NAME:
-			//case CNF_DESIRED_SSID:
+			/* case CNF_DESIRED_SSID: */
 			case CFG_DESIRED_SSID:
 			case CFG_SCAN_SSID:
 			case CFG_CUR_SSID:
@@ -1431,8 +1418,8 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			case CFG_NIC_MAC_ADDR:
 			case CFG_SUPPORTED_DATA_RATES:  /* need to ensure we can treat this as a string */
 				break;
-			//case CFG_CNF_COUNTRY_INFO:      /* special case, see page 75  of 022486, Rev C. */
-			//case CFG_CURRENT_COUNTRY_INFO:  /* special case, see page 101 of 022486, Rev C. */
+			/* case CFG_CNF_COUNTRY_INFO: */     /* special case, see page 75  of 022486, Rev C. */
+			/* case CFG_CURRENT_COUNTRY_INFO: */ /* special case, see page 101 of 022486, Rev C. */
 			/*
 				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
 				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[3]);
@@ -1455,8 +1442,8 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				break;
 			case CFG_CNF_MCAST_RATE:
 			case CFG_TX_RATE_CNTL:
-			case CFG_SUPPORTED_RATE_SET_CNTL:    // Supported Rate Set Control
-			case CFG_BASIC_RATE_SET_CNTL:    // Basic Rate Set Control
+			case CFG_SUPPORTED_RATE_SET_CNTL:    /*  Supported Rate Set Control */
+			case CFG_BASIC_RATE_SET_CNTL:    /*  Basic Rate Set Control */
 				lp->ltvRecord.u.u16[0] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[0]);
 				lp->ltvRecord.u.u16[1] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[1]);
 				break;
@@ -1474,7 +1461,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				lp->ltvRecord.u.u16[2] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[2]);
 				lp->ltvRecord.u.u16[3] = CNV_INT_TO_LITTLE(lp->ltvRecord.u.u16[3]);
 				break;
-			//case CFG_HSI_SUP_RANGE:
+			/* case CFG_HSI_SUP_RANGE: */
 			case CFG_NIC_MFI_SUP_RANGE:
 			case CFG_NIC_CFI_SUP_RANGE:
 			case CFG_NIC_PROFILE:
@@ -1496,7 +1483,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 			case CFG_PRI_IDENTITY:
 				break;
 			case CFG_MB_INFO:
-				//wvlanEndianTranslateMailbox(pLtv);
+				/* wvlanEndianTranslateMailbox(pLtv); */
 				break;
 			/* MSF and HCF RIDS */
 			case CFG_IFB:
@@ -1510,7 +1497,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 				break;
 			}
 
-			// Copy the LTV into the user's buffer.
+			/* Copy the LTV into the user's buffer. */
 			copy_to_user(urq->data, &(lp->ltvRecord), urq->len);
 
 			if (ltvAllocated)
@@ -1526,7 +1513,7 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // wvlan_uil_get_info
+} /* wvlan_uil_get_info */
 /*============================================================================*/
 
 
@@ -1580,13 +1567,13 @@ int cfg_driver_info(struct uilreq *urq, struct wl_private *lp)
 
 	lp->driverInfo.card_stat = lp->hcfCtx.IFB_CardStat;
 
-	// Copy the driver information into the user's buffer.
+	/* Copy the driver information into the user's buffer. */
 	urq->result = UIL_SUCCESS;
 	copy_to_user(urq->data, &(lp->driverInfo), sizeof(lp->driverInfo));
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // cfg_driver_info
+} /* cfg_driver_info */
 /*============================================================================*/
 
 
@@ -1643,7 +1630,7 @@ int cfg_driver_identity(struct uilreq *urq, struct wl_private *lp)
 
 	DBG_LEAVE(DbgInfo);
 	return result;
-} // cfg_driver_identity
+} /* cfg_driver_identity */
 /*============================================================================*/
 
 
@@ -1700,7 +1687,7 @@ int wvlan_set_netname(struct net_device *dev,
 
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wvlan_set_netname
+} /* wvlan_set_netname */
 /*============================================================================*/
 
 
@@ -1764,7 +1751,7 @@ int wvlan_get_netname(struct net_device *dev,
 
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wvlan_get_netname
+} /* wvlan_get_netname */
 /*============================================================================*/
 
 
@@ -1815,7 +1802,7 @@ int wvlan_set_station_nickname(struct net_device *dev,
 
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wvlan_set_station_nickname
+} /* wvlan_set_station_nickname */
 /*============================================================================*/
 
 
@@ -1876,10 +1863,10 @@ int wvlan_get_station_nickname(struct net_device *dev,
 
 	wl_unlock(lp, &flags);
 
-//out:
+/* out: */
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wvlan_get_station_nickname
+} /* wvlan_get_station_nickname */
 /*============================================================================*/
 
 
@@ -1937,7 +1924,7 @@ int wvlan_set_porttype(struct net_device *dev,
 out_unlock:
 	wl_unlock(lp, &flags);
 
-//out:
+/* out: */
 	DBG_LEAVE(DbgInfo);
 	return ret;
 }
@@ -1999,13 +1986,13 @@ int wvlan_get_porttype(struct net_device *dev,
 
 	wl_unlock(lp, &flags);
 
-//out:
+/* out: */
 	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wvlan_get_porttype
+} /* wvlan_get_porttype */
 /*============================================================================*/
 
-#endif  // WIRELESS_EXT
+#endif  /* WIRELESS_EXT */
 
 
 
@@ -2072,7 +2059,7 @@ int wvlan_rts(struct rtsreq *rrq, __u32 io_base)
 
 	DBG_LEAVE(DbgInfo);
 	return ioctl_ret;
-} // wvlan_rts
+} /* wvlan_rts */
 /*============================================================================*/
 
 #endif  /* USE_RTS */
-- 
1.7.10.4

