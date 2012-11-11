Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2KKMZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:25:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2KKMZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:05 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 3/8] staging: line6: shorten comment below 80 chars in pcm.c
Date: Sun, 11 Nov 2012 13:24:41 +0100
Message-Id: <1352636686-31170-4-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 7fe44a6..6c1e313 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -109,7 +109,7 @@ int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
 	line6pcm->prev_fbuf = NULL;
 
 	if (test_flags(flags_old, flags_new, LINE6_BITS_CAPTURE_BUFFER)) {
-		/* We may be invoked multiple times in a row so allocate once only */
+		/* Invoked multiple times in a row so allocate once only */
 		if (!line6pcm->buffer_in) {
 			line6pcm->buffer_in =
 				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
@@ -148,7 +148,7 @@ int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
 	}
 
 	if (test_flags(flags_old, flags_new, LINE6_BITS_PLAYBACK_BUFFER)) {
-		/* We may be invoked multiple times in a row so allocate once only */
+		/* Invoked multiple times in a row so allocate once only */
 		if (!line6pcm->buffer_out) {
 			line6pcm->buffer_out =
 				kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
-- 
1.7.12.1

