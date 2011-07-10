Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1GJJ2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:28:40 -0400
Received: from mail.perches.com ([173.55.12.10]:3729 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab1GJJ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:28:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ath5k: Add missing breaks in switch/case
Date: Sun, 10 Jul 2011 02:28:26 -0700
Message-Id: <e554bed5c753a3fe85d3be34983a15e6110a6e35.1310289795.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath5k/desc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 62172d5..f82383b 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -107,10 +107,13 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 		case AR5K_PKT_TYPE_BEACON:
 		case AR5K_PKT_TYPE_PROBE_RESP:
 			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY;
+			break;
 		case AR5K_PKT_TYPE_PIFS:
 			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS;
+			break;
 		default:
 			frame_type = type;
+			break;
 		}
 
 		tx_ctl->tx_control_0 |=
-- 
1.7.6.131.g99019

