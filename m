Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2FYO2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:28:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab2FYO2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:28:34 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jmunhoz@igalia.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging "sm7xxfb" Fix typos in sm7xxfb
Date: Mon, 25 Jun 2012 07:28:25 -0700
Message-Id: <1340634505-19700-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes some typos found in staging "sm7xxfb" while reading through.

 drivers/staging/sm7xxfb/sm7xxfb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 21dab34..32111a0 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -351,7 +351,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 	case FB_VISUAL_DIRECTCOLOR:
 	case FB_VISUAL_TRUECOLOR:
 		/*
-		 * 16/32 bit true-colour, use pseuo-palette for 16 base color
+		 * 16/32 bit true-colour, use pseudo-palette for 16 base color
 		 */
 		if (regno < 16) {
 			if (sfb->fb.var.bits_per_pixel == 16) {
@@ -996,7 +996,7 @@ static int smtcfb_pci_suspend(struct device *device)
 
 	sfb = pci_get_drvdata(pdev);
 
-	/* set the hw in sleep mode use externel clock and self memory refresh
+	/* set the hw in sleep mode use external clock and self memory refresh
 	 * so that we can turn off internal PLLs later on
 	 */
 	smtc_seqw(0x20, (smtc_seqr(0x20) | 0xc0));
-- 
1.7.5.4

