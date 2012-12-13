Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2LMOD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab2LMODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 051/241] ALSA: hda: Cirrus: Fix coefficient index for beep configuration
Date: Thu, 13 Dec 2012 11:56:56 -0200
Message-Id: <1355407206-17100-52-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit 5a83b4b5a391f07141b157ac9daa51c409e71ab5 upstream.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_cirrus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 557f27d..d31497f 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1102,7 +1102,7 @@ static const struct hda_verb cs_coef_init_verbs[] = {
 	  | 0x0400 /* Disable Coefficient Auto increment */
 	  )},
 	/* Beep */
-	{0x11, AC_VERB_SET_COEF_INDEX, IDX_DAC_CFG},
+	{0x11, AC_VERB_SET_COEF_INDEX, IDX_BEEP_CFG},
 	{0x11, AC_VERB_SET_PROC_COEF, 0x0007}, /* Enable Beep thru DAC1/2/3 */
 
 	{} /* terminator */
-- 
1.7.9.5

