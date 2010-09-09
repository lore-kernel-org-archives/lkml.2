Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0IIW1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:27:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36527 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab0IIW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b5ymdh7X2s4f33C03ZPfQ/P5QaJjNtmx2H1VV8G9dAF6oOo+yzO6qXhAui/bl/Dp+C
         Cjd034D2Yo8A9CfsMajtP6oqCIKM6ZbPrI+04M7jxRVESMp9mM4Z+3P7CmqLOTKF4MfZ
         6sE8y91rVCx1d4OlLyeYP3Fz0eMb5x/SmYuBI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 056/223]drivers/media/video/bt8xx/bttv-cards.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:39 -0700
Message-Id: <1284071263-7789-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
References: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/bt8xx/bttv-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 7af56cd..0c2f677 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -2290,7 +2290,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_addr	= ADDR_UNSET,
 	},
 	[BTTV_BOARD_SPIRIT_TV] = {
-		/* Spirit TV Tuner from http://spiritmodems.com.au */
+		/* Spirit TV Tuner from http://web.archive.org/web/*/http://spiritmodems.com.au */
 		/* Stafford Goodsell <surge@goliath.homeunix.org> */
 		.name           = "Spirit TV Tuner",
 		.video_inputs   = 3,
-- 
1.7.2.1

