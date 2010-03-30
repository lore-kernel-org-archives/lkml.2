Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0C3XWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:22:18 -0400
Received: from kroah.org ([198.145.64.141]:46513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab0C3XVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:18 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:33 2010
Message-Id: <20100330224832.514195388@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vivek Natarajan <vnatarajan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [110/156] ath9k: Enable IEEE80211_HW_REPORTS_TX_ACK_STATUS flag for ath9k
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vivek Natarajan <vnatarajan@atheros.com>

commit 05df49865be08b30e7ba91b9d3d94d7d52dd3033 upstream.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1856,6 +1856,7 @@ void ath_set_hw_capab(struct ath_softc *
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SPECTRUM_MGMT;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)


