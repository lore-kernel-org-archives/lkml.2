Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0CSR6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:58:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:20002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0CSR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aRKIX1Lf5lNvN+wJbEkq0IUJuNH/TbDNYM/SdNAH/UflifhAm3FWAMyaTanjnUnuHF
         Xbdgf4YGBepu7L+m/B+YE7lOLJtgOCSt+KlNOTRvDxfDnoaG2L2yFeTBbUJvhMSGplTp
         MWD7cVaBITt4MdWIDtALbXy6uerU+GTHFMaA4=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com, davem@davemloft.net,
       a.beregalov@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 4/4] Staging:rt2860: fix coding style issue in rt_main_dev.c This is a patch to the rt_main_dev.c file that fixes up errors found by the checkpatch.pl tool
Date: Fri, 19 Mar 2010 22:57:50 +0500
Message-Id: <1269021470-25362-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/rt2860/rt_main_dev.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index fbddb00..ad60cea 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -439,13 +439,13 @@ int rt28xx_open(struct net_device *dev)
 	RTMPInitPCIeLinkCtrlValue(pAd);
 #endif /* RTMP_MAC_PCI // */
 
-	return (retval);
+	return retval;
 
 err:
 /*+++Add by shiang, move from rt28xx_init() to here. */
 	RtmpOSIRQRelease(net_dev);
 /*---Add by shiang, move from rt28xx_init() to here. */
-	return (-1);
+	return -1;
 }				/* End of rt28xx_open */
 
 static const struct net_device_ops rt2860_netdev_ops = {
@@ -534,7 +534,7 @@ int rt28xx_packet_xmit(struct sk_buff *skb)
 	}
 
 	RTMP_SET_PACKET_5VT(pPacket, 0);
-	STASendPackets((void *)pAd, (void **)& pPacket, 1);
+	STASendPackets((void *)pAd, (void **)&pPacket, 1);
 
 	status = NETDEV_TX_OK;
 done:
@@ -571,7 +571,7 @@ static int rt28xx_send_packets(IN struct sk_buff *skb_p,
 		return NETDEV_TX_OK;
 	}
 
-	NdisZeroMemory((u8 *)& skb_p->cb[CB_OFF], 15);
+	NdisZeroMemory((u8 *)&skb_p->cb[CB_OFF], 15);
 	RTMP_SET_PACKET_NET_DEVICE_MBSSID(skb_p, MAIN_MBSSID);
 
 	return rt28xx_packet_xmit(skb_p);
@@ -628,13 +628,13 @@ void tbtt_tasklet(unsigned long data)
     ========================================================================
 
     Routine Description:
-        return ethernet statistics counter
+	return ethernet statistics counter
 
     Arguments:
-        net_dev                     Pointer to net_device
+	net_dev				Pointer to net_device
 
     Return Value:
-        net_device_stats*
+	net_device_stats*
 
     Note:
 
@@ -728,9 +728,9 @@ int AdapterBlockAllocateMemory(void *handle, void ** ppAd)
 
 	if (*ppAd) {
 		NdisZeroMemory(*ppAd, sizeof(struct rt_rtmp_adapter));
-		((struct rt_rtmp_adapter *)* ppAd)->OS_Cookie = handle;
-		return (NDIS_STATUS_SUCCESS);
+		((struct rt_rtmp_adapter *)*ppAd)->OS_Cookie = handle;
+		return NDIS_STATUS_SUCCESS;
 	} else {
-		return (NDIS_STATUS_FAILURE);
+		return NDIS_STATUS_FAILURE;
 	}
 }
-- 
1.7.0.2

