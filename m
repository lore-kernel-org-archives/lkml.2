Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0GUMfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:35:22 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58220 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab0GUMfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:35:19 -0400
Date: Wed, 21 Jul 2010 14:35:17 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/3] sound/oss: Remove dead CONFIG_SOFTOSS*
Message-ID: <73dd840e90ee81c76a765e4aa3ed3b90a88b2e2e.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SOFTOSS* doesn't exist in Kconfig or somewhere
else, therefore removing all references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 sound/oss/vidc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/oss/vidc.c b/sound/oss/vidc.c
index ac39a53..f0e0caa 100644
--- a/sound/oss/vidc.c
+++ b/sound/oss/vidc.c
@@ -491,9 +491,6 @@ static void __init attach_vidc(struct address_info *hw_config)
 	vidc_adev = adev;
 	vidc_mixer_set(SOUND_MIXER_VOLUME, (85 | 85 << 8));
 
-#if defined(CONFIG_SOUND_SOFTOSS) || defined(CONFIG_SOUND_SOFTOSS_MODULE)
-	softoss_dev = adev;
-#endif
 	return;
 
 irq_failed:
-- 
1.7.0.4

