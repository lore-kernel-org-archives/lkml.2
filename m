Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1JVFuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:50:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab1JVFuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:50:11 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 36/36] Staging: cx25821: cx25821.h: Line up defines
Date: Sat, 22 Oct 2011 13:43:56 +0800
Message-Id: <1319262236-6498-37-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line up constant defines to the same column.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index db2615b..0b3e13b 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -67,7 +67,7 @@
 #define MAX_CAMERAS             16
 
 /* Max number of inputs by card */
-#define MAX_CX25821_INPUT 8
+#define MAX_CX25821_INPUT     8
 #define INPUT(nr) (&cx25821_boards[dev->board].input[nr])
 #define RESOURCE_VIDEO0       1
 #define RESOURCE_VIDEO1       2
@@ -85,7 +85,7 @@
 
 #define BUFFER_TIMEOUT     (HZ)	/* 0.5 seconds */
 
-#define UNKNOWN_BOARD       0
+#define UNKNOWN_BOARD        0
 #define CX25821_BOARD        1
 
 /* Currently supported by the driver */
-- 
1.7.0.4

