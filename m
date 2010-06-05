Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab0FEOMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:12:54 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:5147 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933466Ab0FEOMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:12:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJPAA74CUw6B9wNPGdsb2JhbACHb5ZlDAEBAQE1LbAXjTGFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="82293889"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 09/13] staging: rtl8192u: fix checkpatch.pl issues to line 800 Fixed most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 800
Date: Sat,  5 Jun 2010 22:12:33 +0800
Message-Id: <1275747158-31375-10-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275747158-31375-9-git-send-email-mike.kernel@gilksonline.com>
References: <1275747158-31375-1-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-2-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-3-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-4-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-5-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-6-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-7-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-8-git-send-email-mike.kernel@gilksonline.com>
 <1275747158-31375-9-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  186 ++++++++++++++------------------
 1 files changed, 83 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 09f5747..26f671f 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -517,72 +517,58 @@ static int proc_get_registers(char *page, char **start,
 			  int *eof, void *data)
 {
 	struct net_device *dev = data;
-//	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
+	/* struct r8192_priv *priv =
+	 *(struct r8192_priv *)ieee80211_priv(dev);
+	 */
 
 	int len = 0;
-	int i,n;
+	int i, n;
 
-	int max=0xff;
+	int max = 0xff;
 
 	/* This dump the current register page */
 len += snprintf(page + len, count - len,
 			"\n####################page 0##################\n ");
 
-	for(n=0;n<=max;)
-	{
-		//printk( "\nD: %2x> ", n);
-		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
-
-		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(dev,0x000|n));
+	for (n = 0; n <= max; ) {
+		/* printk( "\nD: %2x> ", n); */
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", n);
 
-		//	printk("%2x ",read_nic_byte(dev,n));
+		for (i = 0; i < 16 && n <= max; i++, n++)
+			len += snprintf(page + len, count - len, "%2x ",
+						read_nic_byte(dev, 0x000|n));
+			/* printk("%2x ",read_nic_byte(dev,n)); */
 	}
 len += snprintf(page + len, count - len,
 			"\n####################page 1##################\n ");
-	for(n=0;n<=max;)
-	{
-		//printk( "\nD: %2x> ", n);
-		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
-
-		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(dev,0x100|n));
+	for (n = 0; n <= max; ) {
+		/* printk( "\nD: %2x> ", n); */
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", n);
 
-		//      printk("%2x ",read_nic_byte(dev,n));
+		for (i = 0; i < 16 && n <= max; i++, n++)
+			len += snprintf(page + len, count - len, "%2x ",
+						read_nic_byte(dev, 0x100|n));
+			/* printk("%2x ",read_nic_byte(dev,n)); */
 	}
 len += snprintf(page + len, count - len,
 			"\n####################page 3##################\n ");
-	for(n=0;n<=max;)
-	{
-		//printk( "\nD: %2x> ", n);
-		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
-
-		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(dev,0x300|n));
+	for (n = 0; n <= max; ) {
+		/* printk( "\nD: %2x> ", n); */
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", n);
 
-		//      printk("%2x ",read_nic_byte(dev,n));
+		for (i = 0; i < 16 && n <= max; i++, n++)
+			len += snprintf(page + len, count - len, "%2x ",
+						read_nic_byte(dev, 0x300|n));
+			/* printk("%2x ",read_nic_byte(dev,n)); */
 	}
 
-
-	len += snprintf(page + len, count - len,"\n");
+	len += snprintf(page + len, count - len, "\n");
 	*eof = 1;
 	return len;
-
 }
 
