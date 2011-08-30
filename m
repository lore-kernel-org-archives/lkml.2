Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1H3EUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:20:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab1H3ET7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:19:59 -0400
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
Subject: [PATCH v3 18/18] Staging: cx25821: Fix long lines in cx25821-video-upstream.h
Date: Tue, 30 Aug 2011 12:17:13 +0800
Message-Id: <1314677833-4689-19-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-video-upstream.h

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video-upstream.h |   78 +++++++++++++++-------
 1 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.h b/drivers/staging/cx25821/cx25821-video-upstream.h
index f0b3ac0..268ec8a 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.h
+++ b/drivers/staging/cx25821/cx25821-video-upstream.h
@@ -66,44 +66,74 @@
 #define USE_RISC_NOOP_VIDEO   1
 
 #ifdef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE        ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +   \
-				      RISC_SYNC_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define PAL_US_VID_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
 #define PAL_RISC_BUF_SIZE           (2 * PAL_US_VID_PROG_SIZE)
 
-#define PAL_VID_PROG_SIZE           ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				      RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
+#define PAL_VID_PROG_SIZE						\
+	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
+	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	 JUMP_INSTRUCTION_SIZE + 2 * NUM_NO_OPS * DWORD_SIZE)
 
-#define ODD_FLD_PAL_PROG_SIZE       ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
-				      RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define ODD_FLD_PAL_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
-#define ODD_FLD_NTSC_PROG_SIZE      ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
-				      RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define ODD_FLD_NTSC_PROG_SIZE						\
+	(NTSC_ODD_FLD_LINES * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
-#define NTSC_US_VID_PROG_SIZE       ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
-				      JUMP_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define NTSC_US_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE +			\
+	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
-#define NTSC_RISC_BUF_SIZE          (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
+#define NTSC_RISC_BUF_SIZE						\
+	(2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
 
-#define FRAME1_VID_PROG_SIZE        ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				      RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
+#define FRAME1_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE +	\
+	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	 JUMP_INSTRUCTION_SIZE + 2 * NUM_NO_OPS * DWORD_SIZE)
 
 #endif
 
 #ifndef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE        ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
-				      RISC_SYNC_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+#define PAL_US_VID_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE +	\
+	 JUMP_INSTRUCTION_SIZE)
 
-#define PAL_RISC_BUF_SIZE           (2 * PAL_US_VID_PROG_SIZE)
+#define PAL_RISC_BUF_SIZE		(2 * PAL_US_VID_PROG_SIZE)
+
+#define PAL_VID_PROG_SIZE						\
+	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
+	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	 JUMP_INSTRUCTION_SIZE)
+
+#define ODD_FLD_PAL_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define ODD_FLD_NTSC_PROG_SIZE						\
+	(NTSC_ODD_FLD_LINES * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define NTSC_US_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE +			\
+	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
 
-#define PAL_VID_PROG_SIZE           ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				      RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+#define NTSC_RISC_BUF_SIZE						\
+	(2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
 
-#define ODD_FLD_PAL_PROG_SIZE       ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define ODD_FLD_NTSC_PROG_SIZE      ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+#define FRAME1_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE +	\
+	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	 JUMP_INSTRUCTION_SIZE)
 
-#define NTSC_US_VID_PROG_SIZE       ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define NTSC_RISC_BUF_SIZE          (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
-#define FRAME1_VID_PROG_SIZE        ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				      RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
 #endif
-- 
1.7.0.4

