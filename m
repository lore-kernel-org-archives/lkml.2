Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2HRRdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:50329 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab2HRRaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="210330071"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 30/31] sections: Fix section conflicts in sound
Date: Sat, 18 Aug 2012 10:30:21 -0700
Message-Id: <1345311022-26328-31-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 sound/soc/codecs/wm5100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index f481729..aa62c0e 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1233,7 +1233,7 @@ static const struct snd_soc_dapm_route wm5100_dapm_routes[] = {
 	{ "PWM2", NULL, "PWM2 Driver" },
 };
 
-static const __devinitdata struct reg_default wm5100_reva_patches[] = {
+static const __devinitconst struct reg_default wm5100_reva_patches[] = {
 	{ WM5100_AUDIO_IF_1_10, 0 },
 	{ WM5100_AUDIO_IF_1_11, 1 },
 	{ WM5100_AUDIO_IF_1_12, 2 },
-- 
1.7.7.6

