Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1FICvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:51:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41179 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1FICvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NBvb0pnpBoj23MEhEMFYQS7Olh4IKzY+ADSEsCpwVq3ojXvYy6oaJu5MxjyawWniOE
         xiUPAIWBumGB+vmcsUp9DoaYbBdFSlMXZmpKPeanVWdPlCeu3CEHuAreEXvZr18BXjJB
         COP70zX+vdHLgDtvZrqrFIZd4HXvbE5nlncPw=
From: Weiping Pan <panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net-next 2/2] bonding: delete unused arp_mon_pt
Date: Thu,  9 Jun 2011 10:51:34 +0800
Message-Id: <c89d6db3517fc799050d40b0e2858d2152b5a68e.1307587586.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1307587586.git.panweiping3@gmail.com>
References: <cover.1307587586.git.panweiping3@gmail.com>
In-Reply-To: <cover.1307587586.git.panweiping3@gmail.com>
References: <cover.1307587586.git.panweiping3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all received packets are handled by bond_handle_frame,
arp_mon_pt isn't used any more.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bonding.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index ea1d005..382903f 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -240,7 +240,6 @@ struct bonding {
 	struct   bond_params params;
 	struct   list_head vlan_list;
 	struct   vlan_group *vlgrp;
-	struct   packet_type arp_mon_pt;
 	struct   workqueue_struct *wq;
 	struct   delayed_work mii_work;
 	struct   delayed_work arp_work;
-- 
1.7.4.4

