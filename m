Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab0JZT5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39450 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/22] trivial: fix typos concerning "between"
Date: Tue, 26 Oct 2010 21:57:02 +0200
Message-Id: <1288123039-22368-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/kprobes.txt             |    2 +-
 arch/arm/plat-mxc/include/mach/irqs.h |    2 +-
 drivers/media/video/zoran/zoran.h     |    2 +-
 drivers/net/tehuti.c                  |    4 ++--
 lib/swiotlb.c                         |    2 +-
 mm/percpu.c                           |    2 +-
 sound/core/pcm_native.c               |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 741fe66..0cfb00f 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -598,7 +598,7 @@ a 5-byte jump instruction. So there are several limitations.
 a) The instructions in DCR must be relocatable.
 b) The instructions in DCR must not include a call instruction.
 c) JTPR must not be targeted by any jump or call instruction.
-d) DCR must not straddle the border betweeen functions.
+d) DCR must not straddle the border between functions.
 
 Anyway, these limitations are checked by the in-kernel instruction
 decoder, so you don't need to worry about that.
diff --git a/arch/arm/plat-mxc/include/mach/irqs.h b/arch/arm/plat-mxc/include/mach/irqs.h
index 86781f7..664c453 100644
--- a/arch/arm/plat-mxc/include/mach/irqs.h
+++ b/arch/arm/plat-mxc/include/mach/irqs.h
@@ -66,7 +66,7 @@ extern int imx_irq_set_priority(unsigned char irq, unsigned char prio);
 
 /* all normal IRQs can be FIQs */
 #define FIQ_START	0
-/* switch betwean IRQ and FIQ */
+/* switch between IRQ and FIQ */
 extern int mxc_set_irq_fiq(unsigned int irq, unsigned int type);
 
 #endif /* __ASM_ARCH_MXC_IRQS_H__ */
diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/video/zoran/zoran.h
index 37fe161..1f04438 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -95,7 +95,7 @@ struct zoran_params {
 
 	int quality;		/* Measure for quality of compressed images.
 				 * Scales linearly with the size of the compressed images.
-				 * Must be beetween 0 and 100, 100 is a compression
+				 * Must be between 0 and 100, 100 is a compression
 				 * ratio of 1:4 */
 
 	int odd_even;		/* Which field should come first ??? */
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 62ee1cd..474652a 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -12,7 +12,7 @@
 /*
  * RX HW/SW interaction overview
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * There are 2 types of RX communication channels betwean driver and NIC.
+ * There are 2 types of RX communication channels between driver and NIC.
  * 1) RX Free Fifo - RXF - holds descriptors of empty buffers to accept incoming
  * traffic. This Fifo is filled by SW and is readen by HW. Each descriptor holds
  * info about buffer's location, size and ID. An ID field is used to identify a
@@ -1346,7 +1346,7 @@ static void print_rxfd(struct rxf_desc *rxfd)
 /*
  * TX HW/SW interaction overview
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * There are 2 types of TX communication channels betwean driver and NIC.
+ * There are 2 types of TX communication channels between driver and NIC.
  * 1) TX Free Fifo - TXF - holds ack descriptors for sent packets
  * 2) TX Data Fifo - TXD - holds descriptors of full buffers.
  *
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7c06ee5..c47bbe1 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -60,7 +60,7 @@ int swiotlb_force;
 static char *io_tlb_start, *io_tlb_end;
 
 /*
- * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
+ * The number of IO TLB blocks (in groups of 64) between io_tlb_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
 static unsigned long io_tlb_nslabs;
diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..f715d01 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -258,7 +258,7 @@ static void __maybe_unused pcpu_next_pop(struct pcpu_chunk *chunk,
 
 /*
  * (Un)populated page region iterators.  Iterate over (un)populated
- * page regions betwen @start and @end in @chunk.  @rs and @re should
+ * page regions between @start and @end in @chunk.  @rs and @re should
  * be integer variables and will be set to start and end page index of
  * the current region.
  */
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 8bc7cb3..8e022fc 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -985,7 +985,7 @@ static int snd_pcm_do_pause(struct snd_pcm_substream *substream, int push)
 	if (push)
 		snd_pcm_update_hw_ptr(substream);
 	/* The jiffies check in snd_pcm_update_hw_ptr*() is done by
-	 * a delta betwen the current jiffies, this gives a large enough
+	 * a delta between the current jiffies, this gives a large enough
 	 * delta, effectively to skip the check once.
 	 */
 	substream->runtime->hw_ptr_jiffies = jiffies - HZ * 1000;
-- 
1.7.2.3

