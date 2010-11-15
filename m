Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab0KODGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:06:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1272 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab0KODGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:06:03 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 43/44] sound/core/pcm_lib.c: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:05:02 -0800
Message-Id: <9fa8e193ce125ef4fd19a952792629c5ee84953f.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/core/pcm_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index a1707cc..b75db8e 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -223,7 +223,7 @@ static void xrun_log(struct snd_pcm_substream *substream,
 	entry->jiffies = jiffies;
 	entry->pos = pos;
 	entry->period_size = runtime->period_size;
-	entry->buffer_size = runtime->buffer_size;;
+	entry->buffer_size = runtime->buffer_size;
 	entry->old_hw_ptr = runtime->status->hw_ptr;
 	entry->hw_ptr_base = runtime->hw_ptr_base;
 	log->idx = (log->idx + 1) % XRUN_LOG_CNT;
-- 
1.7.3.1.g432b3.dirty

