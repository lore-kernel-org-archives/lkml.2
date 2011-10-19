Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1JSXDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:03:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab1JSXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:03:06 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: staging: et131x: Remove unused defines
Date: Thu, 20 Oct 2011 00:01:08 +0100
Message-Id: <1319065268-2863-18-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
References: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some defines are no longer referenced in the code, so removed them.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 1c11dfd..1efa27c 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -145,21 +145,14 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 /* MP_ADAPTER flags */
 #define fMP_ADAPTER_RECV_LOOKASIDE	0x00000004
 #define fMP_ADAPTER_INTERRUPT_IN_USE	0x00000008
-#define fMP_ADAPTER_SECONDARY		0x00000010
 
 /* MP_SHARED flags */
-#define fMP_ADAPTER_SHUTDOWN		0x00100000
 #define fMP_ADAPTER_LOWER_POWER		0x00200000
 
 #define fMP_ADAPTER_NON_RECOVER_ERROR	0x00800000
-#define fMP_ADAPTER_RESET_IN_PROGRESS	0x01000000
-#define fMP_ADAPTER_NO_CABLE		0x02000000
 #define fMP_ADAPTER_HARDWARE_ERROR	0x04000000
-#define fMP_ADAPTER_REMOVE_IN_PROGRESS	0x08000000
-#define fMP_ADAPTER_HALT_IN_PROGRESS	0x10000000
 
 #define fMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
-#define fMP_ADAPTER_NOT_READY_MASK	0x3ff00000
 
 /* Some offsets in PCI config space that are actually used. */
 #define ET1310_PCI_MAX_PYLD		0x4C
@@ -205,7 +198,6 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 
 #define NUM_PACKETS_HANDLED	256
 
-#define ALCATEL_BAD_STATUS	0xe47f0000
 #define ALCATEL_MULTICAST_PKT	0x01000000
 #define ALCATEL_BROADCAST_PKT	0x02000000
 
@@ -452,8 +444,6 @@ struct tx_ring {
  * Once the desired performance has been achieved, the optimal registry values
  * should be re-populated to these #defines:
  */
-#define NUM_TRAFFIC_CLASSES          1
-
 #define TX_ERROR_PERIOD             1000
 
 #define LO_MARK_PERCENT_FOR_PSR     15
@@ -4715,7 +4705,6 @@ void et131x_disable_interrupts(struct et131x_adapter *adapter)
 	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
 }
 
-
 /**
  * et131x_isr - The Interrupt Service Routine for the driver.
  * @irq: the IRQ on which the interrupt was received.
-- 
1.7.6.4

