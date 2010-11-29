Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0K2MLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:11:34 -0500
Received: from mail.sysgo.com ([195.145.229.155]:58569 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab0K2MLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:11:32 -0500
Date: Mon, 29 Nov 2010 13:11:41 +0100
From: Pavel Machek <pma@sysgo.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        "cko@sysgo.com" <cko@sysgo.com>, "anl@sysgo.com" <anl@sysgo.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "mfa@sysgo.com" <mfa@sysgo.com>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch] remove unneeded prototype on ath9k_htc
Message-ID: <20101129121141.GB30031@pma.sysgo.com>
References: <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
 <19695.40541.335361.81396@gargle.gargle.HOWL>
 <20101126123706.GA19755@pma.sysgo.com>
 <20101129095801.GA28833@pma.sysgo.com>
 <4CF3929E.9020702@openwrt.org>
 <20101129120745.GA30031@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129120745.GA30031@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The prototype does not seem to have corresponding function.

Signed-off-by: Pavel Machek <pma@sysgo.com>

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cc8f3b9..ed5d199 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -906,7 +906,6 @@ bool ath9k_hw_disable(struct ath_hw *ah);
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
 void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
-void ath9k_hw_setbssidmask(struct ath_hw *ah);
 void ath9k_hw_write_associd(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
