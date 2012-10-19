Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245Ab2JSEPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:15:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52871 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932126Ab2JSEPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:15:40 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 14/21] llc_if.h: Convert is_<foo>_ether_addr uses to eth_addr_<foo>
Date: Thu, 18 Oct 2012 21:14:58 -0700
Message-Id: <1df2628a6da807939ee0a30c332bf0ec0a596a22.1350618011.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350618006.git.joe@perches.com>
References: <cover.1350618006.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the old ether_addr tests to eth_addr_<foo>.
Adds api consistency.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/llc_if.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/llc_if.h b/include/net/llc_if.h
index b595a00..cce2942 100644
--- a/include/net/llc_if.h
+++ b/include/net/llc_if.h
@@ -71,12 +71,12 @@
  */
 static inline int llc_mac_null(const u8 *mac)
 {
-	return is_zero_ether_addr(mac);
+	return eth_addr_zero(mac);
 }
 
 static inline int llc_mac_multicast(const u8 *mac)
 {
-	return is_multicast_ether_addr(mac);
+	return eth_addr_multicast(mac);
 }
 /**
  *	llc_mac_match - determines if two mac addresses are the same
-- 
1.7.8.111.gad25c.dirty

