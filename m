Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1ECTxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:35 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27634 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1ECTxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:32 -0400
Subject: [PATCH 08/16] cciss: increase time to wait for board reset to start
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:31 -0500
Message-ID: <20110503195331.5154.51623.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 9b49439..21ec628 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -200,7 +200,7 @@ struct ctlr_info
  * the above.
  */
 #define CCISS_BOARD_READY_WAIT_SECS (120)
-#define CCISS_BOARD_NOT_READY_WAIT_SECS (10)
+#define CCISS_BOARD_NOT_READY_WAIT_SECS (100)
 #define CCISS_BOARD_READY_POLL_INTERVAL_MSECS (100)
 #define CCISS_BOARD_READY_ITERATIONS \
 	((CCISS_BOARD_READY_WAIT_SECS * 1000) / \

