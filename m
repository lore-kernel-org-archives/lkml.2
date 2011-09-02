Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab1IBD6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:58:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44456 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168Ab1IBD60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:26 -0400
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
Subject: [PATCH v4 12/19] Staging: cx25821: Fix long lines in cx25821-audio-upstream.h
Date: Fri,  2 Sep 2011 11:55:40 +0800
Message-Id: <1314935747-6881-13-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-audio-upstream.h

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.h b/drivers/staging/cx25821/cx25821-audio-upstream.h
index 668a4f1..af2ae7c 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.h
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.h
@@ -46,11 +46,16 @@
 #define USE_RISC_NOOP_AUDIO   1
 
 #ifdef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE						\
+	(LINES_PER_AUDIO_BUFFER * RISC_READ_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS * DWORD_SIZE +	\
+	 RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_AUDIO
-#define AUDIO_RISC_DMA_BUF_SIZE    (LINES_PER_AUDIO_BUFFER*RISC_READ_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
+#define AUDIO_RISC_DMA_BUF_SIZE						\
+	(LINES_PER_AUDIO_BUFFER * RISC_READ_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_JUMP_INSTRUCTION_SIZE)
 #endif
 
 static int _line_size;
-- 
1.7.0.4

