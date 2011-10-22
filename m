Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1JVFp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:45:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1JVFpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:45:55 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/36] Staging: cx25821: cx25821-alsa.c: Line up comments
Date: Sat, 22 Oct 2011 13:43:21 +0800
Message-Id: <1319262236-6498-2-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line up comments to the same column.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-alsa.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index ebdba7c..8d5fdd5 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -234,15 +234,15 @@ static int _cx25821_stop_audio_dma(struct cx25821_audio_dev *chip)
  */
 static char *cx25821_aud_irqs[32] = {
 	"dn_risci1", "up_risci1", "rds_dn_risc1",	/* 0-2 */
-	NULL,			/* reserved */
+	NULL,						/* reserved */
 	"dn_risci2", "up_risci2", "rds_dn_risc2",	/* 4-6 */
-	NULL,			/* reserved */
-	"dnf_of", "upf_uf", "rds_dnf_uf",	/* 8-10 */
-	NULL,			/* reserved */
-	"dn_sync", "up_sync", "rds_dn_sync",	/* 12-14 */
-	NULL,			/* reserved */
-	"opc_err", "par_err", "rip_err",	/* 16-18 */
-	"pci_abort", "ber_irq", "mchg_irq"	/* 19-21 */
+	NULL,						/* reserved */
+	"dnf_of", "upf_uf", "rds_dnf_uf",		/* 8-10 */
+	NULL,						/* reserved */
+	"dn_sync", "up_sync", "rds_dn_sync",		/* 12-14 */
+	NULL,						/* reserved */
+	"opc_err", "par_err", "rip_err",		/* 16-18 */
+	"pci_abort", "ber_irq", "mchg_irq"		/* 19-21 */
 };
 
 /*
-- 
1.7.0.4

