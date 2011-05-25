Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1EYKEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:04:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62960 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1EYKEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TvxqvioU0eurQR2nNoSiPX3biO/S3HPL9/hW3Zl1a6nKafSyojif1h+RVG07K6uaOk
         oFcgXTT8ZAWq1378uLuv1ehvS+1DQH6YtnWde7A1+6It0AT9Pf7Uj1E9bQ8KA4n85U3G
         39GahZX2k1T+YduvfhODUJUTOzPEHShLMoepw=
From: Weiping Pan <panweiping3@gmail.com>
To: jpirko@redhat.com
Cc: Weiping Pan <panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bonding:update xmit_hash_policy description
Date: Wed, 25 May 2011 18:05:04 +0800
Message-Id: <1306317904-18740-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xmit_hash_policy supports layer2+3 now,
and both balance-xor and 802.3ad use xmit_hash_policy.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 088fd84..d1f5606 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -147,8 +147,7 @@ MODULE_PARM_DESC(lacp_rate, "LACPDU tx rate to request from 802.3ad partner "
 module_param(ad_select, charp, 0);
 MODULE_PARM_DESC(ad_select, "803.ad aggregation selection logic: stable (0, default), bandwidth (1), count (2)");
 module_param(xmit_hash_policy, charp, 0);
-MODULE_PARM_DESC(xmit_hash_policy, "XOR hashing method: 0 for layer 2 (default)"
-				   ", 1 for layer 3+4");
+MODULE_PARM_DESC(xmit_hash_policy, "balance-xor and 802.3ad hashing method: 0 for layer 2 (default), 1 for layer 3+4, 2 for layer 2+3");
 module_param(arp_interval, int, 0);
 MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
 module_param_array(arp_ip_target, charp, NULL, 0);
-- 
1.7.4.4

