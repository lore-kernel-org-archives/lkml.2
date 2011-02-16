Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab1BPBvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:38 -0500
Received: from kroah.org ([198.145.64.141]:49130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366Ab1BPBu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:01 2011
Message-Id: <20110216014701.668059244@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [074/115] ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit 8d661f1e462d50bd83de87ee628aaf820ce3c66c upstream.

It is defined in include/linux/ieee80211.h. As per IEEE spec.
bit6 to bit15 in block ack parameter represents buffer size.
So the bitmask should be 0xFFC0.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ieee80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -872,7 +872,7 @@ struct ieee80211_ht_info {
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 


