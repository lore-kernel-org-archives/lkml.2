Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552Ab1KJDdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:33:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935100Ab1KJDc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:24 2011
Message-Id: <20111109212724.427129661@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [237/262] ath9k_hw: Update AR9485 initvals to fix system hang issue
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 98fb2cc115b4ef1ea0a2d87a170c183bd395dd6c upstream.

This patch fixes system hang when resuming from S3 state
and lower rate sens failure issue.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -521,7 +521,7 @@ static const u32 ar9485_1_1_radio_postam
 	{0x000160ac, 0x24611800},
 	{0x000160b0, 0x03284f3e},
 	{0x0001610c, 0x00170000},
-	{0x00016140, 0x10804008},
+	{0x00016140, 0x50804008},
 };
 
 static const u32 ar9485_1_1_mac_postamble[][5] = {
@@ -603,7 +603,7 @@ static const u32 ar9485_1_1_radio_core[]
 
 static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1[][2] = {
 	/* Addr        allmodes */
-	{0x00018c00, 0x10052e5e},
+	{0x00018c00, 0x18052e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
@@ -776,7 +776,7 @@ static const u32 ar9485_modes_green_ob_d
 
 static const u32 ar9485_1_1_pcie_phy_clkreq_disable_L1[][2] = {
 	/* Addr        allmodes */
-	{0x00018c00, 0x10013e5e},
+	{0x00018c00, 0x18013e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
@@ -882,7 +882,7 @@ static const u32 ar9485_fast_clock_1_1_b
 
 static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1[][2] = {
 	/* Addr        allmodes  */
-	{0x00018c00, 0x10012e5e},
+	{0x00018c00, 0x18012e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
@@ -1021,7 +1021,7 @@ static const u32 ar9485_common_rx_gain_1
 
 static const u32 ar9485_1_1_pcie_phy_clkreq_enable_L1[][2] = {
 	/* Addr        allmodes */
-	{0x00018c00, 0x10053e5e},
+	{0x00018c00, 0x18053e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };


