Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0DDAkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 20:40:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51039 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0DDAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 20:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=OgyZV0OxgcTN3/IZMuSdq5uvyQUrcVhDB040Tjau842Ye8xKNtMwXeidZlW2jU8R/a
         6iALTvA1Qw7fOP3nqT5icVjmMI5JP1+7G/pOPE/Qwzs+noSzFhQ6rNApDlz/5Jfhgvo8
         EcxhkvO6lGCNYLTjBH9epZAP/zOBJBSd3UWFE=
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, sdietrich@novell.com, linus.luessing@web.de,
       sven.eckelmann@gmx.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Luis de Bethencourt <luisbg@ubuntu.com>
Subject: [PATCH 4/4] Staging: batman-adv: fix whitespace style issues
Date: Sun,  4 Apr 2010 01:40:25 +0100
Message-Id: <1270341625-28764-1-git-send-email-luisbg@ubuntu.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <batman-adv>
References: <batman-adv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the 32 unnecessary whitespaces before a quoted
newline that the batman-adv files had.

Signed-off-by: Luis de Bethencourt <luisbg@ubuntu.com>
---
 drivers/staging/batman-adv/device.c            |    4 ++--
 drivers/staging/batman-adv/main.c              |    2 +-
 drivers/staging/batman-adv/originator.c        |    4 ++--
 drivers/staging/batman-adv/proc.c              |   18 +++++++++---------
 drivers/staging/batman-adv/routing.c           |   18 +++++++++---------
 drivers/staging/batman-adv/send.c              |    4 ++--
 drivers/staging/batman-adv/translation-table.c |   14 +++++++-------
 7 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/batman-adv/device.c b/drivers/staging/batman-adv/device.c
index e7f4421..8e7ed30 100644
--- a/drivers/staging/batman-adv/device.c
+++ b/drivers/staging/batman-adv/device.c
@@ -67,7 +67,7 @@ int bat_device_setup(void)
 	batman_class = class_create(THIS_MODULE, "batman-adv");
 
 	if (IS_ERR(batman_class)) {
-		printk(KERN_ERR "batman-adv:Could not register class 'batman-adv' \n");
+		printk(KERN_ERR "batman-adv:Could not register class 'batman-adv'\n");
 		return 0;
 	}
 
@@ -110,7 +110,7 @@ int bat_device_open(struct inode *inode, struct file *file)
 	}
 
 	if (device_client_hash[i] != device_client) {
-		printk(KERN_ERR "batman-adv:Error - can't add another packet client: maximum number of clients reached \n");
+		printk(KERN_ERR "batman-adv:Error - can't add another packet client: maximum number of clients reached\n");
 		kfree(device_client);
 		return -EXFULL;
 	}
diff --git a/drivers/staging/batman-adv/main.c b/drivers/staging/batman-adv/main.c
index 2e0b482..17df9dc 100644
--- a/drivers/staging/batman-adv/main.c
+++ b/drivers/staging/batman-adv/main.c
@@ -119,7 +119,7 @@ int init_module(void)
 	register_netdevice_notifier(&hard_if_notifier);
 	dev_add_pack(&batman_adv_packet_type);
 
-	printk(KERN_INFO "batman-adv:B.A.T.M.A.N. advanced %s%s (compatibility version %i) loaded \n",
+	printk(KERN_INFO "batman-adv:B.A.T.M.A.N. advanced %s%s (compatibility version %i) loaded\n",
 		  SOURCE_VERSION, REVISION_VERSION_STR, COMPAT_VERSION);
 
 	return 0;
diff --git a/drivers/staging/batman-adv/originator.c b/drivers/staging/batman-adv/originator.c
index 29c2411..eed47ca 100644
--- a/drivers/staging/batman-adv/originator.c
+++ b/drivers/staging/batman-adv/originator.c
@@ -126,7 +126,7 @@ struct orig_node *get_orig_node(uint8_t *addr)
 	if (orig_node != NULL)
 		return orig_node;
 
-	bat_dbg(DBG_BATMAN, "Creating new originator: %pM \n", addr);
+	bat_dbg(DBG_BATMAN, "Creating new originator: %pM\n", addr);
 
 	orig_node = kzalloc(sizeof(struct orig_node), GFP_ATOMIC);
 	if (!orig_node)
@@ -158,7 +158,7 @@ struct orig_node *get_orig_node(uint8_t *addr)
 
 		if (swaphash == NULL)
 			printk(KERN_ERR
-			       "batman-adv:Couldn't resize orig hash table \n");
+			       "batman-adv:Couldn't resize orig hash table\n");
 		else
 			orig_hash = swaphash;
 	}
