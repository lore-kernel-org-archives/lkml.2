Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1GJPiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:38:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58949 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1GJPg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:28 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 06/10] staging: et131x: Make static some local functions in et1310_rx.c
Date: Sun, 10 Jul 2011 16:35:31 +0100
Message-Id: <1310312135-28407-7-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index e5bafc8..926ea66 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -732,7 +732,7 @@ void et131x_set_rx_dma_timer(struct et131x_adapter *etdev)
  * @etdev: pointer to our adapter
  * @rfd: pointer to the RFD
  */
-void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
+static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 {
 	struct rx_ring *rx_local = &etdev->rx_ring;
 	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
@@ -872,7 +872,7 @@ void et131x_rx_dma_enable(struct et131x_adapter *etdev)
  * the packet to it, puts the RFD in the RecvPendList, and also returns
  * the pointer to the RFD.
  */
-struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
+static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 {
 	struct rx_ring *rx_local = &etdev->rx_ring;
 	struct rx_status_block *status;
-- 
1.7.4.4

