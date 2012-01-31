Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2AaOda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:33:30 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:36679
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754594Ab2AaOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:33:28 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] ath6kl: Fix typo in cfg80211.c
Date: Tue, 31 Jan 2012 23:32:55 +0900
Message-Id: <1328020375-2210-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "spported" to "supported" in
drivers/net/wireless/ath/ath6kl/cfg80211.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6c59a21..ee1715b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -196,7 +196,7 @@ static int ath6kl_set_auth_type(struct ath6kl_vif *vif,
 		break;
 
 	default:
-		ath6kl_err("%s: 0x%x not spported\n", __func__, auth_type);
+		ath6kl_err("%s: 0x%x not supported\n", __func__, auth_type);
 		return -ENOTSUPP;
 	}
 
-- 
1.7.6.5

