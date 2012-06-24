Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2FXXz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:55:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12037 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2FXXzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:55:55 -0400
Date: Mon, 25 Jun 2012 01:55:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] staging: vt6656: iwctl: Remove redundant blank lines
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250147170.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of excessive blank lines in iwctl.c - this patch
gets rid of most of those that I personally considered the most
obvious ones.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 76 ------------------------------------------
 1 file changed, 76 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 5740438..9a49fa9 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -81,14 +81,12 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	pDevice->wstats.discard.retries = pDevice->scStatistic.dwTsrErr;
 	pDevice->wstats.discard.misc = 0;
 	pDevice->wstats.miss.beacon = 0;
-
 	return &pDevice->wstats;
 }
 
 /*
  * Wireless Handler : get protocol name
  */
-
 int iwctl_giwname(struct net_device *dev,
 			 struct iw_request_info *info,
 			 char *wrq,
@@ -101,7 +99,6 @@ int iwctl_giwname(struct net_device *dev,
 /*
  * Wireless Handler : set scan
  */
-
 int iwctl_siwscan(struct net_device *dev,
              struct iw_request_info *info,
 			 struct iw_point *wrq,
@@ -176,7 +173,6 @@ if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 /*
  * Wireless Handler : get scan results
  */
-
 int iwctl_giwscan(struct net_device *dev,
              struct iw_request_info *info,
 			 struct iw_point *wrq,
@@ -320,17 +316,13 @@ int iwctl_giwscan(struct net_device *dev,
 
         }
     }// for
-
 	wrq->length = current_ev - extra;
 	return 0;
-
 }
 
-
 /*
  * Wireless Handler : set frequence or channel
  */
-
 int iwctl_siwfreq(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_freq *wrq,
@@ -373,7 +365,6 @@ int iwctl_siwfreq(struct net_device *dev,
 /*
  * Wireless Handler : get frequence or channel
  */
-
 int iwctl_giwfreq(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_freq *wrq,
@@ -396,14 +387,12 @@ int iwctl_giwfreq(struct net_device *dev,
 		wrq->e = 1;
 	}
 #endif
-
 	return 0;
 }
 
 /*
  * Wireless Handler : set operation mode
  */
-
 int iwctl_siwmode(struct net_device *dev,
              struct iw_request_info *info,
              __u32 *wmode,
@@ -470,7 +459,6 @@ int iwctl_siwmode(struct net_device *dev,
 /*
  * Wireless Handler : get operation mode
  */
-
 void iwctl_giwmode(struct net_device *dev,
              struct iw_request_info *info,
              __u32 *wmode,
@@ -500,11 +488,9 @@ void iwctl_giwmode(struct net_device *dev,
 	}
 }
 
-
 /*
  * Wireless Handler : get capability range
  */
-
 void iwctl_giwrange(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
@@ -556,7 +542,6 @@ void iwctl_giwrange(struct net_device *dev,
 		range->min_frag = 256;
 		range->max_frag = 2312;
 
-
 	    // the encoding capabilities
 	    range->num_encoding_sizes = 3;
 	    // 64(40) bits WEP
@@ -580,7 +565,6 @@ void iwctl_giwrange(struct net_device *dev,
 		range->pm_capa = IW_POWER_PERIOD | IW_POWER_TIMEOUT | IW_POWER_ALL_R;
 
 		// Transmit Power - values are in mW
-
         range->txpower[0] = 100;
 		range->num_txpower = 1;
 		range->txpower_capa = IW_TXPOW_MWATT;
@@ -602,11 +586,9 @@ void iwctl_giwrange(struct net_device *dev,
 	}
 }
 
-
 /*
  * Wireless Handler : set ap mac address
  */
-
 int iwctl_siwap(struct net_device *dev,
              struct iw_request_info *info,
 			 struct sockaddr *wrq,
@@ -623,7 +605,6 @@ int iwctl_siwap(struct net_device *dev,
 		rc = -EINVAL;
 	else {
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
-
 	//mike :add
 	 if ((is_broadcast_ether_addr(pMgmt->abyDesireBSSID)) ||
 	     (memcmp(pMgmt->abyDesireBSSID, ZeroBSSID, 6) == 0)){
@@ -657,7 +638,6 @@ int iwctl_siwap(struct net_device *dev,
 /*
  * Wireless Handler : get ap mac address
  */
-
 int iwctl_giwap(struct net_device *dev,
              struct iw_request_info *info,
 			 struct sockaddr *wrq,
@@ -666,7 +646,6 @@ int iwctl_giwap(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
 
     memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
@@ -679,16 +658,12 @@ int iwctl_giwap(struct net_device *dev,
     }
 
 	wrq->sa_family = ARPHRD_ETHER;
-
 	return 0;
-
 }
 
-
 /*
  * Wireless Handler : get ap list
  */
-
 int iwctl_giwaplist(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
@@ -700,7 +675,6 @@ int iwctl_giwaplist(struct net_device *dev,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST \n");
 	// Only super-user can see AP list
 
@@ -710,7 +684,6 @@ int iwctl_giwaplist(struct net_device *dev,
 	}
 
 	if (wrq->pointer) {
-
 		PKnownBSS pBSS = &(pMgmt->sBSSList[0]);
 
 		for (ii = 0, jj= 0; ii < MAX_BSS_NUM; ii++) {
@@ -732,11 +705,9 @@ int iwctl_giwaplist(struct net_device *dev,
 		memcpy(extra, sock, sizeof(struct sockaddr)*jj);
 		memcpy(extra + sizeof(struct sockaddr)*jj, qual, sizeof(struct iw_quality)*jj);
 	}
-
 	return rc;
 }
 
-
 /*
  * Wireless Handler : set essid
  */
@@ -847,12 +818,9 @@ int iwctl_siwessid(struct net_device *dev,
     if (pDevice->flags & DEVICE_FLAGS_OPENED) {
 	    pDevice->bCommit = TRUE;
 	}
-
-
 	return 0;
 }
 
-
 /*
  * Wireless Handler : get essid
  */
@@ -861,7 +829,6 @@ void iwctl_giwessid(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
@@ -883,7 +850,6 @@ void iwctl_giwessid(struct net_device *dev,
 /*
  * Wireless Handler : set data rate
  */
-
 int iwctl_siwrate(struct net_device *dev,
              struct iw_request_info *info,
 			 struct iw_param *wrq,
@@ -1005,8 +971,6 @@ void iwctl_giwrate(struct net_device *dev,
     }
 }
 
-
-
 /*
  * Wireless Handler : set rts threshold
  */
@@ -1020,7 +984,6 @@ int iwctl_siwrts(struct net_device *dev,
 
 	else if (wrq->disabled)
 		pDevice->wRTSThreshold = 2312;
-
 	else
 		pDevice->wRTSThreshold = wrq->value;
 
@@ -1030,7 +993,6 @@ int iwctl_siwrts(struct net_device *dev,
 /*
  * Wireless Handler : get rts
  */
-
 int iwctl_giwrts(struct net_device *dev,
              struct iw_request_info *info,
 			 struct iw_param *wrq,
@@ -1049,7 +1011,6 @@ int iwctl_giwrts(struct net_device *dev,
 /*
  * Wireless Handler : set fragment threshold
  */
-
 int iwctl_siwfrag(struct net_device *dev,
              struct iw_request_info *info,
 			 struct iw_param *wrq,
@@ -1059,10 +1020,8 @@ int iwctl_siwfrag(struct net_device *dev,
     int rc = 0;
     int fthr = wrq->value;
 
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG \n");
 
-
     if (wrq->disabled)
 		fthr = 2312;
     if((fthr < 256) || (fthr > 2312)) {
@@ -1071,7 +1030,6 @@ int iwctl_siwfrag(struct net_device *dev,
 		 fthr &= ~0x1;	// Get an even value
 	     pDevice->wFragmentationThreshold = (u16)fthr;
     }
-
 	return rc;
 }
 
@@ -1094,8 +1052,6 @@ int iwctl_giwfrag(struct net_device *dev,
 	return 0;
 }
 
-
-
 /*
  * Wireless Handler : set retry threshold
  */
@@ -1107,7 +1063,6 @@ int iwctl_siwretry(struct net_device *dev,
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     int rc = 0;
 
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
 
 	if (wrq->disabled) {
@@ -1129,8 +1084,6 @@ int iwctl_siwretry(struct net_device *dev,
 	if (wrq->flags & IW_RETRY_LIFETIME) {
 		pDevice->wMaxTransmitMSDULifetime = wrq->value;
 	}
-
-
 	return rc;
 }
 
@@ -1160,11 +1113,9 @@ int iwctl_giwretry(struct net_device *dev,
 			wrq->flags |= IW_RETRY_MIN;
 	}
 
-
 	return 0;
 }
 
-
 /*
  * Wireless Handler : set encode mode
  */
@@ -1179,7 +1130,6 @@ int iwctl_siwencode(struct net_device *dev,
 	int ii,uu, rc = 0;
 	int index = (wrq->flags & IW_ENCODE_INDEX);
 
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
 
 	// Check the size of the key
@@ -1268,7 +1218,6 @@ int iwctl_siwencode(struct net_device *dev,
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	   memset(pMgmt->abyDesireBSSID, 0xFF,6);
 #endif
-
 	return rc;
 }
 
@@ -1326,11 +1275,9 @@ int iwctl_giwencode(struct net_device *dev,
 	}
 
 	wrq->flags |= index+1;
-
 	return 0;
 }
 
-
 /*
  * Wireless Handler : set power mode
  */
@@ -1393,10 +1340,8 @@ int iwctl_giwpower(struct net_device *dev,
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
     int mode = pDevice->ePSMode;
 
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
 
-
 	if ((wrq->disabled = (mode == WMAC_POWER_CAM)))
 	    return 0;
 
@@ -1408,11 +1353,9 @@ int iwctl_giwpower(struct net_device *dev,
 		wrq->flags = IW_POWER_PERIOD;
 	}
 	wrq->flags |= IW_POWER_ALL_R;
-
 	return 0;
 }
 
-
 /*
  * Wireless Handler : get Sensitivity
  */
@@ -1434,8 +1377,6 @@ int iwctl_giwsens(struct net_device *dev,
     };
 	wrq->disabled = (wrq->value == 0);
 	wrq->fixed = 1;
-
-
 	return 0;
 }
 
@@ -1506,7 +1447,6 @@ int iwctl_siwauth(struct net_device *dev,
 				pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 			else pMgmt->eAuthenMode = WMAC_AUTH_WPA;
 		}
-
 		break;
 	case IW_AUTH_TKIP_COUNTERMEASURES:
 		break;		/* FIXME */
@@ -1537,7 +1477,6 @@ int iwctl_siwauth(struct net_device *dev,
 			pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
 			 PRINT_K("iwctl_siwauth:set WPADEV to disaable at 2?????\n");
 		}
-
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -1546,7 +1485,6 @@ int iwctl_siwauth(struct net_device *dev,
    return ret;
 }
 
-
 int iwctl_giwauth(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_param *wrq,
@@ -1555,8 +1493,6 @@ int iwctl_giwauth(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
-
-
 int iwctl_siwgenie(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_point *wrq,
@@ -1610,11 +1546,9 @@ int iwctl_giwgenie(struct net_device *dev,
 		}else
 			ret = -E2BIG;
 	}
-
 	return ret;
 }
 
-
 int iwctl_siwencodeext(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
@@ -1681,7 +1615,6 @@ if(ext->key_len) {
   key_len=ext->key_len;
   memcpy(key, &ext->key[0], key_len);
 	}
-
 memset(key_array, 0, 64);
 if ( key_len > 0) {
      memcpy(key_array, key, key_len);
@@ -1732,7 +1665,6 @@ if(pDevice->bwextstep3 == TRUE) {
      KeyvInitTable(pDevice,&pDevice->sKey);
 		 }
 //******
-
 		spin_lock_irq(&pDevice->lock);
  ret = wpa_set_keys(pDevice, param, TRUE);
 		spin_unlock_irq(&pDevice->lock);
@@ -1742,8 +1674,6 @@ kfree(param);
 	return ret;
 }
 
-
-
 int iwctl_giwencodeext(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
@@ -1779,9 +1709,7 @@ int iwctl_siwmlme(struct net_device *dev,
 	default:
 		ret = -EOPNOTSUPP;
 	}
-
 	return ret;
-
 }
 
 #endif
@@ -1846,21 +1774,17 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) NULL,				// -- hole --
 };
 
-
 static const iw_handler		iwctl_private_handler[] =
 {
 	NULL,				// SIOCIWFIRSTPRIV
 };
 
-
 struct iw_priv_args iwctl_private_args[] = {
 { IOCTL_CMD_SET,
   IW_PRIV_TYPE_CHAR | 1024, 0,
   "set"},
 };
 
-
-
 const struct iw_handler_def	iwctl_handler_def =
 {
 	.get_wireless_stats = &iwctl_get_wireless_stats,
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

