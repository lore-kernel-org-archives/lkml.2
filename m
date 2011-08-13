Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HMA25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:28:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45030 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1HMA1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:45 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/10]drivers:media  Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:10 -0700
Message-Id: <1313195235-4522-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/dvb/frontends/au8522_priv.h |    2 +-
 drivers/media/video/au0828/au0828-video.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_priv.h b/drivers/media/dvb/frontends/au8522_priv.h
index 751e17d..7da60b6 100644
--- a/drivers/media/dvb/frontends/au8522_priv.h
+++ b/drivers/media/dvb/frontends/au8522_priv.h
@@ -373,7 +373,7 @@ void au8522_release_state(struct au8522_state *state);
 #define AU8522_SYSTEM_MODULE_CONTROL_1_REG0A5H_PAL		0x01
 #define AU8522_SYSTEM_MODULE_CONTROL_1_REG0A5H_FM		0x01
 
-/* STILL NEED TO BE REFACTORED @@@@@@@@@@@@@@ */
+/* STILL NEED TO BE REFACTORED */
 #define AU8522_TVDEC_CONTRAST_REG00BH_CVBS			0x79
 #define AU8522_TVDEC_SATURATION_CB_REG00CH_CVBS			0x80
 #define AU8522_TVDEC_SATURATION_CR_REG00DH_CVBS			0x80
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 0b3e481..c184bc2 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -340,7 +340,7 @@ static void au0828_copy_video(struct au0828_dev *dev,
 {
 	void *fieldstart, *startwrite, *startread;
 	int  linesdone, currlinedone, offset, lencopy, remain;
-	int bytesperline = dev->width << 1; /* Assumes 16-bit depth @@@@ */
+	int bytesperline = dev->width << 1; /* Assumes 16-bit depth */
 
 	if (len == 0)
 		return;
-- 
1.7.6