diff --git a/drivers/staging/batman-adv/proc.c b/drivers/staging/batman-adv/proc.c
index 7de60e8..1c51a05 100644
--- a/drivers/staging/batman-adv/proc.c
+++ b/drivers/staging/batman-adv/proc.c
@@ -41,7 +41,7 @@ static int proc_interfaces_read(struct seq_file *seq, void *offset)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(batman_if, &if_list, list) {
-		seq_printf(seq, "[%8s] %s %s \n",
+		seq_printf(seq, "[%8s] %s %s\n",
 			   (batman_if->if_active == IF_ACTIVE ?
 			    "active" : "inactive"),
 			   batman_if->dev,
@@ -188,18 +188,18 @@ static int proc_originators_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it\n");
 		goto end;
 	}
 
 	if (((struct batman_if *)if_list.next)->if_active != IF_ACTIVE) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - primary interface not active \n");
+		seq_printf(seq, "BATMAN disabled - primary interface not active\n");
 		goto end;
 	}
 
 	seq_printf(seq,
-		   "  %-14s (%s/%i) %17s [%10s]: %20s ... [B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s] \n",
+		   "  %-14s (%s/%i) %17s [%10s]: %20s ... [B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s]\n",
 		   "Originator", "#", TQ_MAX_VALUE, "Nexthop", "outgoingIF",
 		   "Potential nexthops", SOURCE_VERSION, REVISION_VERSION_STR,
 		   ((struct batman_if *)if_list.next)->dev,
@@ -240,7 +240,7 @@ static int proc_originators_read(struct seq_file *seq, void *offset)
 	spin_unlock_irqrestore(&orig_hash_lock, flags);
 
 	if (batman_count == 0)
-		seq_printf(seq, "No batman nodes in range ... \n");
+		seq_printf(seq, "No batman nodes in range ...\n");
 
 end:
 	return 0;
@@ -262,7 +262,7 @@ static int proc_transt_local_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it\n");
 		goto end;
 	}
 
@@ -294,7 +294,7 @@ static int proc_transt_global_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it\n");
 		goto end;
 	}
 	rcu_read_unlock();
