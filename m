Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2EEOdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59792 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2EEOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:32 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 8/8] drivers/staging/line6/pcm.c: Removed trailing whitespace
Date: Sat,  5 May 2012 16:31:52 +0200
Message-Id: <1336228312-5379-9-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a line of only whitespace

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 90d2d44..5e319e3 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -99,7 +99,7 @@ int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
 	unsigned long flags_new = flags_old | channels;
 	unsigned long flags_final = flags_old;
 	int err = 0;
-	
+
 	line6pcm->prev_fbuf = NULL;
 
 	if (test_flags(flags_old, flags_new, LINE6_BITS_CAPTURE_BUFFER)) {
-- 
1.7.7.6

