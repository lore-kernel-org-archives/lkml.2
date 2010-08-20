Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0HTVAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:00:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40675 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0HTVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=fbGkYtsRnEPIN3AHYQvWEKaAV9xh+HbOIVdwg+M53QWRegoYI0JzHqCtFybSW0BbL+
         uW++DW4qqeFCCpK4h6pO3ljHcXv90dsjTYzd3TbrDWGRkQka6c8X9MHzjcuN+RB4rgnw
         sM8k3WcnQyLHZkMCJYFffCEANNuRdjb4j/dLk=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 17:00:18 -0400
Message-ID: <AANLkTimBc6TKMi=A--m+e6sys7tKQqV-4NGHiPv=r-LG@mail.gmail.com>
Subject: [PATCH 2/8] Staging: rtl8187se: r8180_core: fixed alot of
 checkpatch.pl issues
From: T Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
        joe@perches.com, pshah.mumbai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From df0d81636e05d3a1047b1568070780dedbfeed3b Mon Sep 17 00:00:00 2001
From: Tracey Dent <Tdent48227@gmail.com>
Date: Thu, 19 Aug 2010 17:09:42 -0400
Subject: [PATCH 2/8] Staging: rtl8187se: r8180_core: fixed alot of
checkpatch.pl issues

Fixed numerous coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   94 ++++++++++++++++----------------
 1 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c
b/drivers/staging/rtl8187se/r8180_core.c
index ed7457b..eee21c5 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1,30 +1,30 @@
 /*
-   This is part of rtl818x pci OpenSource driver - v 0.1
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
-   Released under the terms of GPL (General Public License)
+	This is part of rtl818x pci OpenSource driver - v 0.1
+	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Released under the terms of GPL (General Public License)

-   Parts of this driver are based on the GPL part of the official
-   Realtek driver.
+	Parts of this driver are based on the GPL part of the official
+	Realtek driver.

-   Parts of this driver are based on the rtl8180 driver skeleton
-   from Patric Schenke & Andres Salomon.
+	Parts of this driver are based on the rtl8180 driver skeleton
+	from Patric Schenke & Andres Salomon.

-   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
+	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.

-   Parts of BB/RF code are derived from David Young rtl8180 netbsd driver.
+	Parts of BB/RF code are derived from David Young rtl8180 netbsd driver.

-   RSSI calc function from 'The Deuce'
+	RSSI calc function from 'The Deuce'

-   Some ideas borrowed from the 8139too.c driver included in linux kernel.
+	Some ideas borrowed from the 8139too.c driver included in linux kernel.

-   We (I?) want to thanks the Authors of those projecs and also the
-   Ndiswrapper's project Authors.
+	We (I?) want to thanks the Authors of those projecs and also the
+	Ndiswrapper's project Authors.

-   A big big thanks goes also to Realtek corp. for their help in my attempt to
-   add RTL8185 and RTL8225 support, and to David Young also.
+	A big big thanks goes also to Realtek corp. for their help in my attempt to
+	add RTL8185 and RTL8225 support, and to David Young also.

-   Power management interface routines.
-   Written by Mariusz Matuszek.
+	Power management interface routines.
+	Written by Mariusz Matuszek.
 */

 #undef RX_DONT_PASS_UL
@@ -62,8 +62,8 @@ static struct pci_device_id rtl8180_pci_id_tbl[]
__devinitdata = {


 static char ifname[IFNAMSIZ] = "wlan%d";
-static int hwseqnum = 0;
-static int hwwep = 0;
+hwseqnum = 0;
+hwwep = 0;
 static int channels = 0x3fff;

 MODULE_LICENSE("GPL");
@@ -210,7 +210,7 @@ static struct net_device_stats
*rtl8180_stats(struct net_device *dev);
 void rtl8180_commit(struct net_device *dev);
 void rtl8180_start_tx_beacon(struct net_device *dev);

-static struct proc_dir_entry *rtl8180_proc = NULL;
+proc_dir_entry *rtl8180_proc = NULL;

 static int proc_get_registers(char *page, char **start,
 			  off_t offset, int count,
@@ -374,8 +374,8 @@ void rtl8180_proc_init_one(struct net_device *dev)
 }

 /*
-  FIXME: check if we can use some standard already-existent
-  data type+functions in kernel
+	FIXME: check if we can use some standard already-existent
+	data type+functions in kernel
 */

 short buffer_add(struct buffer **buffer, u32 *buf, dma_addr_t dma,
@@ -438,8 +438,7 @@ void buffer_free(struct net_device *dev, struct
buffer **buffer, int len, short
 		}
 		kfree(tmp);
 		tmp = next;
-	}
-	while (next != *buffer);
+	}	while (next != *buffer);

 	*buffer = NULL;
 }
@@ -1653,7 +1652,6 @@ void rtl8180_rx(struct net_device *dev)
 			}
 			/* support for prism header has been originally added by Christian */
 			if (priv->prism_hdr && priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
-				
 			} else {
 				priv->rx_skb = dev_alloc_skb(len+2);
 				if (!priv->rx_skb)
@@ -1765,7 +1763,7 @@ void rtl8180_data_hard_resume(struct net_device *dev)
 	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
 }

