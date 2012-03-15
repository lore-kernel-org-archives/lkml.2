Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032417Ab2COXeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:34:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161612Ab2COXdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:33:46 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 2/2] Staging: rtl8187se: r8180_wx.c: Cleaned up comments
Date: Thu, 15 Mar 2012 19:32:08 -0400
Message-Id: <1331854328-21794-3-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331854328-21794-1-git-send-email-amiller@amilx.com>
References: <1331854328-21794-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Realigned some comments and removed small bit of
old comments that I missed in my last commit

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_wx.c |  121 ++++++++++++++++-----------------
 1 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 9d03cfb..303ec69 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -29,16 +29,16 @@ u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
 #define RATE_COUNT ARRAY_SIZE(rtl8180_rates)
 
 static CHANNEL_LIST DefaultChannelPlan[] = {
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64}, 19},			/*FCC							*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},											/*IC							*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*ETSI							*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*Spain. Change to ETSI.		*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*France. Change to ETSI.		*/
-	{{14, 36, 40, 44, 48, 52, 56, 60, 64}, 9},											/*MKK							*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},/*MKK1						*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*Israel.						*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 34, 38, 42, 46}, 17},					/*For 11a , TELEC				*/
-	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}								/*For Global Domain. 1-11:active scan, 12-14 passive scan.*/	/* +YJ, 080626 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64}, 19},		/* FCC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},						/* IC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/* ETSI	*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/* Spain. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/* France. Change to ETSI. */
+	{{14, 36, 40, 44, 48, 52, 56, 60, 64}, 9},						/* MKK */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},	/* MKK1	*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/* Israel */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 34, 38, 42, 46}, 17},			/* For 11a , TELEC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}					/* For Global Domain. 1-11:active scan, 12-14 passive scan.*/	/* +YJ, 080626 */
 };
 static int r8180_wx_get_freq(struct net_device *dev,
 			     struct iw_request_info *a,
@@ -195,18 +195,20 @@ static int r8180_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
 
 /* YJ,add,080819,for hidden ap */
 struct  iw_range_with_scan_capa	{
-		/* Informative stuff (to choose between different interface)	*/
-		__u32		throughput;		/* To give an idea...				*/
+		/* Informative stuff (to choose between different interface) */
+
+		__u32		throughput; /* To give an idea... */
+
 		/* In theory this value should be the maximum benchmarked
-		* TCP/IP throughput, because with most of these devices the
-		* bit rate is meaningless (overhead an co) to estimate how
-		* fast the connection will go and pick the fastest one.
-		* I suggest people to play with Netperf or any benchmark...
-		*/
+		 * TCP/IP throughput, because with most of these devices the
+		 * bit rate is meaningless (overhead an co) to estimate how
+		 * fast the connection will go and pick the fastest one.
+		 * I suggest people to play with Netperf or any benchmark...
+		 */
 
 		/* NWID (or domain id)	*/
-		__u32           min_nwid;       /* Minimal NWID we are able to set */
-		__u32			max_nwid;		/* Maximal NWID we are able to set */
+		__u32           min_nwid; /* Minimal NWID we are able to set */
+		__u32			max_nwid; /* Maximal NWID we are able to set */
 
 		/* Old Frequency (backward compat - moved lower ) */
 		__u16			old_num_channels;
@@ -289,8 +291,8 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 			range->freq[val].e = 1;
 			val++;
 		} else {
-			/* FIXME: do we need to set anything for channels	*/
-			/* we don't use ?	*/
+			/* FIXME: do we need to set anything for channels */
+			/* we don't use ? */
 		}
 
 		if (val == IW_MAX_FREQUENCIES)
@@ -1016,7 +1018,6 @@ static int r8180_wx_set_channelplan(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	/* struct ieee80211_device *ieee = netdev_priv(dev); */
 	int *val = (int *)extra;
 	int i;
 	printk("-----in fun %s\n", __func__);
@@ -1105,7 +1106,6 @@ static int r8180_wx_set_auth(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	/* printk("====>%s()\n", __func__); */
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int ret = 0;
 
@@ -1158,62 +1158,62 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
 
 }
 static iw_handler r8180_wx_handlers[] =	{
-		NULL,						/* SIOCSIWCOMMIT */
+		NULL,					/* SIOCSIWCOMMIT */
 		r8180_wx_get_name,			/* SIOCGIWNAME */
-		dummy,						/* SIOCSIWNWID */
-		dummy,						/* SIOCGIWNWID */
+		dummy,					/* SIOCSIWNWID */
+		dummy,					/* SIOCGIWNWID */
 		r8180_wx_set_freq,			/* SIOCSIWFREQ */
 		r8180_wx_get_freq,			/* SIOCGIWFREQ */
 		r8180_wx_set_mode,			/* SIOCSIWMODE */
 		r8180_wx_get_mode,			/* SIOCGIWMODE */
 		r8180_wx_set_sens,			/* SIOCSIWSENS */
 		r8180_wx_get_sens,			/* SIOCGIWSENS */
-		NULL,						/* SIOCSIWRANGE */
-		rtl8180_wx_get_range,		/* SIOCGIWRANGE */
-		NULL,						/* SIOCSIWPRIV */
-		NULL,						/* SIOCGIWPRIV */
-		NULL,						/* SIOCSIWSTATS */
-		NULL,						/* SIOCGIWSTATS */
-		dummy,						/* SIOCSIWSPY */
-		dummy,						/* SIOCGIWSPY */
-		NULL,						/* SIOCGIWTHRSPY */
-		NULL,						/* SIOCWIWTHRSPY */
+		NULL,					/* SIOCSIWRANGE */
+		rtl8180_wx_get_range,			/* SIOCGIWRANGE */
+		NULL,					/* SIOCSIWPRIV */
+		NULL,					/* SIOCGIWPRIV */
+		NULL,					/* SIOCSIWSTATS */
+		NULL,					/* SIOCGIWSTATS */
+		dummy,					/* SIOCSIWSPY */
+		dummy,					/* SIOCGIWSPY */
+		NULL,					/* SIOCGIWTHRSPY */
+		NULL,					/* SIOCWIWTHRSPY */
 		r8180_wx_set_wap,			/* SIOCSIWAP */
 		r8180_wx_get_wap,			/* SIOCGIWAP */
 		r8180_wx_set_mlme,			/* SIOCSIWMLME*/
-		dummy,						/* SIOCGIWAPLIST -- depricated */
+		dummy,					/* SIOCGIWAPLIST -- depricated */
 		r8180_wx_set_scan,			/* SIOCSIWSCAN */
 		r8180_wx_get_scan,			/* SIOCGIWSCAN */
 		r8180_wx_set_essid,			/* SIOCSIWESSID */
 		r8180_wx_get_essid,			/* SIOCGIWESSID */
-		dummy,						/* SIOCSIWNICKN */
-		dummy,						/* SIOCGIWNICKN */
-		NULL,						/* -- hole -- */
-		NULL,						/* -- hole -- */
+		dummy,					/* SIOCSIWNICKN */
+		dummy,					/* SIOCGIWNICKN */
+		NULL,					/* -- hole -- */
+		NULL,					/* -- hole -- */
 		r8180_wx_set_rate,			/* SIOCSIWRATE */
 		r8180_wx_get_rate,			/* SIOCGIWRATE */
 		r8180_wx_set_rts,			/* SIOCSIWRTS */
 		r8180_wx_get_rts,			/* SIOCGIWRTS */
 		r8180_wx_set_frag,			/* SIOCSIWFRAG */
 		r8180_wx_get_frag,			/* SIOCGIWFRAG */
-		dummy,						/* SIOCSIWTXPOW */
-		dummy,						/* SIOCGIWTXPOW */
+		dummy,					/* SIOCSIWTXPOW */
+		dummy,					/* SIOCGIWTXPOW */
 		r8180_wx_set_retry,			/* SIOCSIWRETRY */
 		r8180_wx_get_retry,			/* SIOCGIWRETRY */
 		r8180_wx_set_enc,			/* SIOCSIWENCODE */
 		r8180_wx_get_enc,			/* SIOCGIWENCODE */
 		r8180_wx_set_power,			/* SIOCSIWPOWER */
 		r8180_wx_get_power,			/* SIOCGIWPOWER */
-		NULL,						/*---hole---*/
-		NULL,						/*---hole---*/
-		r8180_wx_set_gen_ie,		/* SIOCSIWGENIE */
-		NULL,						/* SIOCSIWGENIE */
+		NULL,					/*---hole---*/
+		NULL,					/*---hole---*/
+		r8180_wx_set_gen_ie,			/* SIOCSIWGENIE */
+		NULL,					/* SIOCSIWGENIE */
 		r8180_wx_set_auth,			/* SIOCSIWAUTH */
-		NULL,						/* SIOCSIWAUTH */
-		r8180_wx_set_enc_ext,		/* SIOCSIWENCODEEXT */
-		NULL,						/* SIOCSIWENCODEEXT */
-		NULL,						/* SIOCSIWPMKSA */
-		NULL,						/*---hole---*/
+		NULL,					/* SIOCSIWAUTH */
+		r8180_wx_set_enc_ext,			/* SIOCSIWENCODEEXT */
+		NULL,					/* SIOCSIWENCODEEXT */
+		NULL,					/* SIOCSIWPMKSA */
+		NULL,					/*---hole---*/
 };
 
 
@@ -1322,7 +1322,7 @@ static const struct iw_priv_args r8180_private_args[] = {
 
 
 static iw_handler r8180_private_handler[] = {
-	r8180_wx_set_crcmon,   /*SIOCIWSECONDPRIV*/
+	r8180_wx_set_crcmon, /*SIOCIWSECONDPRIV*/
 	dummy,
 	r8180_wx_set_beaconinterval,
 	dummy,
@@ -1354,16 +1354,15 @@ static inline int is_same_network(struct ieee80211_network *src,
 									struct ieee80211_network *dst,
 				  struct ieee80211_device *ieee)
 {
-		/*		A network is only a duplicate if the channel, BSSID, ESSID
-		* and the capability field (in particular IBSS and BSS) all match.
-		* We treat all <hidden> with the same BSSID and channel
-		* as one network		*/
-		return (((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) &&	/* YJ,mod, 080819,for hidden ap	*/
-			/* ((src->ssid_len == dst->ssid_len) && */
+		/* A network is only a duplicate if the channel, BSSID, ESSID
+		 * and the capability field (in particular IBSS and BSS) all match.
+		 * We treat all <hidden> with the same BSSID and channel
+		 * as one network
+		 */
+		return (((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) && /* YJ,mod, 080819,for hidden ap */
 			(src->channel == dst->channel) &&
 			!memcmp(src->bssid, dst->bssid, ETH_ALEN) &&
 			(!memcmp(src->ssid, dst->ssid, src->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) &&  /* YJ,mod, 080819,for hidden ap */
-			/*!memcmp(src->ssid, dst->ssid, src->ssid_len) && */
 			((src->capability & WLAN_CAPABILITY_IBSS) ==
 			(dst->capability & WLAN_CAPABILITY_IBSS)) &&
 			((src->capability & WLAN_CAPABILITY_BSS) ==
@@ -1376,11 +1375,9 @@ static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device* ieee = priv->ieee80211;
 	struct iw_statistics* wstats = &priv->wstats;
-	/* struct ieee80211_network* target = NULL; */
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
-	/* unsigned long flag; */
 
 	if (ieee->state < IEEE80211_LINKED)	{
 		wstats->qual.qual = 0;
-- 
1.7.7.6

