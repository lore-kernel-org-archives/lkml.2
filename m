Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0CQOlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:41:32 -0400
Received: from rsk.demon.co.uk ([80.176.90.227]:34349 "EHLO castor.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754431Ab0CQOlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:41:10 -0400
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging wlan-ng: fix p80211wext_mhz_to_channel for channel 14
Date: Wed, 17 Mar 2010 14:40:56 +0000
Message-Id: <1268836857-31738-3-git-send-email-richard@rsk.demon.co.uk>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268836857-31738-1-git-send-email-richard@rsk.demon.co.uk>
References: <1268836857-31738-1-git-send-email-richard@rsk.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Channel 14 is 2484 Mhz (cf p80211wext_channel_to_mhz) so this patch corrects what seems
to be just a typo.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211wext.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 94d933c..6b4d3e4 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -75,7 +75,7 @@ static u8 p80211_mhz_to_channel(u16 mhz)
 	if (mhz >= 5000)
 		return (mhz - 5000) / 5;
 
-	if (mhz == 2482)
+	if (mhz == 2484)
 		return 14;
 
 	if (mhz >= 2407)
-- 
1.6.6.1

