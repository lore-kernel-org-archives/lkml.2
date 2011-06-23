Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab1FWSV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:21:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:34174 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176Ab1FWRfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Amitkumar Karwar <akarwar@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 070/247] ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro
Date: Thu, 23 Jun 2011 13:32:18 -0400
Message-Id: <1308850515-15242-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amitkumar Karwar <akarwar@marvell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8d661f1e462d50bd83de87ee628aaf820ce3c66c upstream.

It is defined in include/linux/ieee80211.h. As per IEEE spec.
bit6 to bit15 in block ack parameter represents buffer size.
So the bitmask should be 0xFFC0.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/ieee80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1998495..fd80eec 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -958,7 +958,7 @@ struct ieee80211_ht_info {
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
-- 
1.7.4.4

