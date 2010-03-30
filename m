Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0C3XTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:34 -0400
Received: from kroah.org ([198.145.64.141]:45504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab0C3XS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:59 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:08 2010
Message-Id: <20100330225707.998106624@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vivek Natarajan <vnatarajan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [103/116] ath9k: Enable IEEE80211_HW_REPORTS_TX_ACK_STATUS flag for ath9k
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -1544,6 +1544,7 @@ void ath_set_hw_capab(struct ath_softc *
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SPECTRUM_MGMT;
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)


