Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161215Ab2GLVF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:05:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65242 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2GLVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:05:57 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: lrg@ti.com
Cc: broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] sound:soc:soc-dmap: Fix compilation warning.
Date: Thu, 12 Jul 2012 23:00:16 +0200
Message-Id: <1342126816-22308-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following:
sound/soc/soc-dapm.c: In function ‘dapm_clock_event’:
sound/soc/soc-dapm.c:1021:1: warning: control reaches end of non-void function [-Wreturn-type]

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 sound/soc/soc-dapm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index f829d6f..eded657 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1018,6 +1018,7 @@ int dapm_clock_event(struct snd_soc_dapm_widget *w,
 		return 0;
 	}
 #endif
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dapm_clock_event);
 
-- 
1.7.9.5

