Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2KNGAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:00:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55168 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326Ab2KNFuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:46 -0500
Message-Id: <20121114053941.324289506@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 54/82] ALSA: hda: Cirrus: Fix coefficient index for beep configuration
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit 5a83b4b5a391f07141b157ac9daa51c409e71ab5 upstream.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_cirrus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 61a7113..3b7d67a 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1107,7 +1107,7 @@ static const struct hda_verb cs_coef_init_verbs[] = {
 	  | 0x0400 /* Disable Coefficient Auto increment */
 	  )},
 	/* Beep */
-	{0x11, AC_VERB_SET_COEF_INDEX, IDX_DAC_CFG},
+	{0x11, AC_VERB_SET_COEF_INDEX, IDX_BEEP_CFG},
 	{0x11, AC_VERB_SET_PROC_COEF, 0x0007}, /* Enable Beep thru DAC1/2/3 */
 
 	{} /* terminator */


