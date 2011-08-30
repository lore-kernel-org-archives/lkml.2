Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1H3ETH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:19:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1H3ETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:19:03 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 11/18] Staging: cx25821: Fix long lines in cx25821-audio-upstream.h
Date: Tue, 30 Aug 2011 12:17:06 +0800
Message-Id: <1314677833-4689-12-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-audio-upstream.h

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.h b/drivers/staging/cx25821/cx25821-audio-upstream.h
index 668a4f1..ae1d37c 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.h
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.h
@@ -46,11 +46,16 @@
 #define USE_RISC_NOOP_AUDIO   1
 
 #ifdef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE						\
+	(LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE +	\
+	 RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE						\
+	(LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 static int _line_size;
-- 
1.7.0.4

