Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1JVFtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:49:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1JVFtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:49:40 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 32/36] Staging: cx25821: cx25821-video.c: Fix definitions
Date: Sat, 22 Oct 2011 13:43:52 +0800
Message-Id: <1319262236-6498-33-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change multiple definitions in one statement into multiple statements
with one definition per statement.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index b07c3a8..0ba4f43 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1829,8 +1829,11 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 	struct downstream_user_struct *data_from_user;
 	int command;
 	int width = 720;
-	int selected_channel = 0, pix_format = 0, i = 0;
-	int cif_enable = 0, cif_width = 0;
+	int selected_channel = 0;
+	int pix_format = 0;
+	int i = 0;
+	int cif_enable = 0;
+	int cif_width = 0;
 	u32 value = 0;
 
 	data_from_user = (struct downstream_user_struct *)arg;
-- 
1.7.0.4

