Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab0CRGV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:21:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1802 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0CRGVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:21:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pavel Roskin <proski@gnu.org>,
       David Gibson <hermes@gibson.dropbear.id.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH v2 6/7] orinoco/wext.c: Remove local #define STD_IW_HANDLER
Date: Wed, 17 Mar 2010 23:21:39 -0700
Message-Id: <02e23cb16a0d61f38e4550ae4e1f3eb5f8d4ab9d.1268892664.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1268892663.git.joe@perches.com>
References: <cover.1268892663.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been copied into wireless.h, so this one isn't necessary

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/orinoco/wext.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 31ca241..069c333 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1505,8 +1505,6 @@ static const struct iw_priv_args orinoco_privtab[] = {
  * Structures to export the Wireless Handlers
  */
 
-#define STD_IW_HANDLER(id, func) \
-	[IW_IOCTL_IDX(id)] = (iw_handler) func
 static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
 	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),
-- 
1.7.0.14.g7e948

