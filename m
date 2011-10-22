Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1JVFq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:46:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1JVFq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:46:56 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/36] Staging: cx25821: cx25821-audio.h: Fix multiline defines
Date: Sat, 22 Oct 2011 13:43:29 +0800
Message-Id: <1319262236-6498-10-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change column of line continuation character ('\') and fix indent of
multiline defines.
Also line up remaining constant defines.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio.h |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 57bdced..1fc2d24 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -35,27 +35,28 @@
  * Space is also added for the 4 no-op instructions added on the end.
  */
 #ifndef USE_RISC_NOOP
-#define MAX_BUFFER_PROGRAM_SIZE     \
-	(2 * LINES_PER_BUFFER * RISC_WRITE_INSTRUCTION_SIZE + \
-	RISC_WRITECR_INSTRUCTION_SIZE * 4)
+#define MAX_BUFFER_PROGRAM_SIZE						\
+	(2 * LINES_PER_BUFFER * RISC_WRITE_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE * 4)
 #endif
 
 /* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
-#define MAX_BUFFER_PROGRAM_SIZE     \
-	(2 * LINES_PER_BUFFER * RISC_WRITE_INSTRUCTION_SIZE + \
-	RISC_NOOP_INSTRUCTION_SIZE * 4)
+#define MAX_BUFFER_PROGRAM_SIZE						\
+	(2 * LINES_PER_BUFFER * RISC_WRITE_INSTRUCTION_SIZE +		\
+	 RISC_NOOP_INSTRUCTION_SIZE * 4)
 #endif
 
 /* Sizes of various instructions in bytes.  Used when adding instructions. */
-#define RISC_WRITE_INSTRUCTION_SIZE 12
-#define RISC_JUMP_INSTRUCTION_SIZE  12
-#define RISC_SKIP_INSTRUCTION_SIZE  4
-#define RISC_SYNC_INSTRUCTION_SIZE  4
-#define RISC_WRITECR_INSTRUCTION_SIZE  16
-#define RISC_NOOP_INSTRUCTION_SIZE 4
-
-#define MAX_AUDIO_DMA_BUFFER_SIZE	\
-(MAX_BUFFER_PROGRAM_SIZE * NUMBER_OF_PROGRAMS + RISC_SYNC_INSTRUCTION_SIZE)
+#define RISC_WRITE_INSTRUCTION_SIZE	12
+#define RISC_JUMP_INSTRUCTION_SIZE	12
+#define RISC_SKIP_INSTRUCTION_SIZE	4
+#define RISC_SYNC_INSTRUCTION_SIZE	4
+#define RISC_WRITECR_INSTRUCTION_SIZE	16
+#define RISC_NOOP_INSTRUCTION_SIZE	4
+
+#define MAX_AUDIO_DMA_BUFFER_SIZE					\
+	(MAX_BUFFER_PROGRAM_SIZE * NUMBER_OF_PROGRAMS +			\
+	 RISC_SYNC_INSTRUCTION_SIZE)
 
 #endif
-- 
1.7.0.4

