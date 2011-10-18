Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab1JRQKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:10:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34731 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab1JRQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:10:25 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 23/26] staging: et131x: Remove unused rx_ring.recv_packet_pool
Date: Tue, 18 Oct 2011 17:07:56 +0100
Message-Id: <1318954079-16666-24-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tx_ring.recv_packet_pool is unused, even in the original driver code.
Removed.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 9383c5c..cf6f7a2 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -337,8 +337,6 @@ struct rx_ring {
 
 	bool unfinished_receives;
 
-	struct list_head recv_packet_pool;
-
 	/* lookaside lists */
 	struct kmem_cache *recv_lookaside;
 };
-- 
1.7.6.4

