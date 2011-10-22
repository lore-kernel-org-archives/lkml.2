Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1JVFqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:46:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1JVFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:46:31 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/36] Staging: cx25821: cx25821-audio-upstream.c: Move operators
Date: Sat, 22 Oct 2011 13:43:26 +0800
Message-Id: <1319262236-6498-7-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move operator of complex expression to the end of the lines to preserve
consistency.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index d7d3a2f..b2cd794 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -398,9 +398,9 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 				vfs_read_retval =
 				    vfs_read(myfile, mybuf, line_size, &pos);
 
-				if (vfs_read_retval > 0
-				    && vfs_read_retval == line_size
-				    && dev->_audiodata_buf_virt_addr != NULL) {
+				if (vfs_read_retval > 0 &&
+				    vfs_read_retval == line_size &&
+				    dev->_audiodata_buf_virt_addr != NULL) {
 					memcpy((void *)(dev->
 							_audiodata_buf_virt_addr
 							+ offset / 4), mybuf,
-- 
1.7.0.4

