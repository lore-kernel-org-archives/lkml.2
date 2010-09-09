Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0IIW1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:27:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48692 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab0IIW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MlEaeSTw1AVOt8BqO3m79I4tShWRyCJOZIaDw0BxdIxfCKPmrfMuQMW19lVPM1hlGs
         wp/5ywpqs8jnOhiWCNXPuFNAybpMUK4Gqcdciwtu8wI+aXEv6/lX1hpgjezagm4JiS35
         PG8BZmlV+e6zYTQjg6oyB7RDOkbpGwgDL2GVU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 046/223]drivers/media/video/saa7134/saa7134-cards.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:29 -0700
Message-Id: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/saa7134/saa7134-cards.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index ec697fc..647169d 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -2343,8 +2343,8 @@ struct saa7134_board saa7134_boards[] = {
 		},
 	},
 	[SAA7134_BOARD_BEHOLD_409FM] = {
-		/* <http://tuner.beholder.ru>, Sergey <skiv@orel.ru> */
-		/*       Beholder Intl. Ltd. 2008      */
+		/* <http://www.beholder.ru/bb/viewtopic.php?t=1142>, */
+		/*  Sergey <skiv@orel.ru> Beholder Intl. Ltd. 2008 */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV 409 FM",
 		.audio_clock    = 0x00187de7,
-- 
1.7.2.1

