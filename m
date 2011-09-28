Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1I1WuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1I1WuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.366481638@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [237/244] ath9k_hw: Fix Rx DMA stuck for AR9003 chips
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit e9f9530bb697f53dd620df290102359a3325bb23 upstream.

During the endurance testing, rx frames are not getting DMAd from
MAC whereas pcu rx frame counters are getting updated properly.
As per systems team input updated the initval to fix rx dma stuck
issue.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1516,7 +1516,7 @@ static const u32 ar9300_2p2_mac_core[][2
 	{0x00008258, 0x00000000},
 	{0x0000825c, 0x40000000},
 	{0x00008260, 0x00080922},
-	{0x00008264, 0x9bc00010},
+	{0x00008264, 0x9d400010},
 	{0x00008268, 0xffffffff},
 	{0x0000826c, 0x0000ffff},
 	{0x00008270, 0x00000000},