@@ -350,9 +350,9 @@ static int proc_vis_srv_read(struct seq_file *seq, void *offset)
 {
 	int vis_server = atomic_read(&vis_mode);
 
-	seq_printf(seq, "[%c] client mode (server disabled) \n",
+	seq_printf(seq, "[%c] client mode (server disabled)\n",
 			(vis_server == VIS_TYPE_CLIENT_UPDATE) ? 'x' : ' ');
-	seq_printf(seq, "[%c] server mode (server enabled) \n",
+	seq_printf(seq, "[%c] server mode (server enabled)\n",
 			(vis_server == VIS_TYPE_SERVER_SYNC) ? 'x' : ' ');
 
 	return 0;
diff --git a/drivers/staging/batman-adv/routing.c b/drivers/staging/batman-adv/routing.c
index d89048b..feab689 100644
--- a/drivers/staging/batman-adv/routing.c
+++ b/drivers/staging/batman-adv/routing.c
@@ -212,7 +212,7 @@ static int isBidirectionalNeigh(struct orig_node *orig_node,
 			      orig_neigh_node->tq_asym_penalty) /
 			     (TQ_MAX_VALUE *	 TQ_MAX_VALUE));
 
-	bat_dbg(DBG_BATMAN, "bidirectional: orig = %-15pM neigh = %-15pM => own_bcast = %2i, real recv = %2i, local tq: %3i, asym_penalty: %3i, total tq: %3i \n",
+	bat_dbg(DBG_BATMAN, "bidirectional: orig = %-15pM neigh = %-15pM => own_bcast = %2i, real recv = %2i, local tq: %3i, asym_penalty: %3i, total tq: %3i\n",
 		orig_node->orig, orig_neigh_node->orig, total_count,
 		neigh_node->real_packet_count, orig_neigh_node->tq_own,
 		orig_neigh_node->tq_asym_penalty, batman_packet->tq);
@@ -234,7 +234,7 @@ static void update_orig(struct orig_node *orig_node, struct ethhdr *ethhdr,
 	struct neigh_node *neigh_node = NULL, *tmp_neigh_node = NULL;
 	int tmp_hna_buff_len;
 
-	bat_dbg(DBG_BATMAN, "update_originator(): Searching and updating originator entry of received packet \n");
+	bat_dbg(DBG_BATMAN, "update_originator(): Searching and updating originator entry of received packet\n");
 
 	list_for_each_entry(tmp_neigh_node, &orig_node->neigh_list, list) {
 		if (compare_orig(tmp_neigh_node->addr, ethhdr->h_source) &&
@@ -341,7 +341,7 @@ static char count_real_packets(struct ethhdr *ethhdr,
 	}
 
 	if (!is_duplicate) {
-		bat_dbg(DBG_BATMAN, "updating last_seqno: old %d, new %d \n",
+		bat_dbg(DBG_BATMAN, "updating last_seqno: old %d, new %d\n",
 			orig_node->last_real_seqno, batman_packet->seqno);
 		orig_node->last_real_seqno = batman_packet->seqno;
 	}
@@ -385,7 +385,7 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 	is_single_hop_neigh = (compare_orig(ethhdr->h_source,
 					    batman_packet->orig) ? 1 : 0);
 
-	bat_dbg(DBG_BATMAN, "Received BATMAN packet via NB: %pM, IF: %s [%s] (from OG: %pM, via prev OG: %pM, seqno %d, tq %d, TTL %d, V %d, IDF %d) \n",
+	bat_dbg(DBG_BATMAN, "Received BATMAN packet via NB: %pM, IF: %s [%s] (from OG: %pM, via prev OG: %pM, seqno %d, tq %d, TTL %d, V %d, IDF %d)\n",
 		ethhdr->h_source, if_incoming->dev, if_incoming->addr_str,
 		batman_packet->orig, batman_packet->prev_sender,
 		batman_packet->seqno, batman_packet->tq, batman_packet->ttl,
@@ -426,7 +426,7 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 	}
 
 	if (is_broadcast) {
-		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all packets with broadcast source addr (sender: %pM) \n", ethhdr->h_source);
+		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all packets with broadcast source addr (sender: %pM)\n", ethhdr->h_source);
 		return;
 	}
 
@@ -454,19 +454,19 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 				bit_packet_count(word);
 		}
 
-		bat_dbg(DBG_BATMAN, "Drop packet: originator packet from myself (via neighbor) \n");
+		bat_dbg(DBG_BATMAN, "Drop packet: originator packet from myself (via neighbor)\n");
 		return;
 	}
 
 	if (batman_packet->tq == 0) {
 		count_real_packets(ethhdr, batman_packet, if_incoming);
 
-		bat_dbg(DBG_BATMAN, "Drop packet: originator packet with tq equal 0 \n");
+		bat_dbg(DBG_BATMAN, "Drop packet: originator packet with tq equal 0\n");
 		return;
 	}
 
 	if (is_my_oldorig) {
-		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all rebroadcast echos (sender: %pM) \n", ethhdr->h_source);
+		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all rebroadcast echos (sender: %pM)\n", ethhdr->h_source);
 		return;
 	}
 
@@ -484,7 +484,7 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 	    !(compare_orig(batman_packet->orig, batman_packet->prev_sender)) &&
 	    (compare_orig(orig_node->router->addr,
 			  orig_node->router->orig_node->router->addr))) {
-		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all rebroadcast packets that may make me loop (sender: %pM) \n", ethhdr->h_source);
+		bat_dbg(DBG_BATMAN, "Drop packet: ignoring all rebroadcast packets that may make me loop (sender: %pM)\n", ethhdr->h_source);
 		return;
 	}
 
diff --git a/drivers/staging/batman-adv/send.c b/drivers/staging/batman-adv/send.c
index 2a9fac8..3a67222 100644
--- a/drivers/staging/batman-adv/send.c
+++ b/drivers/staging/batman-adv/send.c
@@ -297,7 +297,7 @@ void schedule_forward_packet(struct orig_node *orig_node,
 	unsigned long send_time;
 
 	if (batman_packet->ttl <= 1) {
-		bat_dbg(DBG_BATMAN, "ttl exceeded \n");
+		bat_dbg(DBG_BATMAN, "ttl exceeded\n");
 		return;
 	}
 
@@ -325,7 +325,7 @@ void schedule_forward_packet(struct orig_node *orig_node,
 	/* apply hop penalty */
 	batman_packet->tq = hop_penalty(batman_packet->tq);
 
-	bat_dbg(DBG_BATMAN, "Forwarding packet: tq_orig: %i, tq_avg: %i, tq_forw: %i, ttl_orig: %i, ttl_forw: %i \n",
+	bat_dbg(DBG_BATMAN, "Forwarding packet: tq_orig: %i, tq_avg: %i, tq_forw: %i, ttl_orig: %i, ttl_forw: %i\n",
 		in_tq, tq_avg, batman_packet->tq, in_ttl - 1,
 		batman_packet->ttl);
 
diff --git a/drivers/staging/batman-adv/translation-table.c b/drivers/staging/batman-adv/translation-table.c
index d56f665..f689f53 100644
--- a/drivers/staging/batman-adv/translation-table.c
+++ b/drivers/staging/batman-adv/translation-table.c
@@ -77,11 +77,11 @@ void hna_local_add(uint8_t *addr)
 	   MAC-flooding. */
 	if ((num_hna + 1 > (ETH_DATA_LEN - BAT_PACKET_LEN) / ETH_ALEN) ||
 	    (num_hna + 1 > 255)) {
-		bat_dbg(DBG_ROUTES, "Can't add new local hna entry (%pM): number of local hna entries exceeds packet size \n", addr);
+		bat_dbg(DBG_ROUTES, "Can't add new local hna entry (%pM): number of local hna entries exceeds packet size\n", addr);
 		return;
 	}
 
-	bat_dbg(DBG_ROUTES, "Creating new local hna entry: %pM \n",
+	bat_dbg(DBG_ROUTES, "Creating new local hna entry: %pM\n",
 		addr);
 
 	hna_local_entry = kmalloc(sizeof(struct hna_local_entry), GFP_ATOMIC);
@@ -108,7 +108,7 @@ void hna_local_add(uint8_t *addr)
 				       hna_local_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR "batman-adv:Couldn't resize local hna hash table \n");
+			printk(KERN_ERR "batman-adv:Couldn't resize local hna hash table\n");
 		else
 			hna_local_hash = swaphash;
 	}
@@ -197,7 +197,7 @@ static void _hna_local_del(void *data)
 static void hna_local_del(struct hna_local_entry *hna_local_entry,
 			  char *message)
 {
-	bat_dbg(DBG_ROUTES, "Deleting local hna entry (%pM): %s \n",
+	bat_dbg(DBG_ROUTES, "Deleting local hna entry (%pM): %s\n",
 		hna_local_entry->addr, message);
 
 	hash_remove(hna_local_hash, hna_local_entry->addr);
@@ -340,7 +340,7 @@ void hna_global_add_orig(struct orig_node *orig_node,
 				       hna_global_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR "batman-adv:Couldn't resize global hna hash table \n");
+			printk(KERN_ERR "batman-adv:Couldn't resize global hna hash table\n");
 		else
 			hna_global_hash = swaphash;
 	}
@@ -365,7 +365,7 @@ int hna_global_fill_buffer_text(unsigned char *buff, int buff_len)
 
 		bytes_written += snprintf(buff + bytes_written,
 					  (2 * ETH_STR_LEN) + 10,
-					  " * %02x:%02x:%02x:%02x:%02x:%02x via %02x:%02x:%02x:%02x:%02x:%02x \n",
+					  " * %02x:%02x:%02x:%02x:%02x:%02x via %02x:%02x:%02x:%02x:%02x:%02x\n",
 					  hna_global_entry->addr[0],
 					  hna_global_entry->addr[1],
 					  hna_global_entry->addr[2],
@@ -388,7 +388,7 @@ int hna_global_fill_buffer_text(unsigned char *buff, int buff_len)
 void _hna_global_del_orig(struct hna_global_entry *hna_global_entry,
 			  char *message)
 {
-	bat_dbg(DBG_ROUTES, "Deleting global hna entry %pM (via %pM): %s \n",
+	bat_dbg(DBG_ROUTES, "Deleting global hna entry %pM (via %pM): %s\n",
 		hna_global_entry->addr, hna_global_entry->orig_node->orig,
 		message);
 
-- 
1.6.3.3

