Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab2EPIBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:01:40 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:44594
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757004Ab2EPIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:01:37 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/5] mmc: bfin_sdh: Move descriptor array structure into blackfin dma.h head file.
Date: Wed, 16 May 2012 15:50:34 +0800
Message-ID: <1337154637-11724-2-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337154637-11724-1-git-send-email-sonic.zhang@analog.com>
References: <1337154637-11724-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The descriptor array is common among all blackfin dma channels.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/mmc/host/bfin_sdh.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index fd25b0c..56a1093 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -49,13 +49,6 @@
 #define bfin_write_SDH_CFG		bfin_write_RSI_CFG
 #endif
 
-struct dma_desc_array {
-	unsigned long	start_addr;
-	unsigned short	cfg;
-	unsigned short	x_count;
-	short		x_modify;
-} __packed;
-
 struct sdh_host {
 	struct mmc_host		*mmc;
 	spinlock_t		lock;
-- 
1.7.0.4


