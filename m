Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1IBD6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:58:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52001 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab1IBD6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:19 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 11/19] Staging: cx25821: Fix long lines in cx25821-audio-upstream.c
Date: Fri,  2 Sep 2011 11:55:39 +0800
Message-Id: <1314935747-6881-12-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-audio-upstream.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index e6c4b34..50e56a6 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -538,13 +538,9 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 				    AUDIO_RISC_DMA_BUF_SIZE;
 
 				rp = cx25821_risc_field_upstream_audio(dev,
-								       dev->
-								       _risc_virt_start_addr
-								       + 1,
-								       dev->
-								       _audiodata_buf_phys_addr,
-								       AUDIO_LINE_SIZE,
-								       FIFO_DISABLE);
+						dev->_risc_virt_start_addr + 1,
+						dev->_audiodata_buf_phys_addr,
+						AUDIO_LINE_SIZE, FIFO_DISABLE);
 
 				if (USE_RISC_NOOP_AUDIO) {
 					for (i = 0; i < NUM_NO_OPS; i++) {
-- 
1.7.0.4

