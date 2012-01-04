Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2ADHSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:18:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56099 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2ADHSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:18:15 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 2/2] davinci: CQ93VC: remove machine specific header file inclusion from codec driver
Date: Wed, 4 Jan 2012 12:47:49 +0530
Message-ID: <1325661469-4411-3-git-send-email-manjunath.hadli@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1325661469-4411-1-git-send-email-manjunath.hadli@ti.com>
References: <1325661469-4411-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unnecessary inclusion of machine specific header
file mach/dm365.h from cq93vc.c voice codec driver
which comes in the way of platform code consolidation.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Cc: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>
Cc: <alsa-devel@alsa-project.org>
Cc: <linux-kernel@vger.kernel.org>
---
 sound/soc/codecs/cq93vc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 46dbfd0..ff4eb7a 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -38,8 +38,6 @@
 #include <sound/soc.h>
 #include <sound/initval.h>
 
-#include <mach/dm365.h>
-
 static inline unsigned int cq93vc_read(struct snd_soc_codec *codec,
 						unsigned int reg)
 {
-- 
1.6.2.4

