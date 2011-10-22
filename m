Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1JVFrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:47:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab1JVFri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:47:38 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/36] Staging: cx25821: cx25821-medusa-defines.h: Fix typo
Date: Sat, 22 Oct 2011 13:43:35 +0800
Message-Id: <1319262236-6498-16-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in comment in word 'decoder'.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-medusa-defines.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-defines.h b/drivers/staging/cx25821/cx25821-medusa-defines.h
index 60d197f..07a6141 100644
--- a/drivers/staging/cx25821/cx25821-medusa-defines.h
+++ b/drivers/staging/cx25821/cx25821-medusa-defines.h
@@ -23,7 +23,7 @@
 #ifndef _MEDUSA_DEF_H_
 #define _MEDUSA_DEF_H_
 
-/* Video deocder that we supported */
+/* Video decoder that we supported */
 #define VDEC_A		0
 #define VDEC_B		1
 #define VDEC_C		2
-- 
1.7.0.4

