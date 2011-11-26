Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1KZUUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:20:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab1KZUT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:19:58 -0500
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Date: Sun, 27 Nov 2011 07:17:41 +1100
Subject: [PATCH 4/4] twl4030-irq: fix typo
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>
Message-ID: <20111126201741.16080.59032.stgit@notabene.brown>
In-Reply-To: <20111126201334.16080.85045.stgit@notabene.brown>
References: <20111126201334.16080.85045.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

overwriten -> overwritten

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/mfd/twl4030-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 3ac7216..b69bb51 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -492,7 +492,7 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 			u8	bytes[4];
 		} imr;
 
-		/* byte[0] gets overwriten as we write ... */
+		/* byte[0] gets overwritten as we write ... */
 		imr.word = cpu_to_le32(agent->imr << 8);
 		agent->imr_change_pending = false;
 


