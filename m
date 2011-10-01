Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1JAKPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:15:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44948 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1JAKPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:38 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/8] staging: et131x: Remove TODO entry 'alloc_etherdev initilising memory with zero'
Date: Sat,  1 Oct 2011 11:14:10 +0100
Message-Id: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing this as I'm pretty sure its not true, and alloc_etherdev isn't provided by this driver anyway. Alternatively, its a badly written comment and I don't understand it.

This drivers use of alloc_etherdev() is within keeping with other net devices, so I'm happy.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 7e846b2..d24ef84 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -9,7 +9,6 @@ Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
-	- alloc_etherdev is initializing memory with zero?!?
 	- add_timer call in et131x_netdev.c is correct?
 	- Add power saving functionality (suspend, sleep, resume)
 	- Implement a few more kernel Parameter (set mac )
-- 
1.7.6.4

