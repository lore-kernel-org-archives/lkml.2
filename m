Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab2KVVz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:55:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:49609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab2KVSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 06/38] ALSA: hda: Cirrus: Fix coefficient index for beep configuration
Date: Wed, 21 Nov 2012 16:39:49 -0800
Message-Id: <20121122003904.936566608@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit 5a83b4b5a391f07141b157ac9daa51c409e71ab5 upstream.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_cirrus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -991,7 +991,7 @@ static const struct hda_verb cs_coef_ini
 	  | 0x0400 /* Disable Coefficient Auto increment */
 	  )},
 	/* Beep */
-	{0x11, AC_VERB_SET_COEF_INDEX, IDX_DAC_CFG},
+	{0x11, AC_VERB_SET_COEF_INDEX, IDX_BEEP_CFG},
 	{0x11, AC_VERB_SET_PROC_COEF, 0x0007}, /* Enable Beep thru DAC1/2/3 */
 
 	{} /* terminator */


