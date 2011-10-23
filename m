Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1JWJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:26:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab1JWJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:23 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 04/12] staging: et131x: Remove unused rx_ring.recv_packet_pool
Date: Sun, 23 Oct 2011 10:22:46 +0100
Message-Id: <1319361774-3148-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
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

