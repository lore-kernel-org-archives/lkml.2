Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2IXQRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:17:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44091 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2IXQRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:17:08 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging "wlan-ng" Fix typos.
Date: Mon, 24 Sep 2012 09:16:57 -0700
Message-Id: <1348503417-10788-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "wlan-ng"

 drivers/staging/wlan-ng/cfg80211.c     |    4 ++--
 drivers/staging/wlan-ng/p80211netdev.c |    2 +-
 drivers/staging/wlan-ng/p80211types.h  |    2 +-
 drivers/staging/wlan-ng/prism2fw.c     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 0970127..e1833bd 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -1,7 +1,7 @@
 /* cfg80211 Interface for prism2_usb module */
 
 
-/* Prism2 channell/frequency/bitrate declarations */
+/* Prism2 channel/frequency/bitrate declarations */
 static const struct ieee80211_channel prism2_channels[] = {
 	{ .center_freq = 2412 },
 	{ .center_freq = 2417 },
@@ -499,7 +499,7 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 			goto exit;
 	}
 
-	/* Set the authorisation */
+	/* Set the authorization */
 	if ((sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) ||
 		((sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC) && !is_wep))
 			msg_join.authtype.data = P80211ENUM_authalg_opensystem;
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 8afb193..a5e2d41 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -461,7 +461,7 @@ failed:
 /*----------------------------------------------------------------
 * p80211knetdev_set_multicast_list
 *
-* Called from higher lavers whenever there's a need to set/clear
+* Called from higher layers whenever there's a need to set/clear
 * promiscuous mode or rewrite the multicast list.
 *
 * Arguments:
diff --git a/drivers/staging/wlan-ng/p80211types.h b/drivers/staging/wlan-ng/p80211types.h
index f043090..8cb4fc6 100644
--- a/drivers/staging/wlan-ng/p80211types.h
+++ b/drivers/staging/wlan-ng/p80211types.h
@@ -197,7 +197,7 @@
 					P80211DID_LSB_ACCESS)
 
 /*----------------------------------------------------------------*/
-/* The following structure types are used for the represenation */
+/* The following structure types are used for the representation */
 /*  of ENUMint type metadata. */
 
 typedef struct p80211enumpair {
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index e22784e..0dfd2a4 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -806,7 +806,7 @@ static int read_cardpda(struct pda *pda, wlandevice_t *wlandev)
 *
 * Note also that the start address record, originally an S7 record in
 * the srec file, is expected in the fw file to be like a data record but
-* with a certain address to make it identiable.
+* with a certain address to make it identifiable.
 *
 * Here's the SREC format that the fw should have come from:
 * S[37]nnaaaaaaaaddd...dddcc
-- 
1.7.9.5

