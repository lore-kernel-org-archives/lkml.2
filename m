Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1EZKgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:36:17 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:24595 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1EZKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:36:15 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] sound/atmel-pcm: trivial: typo in atmel_pcm_dma_params strucutre comment
Date: Thu, 26 May 2011 13:44:11 +0200
Message-Id: <4690ba475772c4edd963009ad570394df5745a96.1306409927.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1306410252-31534-1-git-send-email-nicolas.ferre@atmel.com>
References: <1306410252-31534-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <ff83ef6ea865da7cb32921154711e672293a7d83.1306409927.git.nicolas.ferre@atmel.com>
References: <ff83ef6ea865da7cb32921154711e672293a7d83.1306409927.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/soc/atmel/atmel-pcm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/atmel-pcm.h b/sound/soc/atmel/atmel-pcm.h
index 2597329..5e0a95e 100644
--- a/sound/soc/atmel/atmel-pcm.h
+++ b/sound/soc/atmel/atmel-pcm.h
@@ -60,7 +60,7 @@ struct atmel_ssc_mask {
  * This structure, shared between the PCM driver and the interface,
  * contains all information required by the PCM driver to perform the
  * PDC DMA operation.  All fields except dma_intr_handler() are initialized
- * by the interface.  The dms_intr_handler() pointer is set by the PCM
+ * by the interface.  The dma_intr_handler() pointer is set by the PCM
  * driver and called by the interface SSC interrupt handler if it is
  * non-NULL.
  */
-- 
1.7.3

