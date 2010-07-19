Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966421Ab0GSSnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:43:23 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38396 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965703Ab0GSSk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:28 -0400
Subject: [PATCH 15/26] cciss: make cciss_put_controller_into_performant_mode
	as __devinit
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:56 -0500
Message-ID: <20100719184556.7908.12391.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: make cciss_put_controller_into_performant_mode as __devinit

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 10502a2..37bc091 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3816,8 +3816,7 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
-static void
-cciss_put_controller_into_performant_mode(ctlr_info_t *h)
+static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 {
 	int l = 0;
 	__u32 trans_support;

