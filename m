Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0D0JoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:44:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38425 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0D0JoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qmq7xT4/PRvFcz7NtmRf8b9NvJtsXzHiW06Egg/WS0UiecUMWmDoTcv4EsgWonx+Vg
         wuF4md2K9aAIOl/dt9NfXqveZVXIf61D2o3ok3qY7csRwcxyqC2DEY5uaP+FpdyQvOql
         7d/O3vzCZMwKybF0Lt490zYjxuj9QST1JYWDI=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, sven.eckelmann@gmx.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: batman-adv: fixed comments to maintain 80 char limit
Date: Tue, 27 Apr 2010 17:44:09 +0800
Message-Id: <1272361449-15416-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches types.h to make sure the comments adhere to the 80 char limit and
make checkpatch.pl happy

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/batman-adv/types.h |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/batman-adv/types.h b/drivers/staging/batman-adv/types.h
index dec1b54..7d4768a 100644
--- a/drivers/staging/batman-adv/types.h
+++ b/drivers/staging/batman-adv/types.h
@@ -46,7 +46,7 @@ struct batman_if {
 
 };
 
-struct orig_node {               /* structure for orig_list maintaining nodes of mesh */
+struct orig_node { /* structure for orig_list maintaining nodes of mesh */
 	uint8_t orig[ETH_ALEN];
 	struct neigh_node *router;
 	struct batman_if *batman_if;
@@ -54,15 +54,18 @@ struct orig_node {               /* structure for orig_list maintaining nodes of
 	uint8_t *bcast_own_sum;
 	uint8_t tq_own;
 	int tq_asym_penalty;
-	unsigned long last_valid;        /* when last packet from this node was received */
-/*	uint8_t  gwflags;      * flags related to gateway functions: gateway class */
+	unsigned long last_valid; /* when last packet from this node was
+				   * received */
+/*	uint8_t  gwflags;  * flags related to gateway functions:
+			   * gateway class */
 	uint8_t  flags;    		/* for now only VIS_SERVER flag. */
 	unsigned char *hna_buff;
 	int16_t  hna_buff_len;
 	uint16_t last_real_seqno;   /* last and best known squence number */
 	uint8_t last_ttl;         /* ttl of last received packet */
 	TYPE_OF_WORD bcast_bits[NUM_WORDS];
-	uint16_t last_bcast_seqno;  /* last broadcast sequence number received by this host */
+	uint16_t last_bcast_seqno;  /* last broadcast sequence number received
+				     * by this host */
 	struct list_head neigh_list;
 };
 
@@ -74,7 +77,8 @@ struct neigh_node {
 	uint8_t tq_index;
 	uint8_t tq_avg;
 	uint8_t last_ttl;
-	unsigned long last_valid;            /* when last packet via this neighbor was received */
+	unsigned long last_valid; /* when last packet via this neighbor was
+				   * received */
 	TYPE_OF_WORD real_bits[NUM_WORDS];
 	struct orig_node *orig_node;
 	struct batman_if *if_incoming;
@@ -108,7 +112,8 @@ struct hna_global_entry {
 	struct orig_node *orig_node;
 };
 
-struct forw_packet {               /* structure for forw_list maintaining packets to be send/forwarded */
+struct forw_packet { /* structure for forw_list maintaining packets to be
+		      * send/forwarded */
 	struct hlist_node list;
 	unsigned long send_time;
 	uint8_t own;
-- 
1.7.0.5

