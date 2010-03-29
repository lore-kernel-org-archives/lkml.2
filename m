Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0C2RxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:53:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:57103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0C2RxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:53:04 -0400
From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/17] wireless: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:38 +0900
Message-Id: <1269885165-18617-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269885165-18617-1-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 17:52:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 7770649..4497479 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -23,6 +23,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include <net/mac80211.h>
 
 #include "common.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index 4c5395e..0cc7fd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
+#include <linux/gfp.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
-- 
1.6.4.2