-
-
-
-
-static int proc_get_stats_tx(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_tx(char *page, char **start, off_t offset, int count,
+							  int *eof, void *data)
 {
 	struct net_device *dev = data;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
@@ -602,23 +588,23 @@ static int proc_get_stats_tx(char *page, char **start,
 		"TX MANAGE priority error int: %lu\n"
 		"TX BEACON priority ok int: %lu\n"
 		"TX BEACON priority error int: %lu\n"
-//		"TX high priority ok int: %lu\n"
-//		"TX high priority failed error int: %lu\n"
+		/* "TX high priority ok int: %lu\n" */
+		/* "TX high priority failed error int: %lu\n" */
 		"TX queue resume: %lu\n"
 		"TX queue stopped?: %d\n"
 		"TX fifo overflow: %lu\n"
-//		"TX beacon: %lu\n"
+		/* "TX beacon: %lu\n" */
 		"TX VI queue: %d\n"
 		"TX VO queue: %d\n"
 		"TX BE queue: %d\n"
 		"TX BK queue: %d\n"
-//		"TX HW queue: %d\n"
+		/* "TX HW queue: %d\n" */
 		"TX VI dropped: %lu\n"
 		"TX VO dropped: %lu\n"
 		"TX BE dropped: %lu\n"
 		"TX BK dropped: %lu\n"
 		"TX total data packets %lu\n",
-//		"TX beacon aborted: %lu\n",
+		/* "TX beacon aborted: %lu\n", */
 		priv->stats.txviokint,
 		priv->stats.txvierr,
 		priv->stats.txvookint,
@@ -631,23 +617,23 @@ static int proc_get_stats_tx(char *page, char **start,
 		priv->stats.txmanageerr,
 		priv->stats.txbeaconokint,
 		priv->stats.txbeaconerr,
-//		priv->stats.txhpokint,
-//		priv->stats.txhperr,
+		/* priv->stats.txhpokint, */
+		/* priv->stats.txhperr, */
 		priv->stats.txresumed,
 		netif_queue_stopped(dev),
 		priv->stats.txoverflow,
-//		priv->stats.txbeacon,
+		/* priv->stats.txbeacon, */
 		atomic_read(&(priv->tx_pending[VI_PRIORITY])),
 		atomic_read(&(priv->tx_pending[VO_PRIORITY])),
 		atomic_read(&(priv->tx_pending[BE_PRIORITY])),
 		atomic_read(&(priv->tx_pending[BK_PRIORITY])),
-//		read_nic_byte(dev, TXFIFOCOUNT),
+		/* read_nic_byte(dev, TXFIFOCOUNT), */
 		priv->stats.txvidrop,
 		priv->stats.txvodrop,
 		priv->stats.txbedrop,
 		priv->stats.txbkdrop,
 		priv->stats.txdatapkt
-//		priv->stats.txbeaconerr
+		/* priv->stats.txbeaconerr */
 		);
 
 	*eof = 1;
@@ -656,9 +642,8 @@ static int proc_get_stats_tx(char *page, char **start,
 
 
 
-static int proc_get_stats_rx(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_rx(char *page, char **start, off_t offset, int count,
+							int *eof, void *data)
 {
 	struct net_device *dev = data;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
@@ -676,13 +661,14 @@ static int proc_get_stats_rx(char *page, char **start,
 	*eof = 1;
 	return len;
 }
+
 void rtl8192_proc_module_init(void)
 {
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem");
-	rtl8192_proc=create_proc_entry(RTL819xU_MODULE_NAME, S_IFDIR, init_net.proc_net);
+	rtl8192_proc = create_proc_entry(RTL819xU_MODULE_NAME, S_IFDIR,
+							init_net.proc_net);
 }
 
-
 void rtl8192_proc_module_remove(void)
 {
 	remove_proc_entry(RTL819xU_MODULE_NAME, init_net.proc_net);
@@ -695,21 +681,20 @@ void rtl8192_proc_remove_one(struct net_device *dev)
 
 
 	if (priv->dir_dev) {
-	//	remove_proc_entry("stats-hw", priv->dir_dev);
+		/* remove_proc_entry("stats-hw", priv->dir_dev); */
 		remove_proc_entry("stats-tx", priv->dir_dev);
 		remove_proc_entry("stats-rx", priv->dir_dev);
-	//	remove_proc_entry("stats-ieee", priv->dir_dev);
+		/* remove_proc_entry("stats-ieee", priv->dir_dev); */
 		remove_proc_entry("stats-ap", priv->dir_dev);
 		remove_proc_entry("registers", priv->dir_dev);
-	//	remove_proc_entry("cck-registers",priv->dir_dev);
-	//	remove_proc_entry("ofdm-registers",priv->dir_dev);
-		//remove_proc_entry(dev->name, rtl8192_proc);
+		/* remove_proc_entry("cck-registers",priv->dir_dev); */
+		/* remove_proc_entry("ofdm-registers",priv->dir_dev); */
+		/* remove_proc_entry(dev->name, rtl8192_proc); */
 		remove_proc_entry("wlan0", rtl8192_proc);
 		priv->dir_dev = NULL;
 	}
 }
 
-
 void rtl8192_proc_init_one(struct net_device *dev)
 {
 	struct proc_dir_entry *e;
@@ -718,27 +703,24 @@ void rtl8192_proc_init_one(struct net_device *dev)
 					  S_IFDIR | S_IRUGO | S_IXUGO,
 					  rtl8192_proc);
 	if (!priv->dir_dev) {
-		RT_TRACE(COMP_ERR, "Unable to initialize /proc/net/rtl8192/%s\n",
-		      dev->name);
+		RT_TRACE(COMP_ERR, "Unable to initialize "
+					"/proc/net/rtl8192/%s\n", dev->name);
 		return;
 	}
 	e = create_proc_read_entry("stats-rx", S_IFREG | S_IRUGO,
 				   priv->dir_dev, proc_get_stats_rx, dev);
 
 	if (!e) {
-		RT_TRACE(COMP_ERR,"Unable to initialize "
-		      "/proc/net/rtl8192/%s/stats-rx\n",
-		      dev->name);
+		RT_TRACE(COMP_ERR, "Unable to initialize "
+				"/proc/net/rtl8192/%s/stats-rx\n", dev->name);
 	}
 
-
 	e = create_proc_read_entry("stats-tx", S_IFREG | S_IRUGO,
 				   priv->dir_dev, proc_get_stats_tx, dev);
 
 	if (!e) {
 		RT_TRACE(COMP_ERR, "Unable to initialize "
-		      "/proc/net/rtl8192/%s/stats-tx\n",
-		      dev->name);
+				"/proc/net/rtl8192/%s/stats-tx\n", dev->name);
 	}
 
 	e = create_proc_read_entry("stats-ap", S_IFREG | S_IRUGO,
@@ -746,43 +728,42 @@ void rtl8192_proc_init_one(struct net_device *dev)
 
 	if (!e) {
 		RT_TRACE(COMP_ERR, "Unable to initialize "
-		      "/proc/net/rtl8192/%s/stats-ap\n",
-		      dev->name);
+			      "/proc/net/rtl8192/%s/stats-ap\n", dev->name);
 	}
 
 	e = create_proc_read_entry("registers", S_IFREG | S_IRUGO,
 				   priv->dir_dev, proc_get_registers, dev);
 	if (!e) {
 		RT_TRACE(COMP_ERR, "Unable to initialize "
-		      "/proc/net/rtl8192/%s/registers\n",
-		      dev->name);
+		      "/proc/net/rtl8192/%s/registers\n", dev->name);
 	}
 }
 /****************************************************************************
-   -----------------------------MISC STUFF-------------------------
-*****************************************************************************/
+ *   -----------------------------MISC STUFF-------------------------
+ ****************************************************************************
+ */
 
 /* this is only for debugging */
 void print_buffer(u32 *buffer, int len)
 {
 	int i;
-	u8 *buf =(u8*)buffer;
+	u8 *buf = (u8 *)buffer;
 
-	printk("ASCII BUFFER DUMP (len: %x):\n",len);
+	printk("ASCII BUFFER DUMP (len: %x):\n", len);
 
-	for(i=0;i<len;i++)
-		printk("%c",buf[i]);
+	for (i = 0; i < len; i++)
+		printk("%c", buf[i]);
 
-	printk("\nBINARY BUFFER DUMP (len: %x):\n",len);
+	printk("\nBINARY BUFFER DUMP (len: %x):\n", len);
 
-	for(i=0;i<len;i++)
-		printk("%x",buf[i]);
+	for (i = 0; i < len; i++)
+		printk("%x", buf[i]);
 
 	printk("\n");
 }
 
-//short check_nic_enough_desc(struct net_device *dev, priority_t priority)
-short check_nic_enough_desc(struct net_device *dev,int queue_index)
+/* short check_nic_enough_desc(struct net_device *dev, priority_t priority) */
+short check_nic_enough_desc(struct net_device *dev, int queue_index)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int used = atomic_read(&priv->tx_pending[queue_index]);
@@ -793,19 +774,19 @@ short check_nic_enough_desc(struct net_device *dev,int queue_index)
 void tx_timeout(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//rtl8192_commit(dev);
+	/* rtl8192_commit(dev); */
 
 	schedule_work(&priv->reset_wq);
-	//DMESG("TXTIMEOUT");
+	/* DMESG("TXTIMEOUT"); */
 }
 
-
 /* this is only for debug */
 void dump_eprom(struct net_device *dev)
 {
 	int i;
-	for(i=0; i<63; i++)
-		RT_TRACE(COMP_EPROM, "EEPROM addr %x : %x", i, eprom_read(dev,i));
+	for (i = 0; i < 63; i++)
+		RT_TRACE(COMP_EPROM, "EEPROM addr %x : %x", i,
+							eprom_read(dev, i));
 }
 
 /* this is only for debug */
@@ -813,23 +794,22 @@ void rtl8192_dump_reg(struct net_device *dev)
 {
 	int i;
 	int n;
-	int max=0x1ff;
+	int max = 0x1ff;
 
 	RT_TRACE(COMP_PHY, "Dumping NIC register map");
 
-	for(n=0;n<=max;)
-	{
-		printk( "\nD: %2x> ", n);
-		for(i=0;i<16 && n<=max;i++,n++)
-			printk("%2x ",read_nic_byte(dev,n));
+	for (n = 0; n <= max; ) {
+		printk("\nD: %2x> ", n);
+		for (i = 0; i < 16 && n <= max; i++, n++)
+			printk("%2x ", read_nic_byte(dev, n));
 	}
 	printk("\n");
 }
 
 /****************************************************************************
-      ------------------------------HW STUFF---------------------------
-*****************************************************************************/
-
+ *    ------------------------------HW STUFF---------------------------
+ ****************************************************************************
+ */
 
 void rtl8192_set_mode(struct net_device *dev,int mode)
 {
-- 
1.6.3.3

