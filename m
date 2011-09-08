Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1IHKYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 06:24:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45644 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab1IHKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:24:20 -0400
Message-ID: <4E6897C8.4070602@gmail.com>
Date: Thu, 08 Sep 2011 18:24:08 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] CFQ: cleanup: fix comment for enum wl_prio_t
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc3.

The value of IDLE_WORKLOAD is 2. No negative value here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a33bd43..344efa3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -153,7 +153,7 @@ struct cfq_queue {
 
 /*
  * First index in the service_trees.
- * IDLE is handled separately, so it has negative index
+ * IDLE is handled separately.
  */
 enum wl_prio_t {
 	BE_WORKLOAD = 0,
-- 
1.7.1

