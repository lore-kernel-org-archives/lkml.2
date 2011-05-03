Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1ECUGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:06:38 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:44333 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1ECUGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:06:36 -0400
Subject: [PATCH 09/16] hpsa: increase time to wait for board reset
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:59:31 -0500
Message-ID: <20110503195931.5478.71892.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7a4ee73..b1412a7 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -155,7 +155,7 @@ struct ctlr_info {
  * HPSA_BOARD_READY_ITERATIONS are derived from those.
  */
 #define HPSA_BOARD_READY_WAIT_SECS (120)
-#define HPSA_BOARD_NOT_READY_WAIT_SECS (10)
+#define HPSA_BOARD_NOT_READY_WAIT_SECS (100)
 #define HPSA_BOARD_READY_POLL_INTERVAL_MSECS (100)
 #define HPSA_BOARD_READY_POLL_INTERVAL \
 	((HPSA_BOARD_READY_POLL_INTERVAL_MSECS * HZ) / 1000)

