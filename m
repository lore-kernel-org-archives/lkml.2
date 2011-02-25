Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1BYGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:16:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58924 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1BYGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WVZiPrB3zqUT8EYXLjDF0UwNqjCvjJgcUrYePnwdrxhB0yQ7tOL9eXfyaRfjCA9MBG
         u8I2zCZ/nAq/INhLEfC140ShuTeiaSJvPgHT3Lg3IkbYpcaOSyd+N+aW/e9q/eZGXC2s
         VnEG9nd/wgR+M+K2u4NF1dEGe/oW/RcgBxC9c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: jassi.brar@samsung.com, lrg@slimlogic.co.uk, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 21/21]sound:soc:samsung:dma.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:16:37 -0800
Message-Id: <1298614597-4340-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/soc/samsung/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 2124019..807efa5 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -313,7 +313,7 @@ dma_pointer(struct snd_pcm_substream *substream)
 	/* we seem to be getting the odd error from the pcm library due
 	 * to out-of-bounds pointers. this is maybe due to the dma engine
 	 * not having loaded the new values for the channel before being
-	 * callled... (todo - fix )
+	 * called... (todo - fix )
 	 */
 
 	if (res >= snd_pcm_lib_buffer_bytes(substream)) {
-- 
1.7.4.1

