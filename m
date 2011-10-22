Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1JVFrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:47:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1JVFro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:47:44 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/36] Staging: cx25821: cx25821-medusa-defines.h: Line up defines
Date: Sat, 22 Oct 2011 13:43:36 +0800
Message-Id: <1319262236-6498-17-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line up constant defines to the same column.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-medusa-defines.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-defines.h b/drivers/staging/cx25821/cx25821-medusa-defines.h
index 07a6141..7a9e647 100644
--- a/drivers/staging/cx25821/cx25821-medusa-defines.h
+++ b/drivers/staging/cx25821/cx25821-medusa-defines.h
@@ -34,9 +34,9 @@
 #define VDEC_H		7
 
 /* end of display sequence */
-#define END_OF_SEQ					0xF;
+#define END_OF_SEQ	0xF;
 
 /* registry string size */
-#define MAX_REGISTRY_SZ					40;
+#define MAX_REGISTRY_SZ	40;
 
 #endif
-- 
1.7.0.4

