Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1CZBTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:19:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45090 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755598Ab1CZBSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/VahUxBjjVbvetYxOb+85bt8O0Q6Pd24kX2V2Osw
	tK6z0IWbRu4I6t
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 05/27] staging/crystalhd: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:54 +0100
Message-Id: <1301102296-15565-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a common spelling mistake in
drivers/staging/crystalhd.

WRONG -> RIGHT
accomodate  -> accommodate

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/crystalhd/crystalhd_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 13a514d..0faa284 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -2367,7 +2367,7 @@ enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *hw)
 	BCMLOG(BCMLOG_INFO, "clock is moving to %d with n %d with vco_mg %d\n",
 	       hw->core_clock_mhz, n, vco_mg);
 
-	/* Change the DRAM refresh rate to accomodate the new frequency */
+	/* Change the DRAM refresh rate to accommodate the new frequency */
 	/* refresh reg = ((refresh_rate * clock_rate)/16) - 1; rounding up*/
 	refresh_reg = (7 * hw->core_clock_mhz / 16);
 	bc_dec_reg_wr(hw->adp, SDRAM_REF_PARAM, ((1 << 12) | refresh_reg));
-- 
1.7.3.4