-/*
+/*
  * This function TX data frames when the ieee80211 stack requires this.
  * It checks also if we need to stop the ieee tx queue, eventually do it
  */
@@ -1809,7 +1807,7 @@ rate) {
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 }

-/*
+/*
  * This is a rough attempt to TX a frame
  * This is called by the ieee 80211 stack to TX management frames.
  * If the ring is full packet are dropped (for data frame the queue
@@ -1915,7 +1913,7 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 	}
 }

-/*
+/*
  * This function do the real dirty work: it enqueues a TX command
  * descriptor in the ring buffer, copyes the frame in a TX buffer
  * and kicks the NIC to ensure it does the DMA transfer.
@@ -2183,7 +2181,7 @@ short rtl8180_tx(struct net_device *dev, u8*
txbuf, int len, int priority,
 			priv->txhpbufstail = buflist;
 			break;
 		case BEACON_PRIORITY:
-			/*
+			/*
 			 * The HW seems to be happy with the 1st
 			 * descriptor filled and the 2nd empty...
 			 * So always update descriptor 1 and never
@@ -2303,13 +2301,13 @@ void rtl8180_hw_sleep(struct net_device *dev,
u32 th, u32 tl)

 	spin_lock_irqsave(&priv->ps_lock, flags);

-	/*
+	/*
 	 * Writing HW register with 0 equals to disable
 	 * the timer, that is not really what we want
 	 */
 	tl -= MSECS(4+16+7);

-	/*
+	/*
 	 * If the interval in witch we are requested to sleep is too
 	 * short then give up and remain awake
 	 */
@@ -2327,7 +2325,7 @@ void rtl8180_hw_sleep(struct net_device *dev,
u32 th, u32 tl)

 		queue_delayed_work(priv->ieee80211->wq,
&priv->ieee80211->hw_wakeup_wq, tmp); /* as tl may be less than rb */
 	}
-	/*
+	/*
 	 * If we suspect the TimerInt is gone beyond tl
 	 * while setting it, then give up
 	 */
@@ -2472,17 +2470,17 @@ void watch_dog_adaptive(unsigned long data)
 }

 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},		/* FCC */
-	{{1,2,3,4,5,6,7,8,9,10,11},11},					/* IC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/*
Spain. Change to ETSI. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/*
France. Change to ETSI. */
-	{{14,36,40,44,48,52,56,60,64},9},				/* MKK */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14, 36,40,44,48,52,56,60,64},22},/* MKK1 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,34,38,42,46},17},		/* For 11a , TELEC */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},  /* For Global Domain.
1-11:active scan, 12-14 passive scan. //+YJ, 080626 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11
active scan, ch12~13 passive //lzm add 080826 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60,
64}, 19},		/* FCC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},					/* IC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56,
60, 4}, 21},	/* ETSI */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56,
60, 64}, 21},	/* Spain. Change to ETSI. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56,
60, 64}, 21},	/* France. Change to ETSI. */
+	{{14, 36, 40, 44, 48, 52, 56, 60, 64}, 9},				/* MKK */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52,
56, 60, 64}, 22},/* MKK1 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56,
60, 64}, 21},	/* Israel. */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 34, 38, 42, 46},
17},		/* For 11a , TELEC */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14},  /* For
Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626 */
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13} /* world wide 13:
ch1~ch11 active scan, ch12~13 passive //lzm add 080826 */
 };

 static void rtl8180_set_channel_map(u8 channel_plan, struct
ieee80211_device *ieee)
@@ -3167,7 +3165,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 	netif_start_queue(dev);
 }

-/*
+/*
  * This configures registers for beacon tx and enables it via
  * rtl8180_beacon_tx_enable(). rtl8180_beacon_tx_disable() might
  * be used to stop beacon transmission
@@ -3727,7 +3725,7 @@ static int __init rtl8180_pci_module_init(void)
 	DMESG("Wireless extensions version %d", WIRELESS_EXT);
 	rtl8180_proc_module_init();

-      if (pci_register_driver(&rtl8180_pci_driver)) {
+	if (pci_register_driver(&rtl8180_pci_driver)) {
 		DMESG("No device found");
 		return -ENODEV;
 	}
@@ -3834,7 +3832,7 @@ void rtl8180_tx_isr(struct net_device *dev, int
pri, short error)
 			return;
 		}

-	/*
+	/*
 	 * We check all the descriptors between the head and the nic,
 	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
@@ -3872,7 +3870,7 @@ void rtl8180_tx_isr(struct net_device *dev, int
pri, short error)
 			head += 8;
 	}

-	/*
+	/*
 	 * The head has been moved to the last certainly TXed
 	 * (or at least processed by the nic) packet.
 	 * The driver take forcefully owning of all these packets
@@ -4094,7 +4092,7 @@ void GPIOChangeRFWorkItemCallBack(struct
work_struct *work)
 	char *argv[3];
 	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
 	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
-	static int readf_count = 0;
+	int readf_count = 0;

 	if (readf_count % 10 == 0)
 		priv->PowerProfile = read_acadapter_file("/proc/acpi/ac_adapter/AC0/state");
-- 
1.7.2.1
