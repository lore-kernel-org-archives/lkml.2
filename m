Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1JVFqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:46:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1JVFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:46:49 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/36] Staging: cx25821: cx25821-audio.h: Line up defines
Date: Sat, 22 Oct 2011 13:43:28 +0800
Message-Id: <1319262236-6498-9-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line up defines to the same column.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 8eb55b7..57bdced 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -23,12 +23,12 @@
 #ifndef __CX25821_AUDIO_H__
 #define __CX25821_AUDIO_H__
 
-#define USE_RISC_NOOP               1
-#define LINES_PER_BUFFER            15
-#define AUDIO_LINE_SIZE             128
+#define USE_RISC_NOOP		1
+#define LINES_PER_BUFFER	15
+#define AUDIO_LINE_SIZE		128
 
 /* Number of buffer programs to use at once. */
-#define NUMBER_OF_PROGRAMS  8
+#define NUMBER_OF_PROGRAMS	8
 
 /*
  * Max size of the RISC program for a buffer. - worst case is 2 writes per line
-- 
1.7.0.4

