Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab0LNA6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:58:14 -0500
Received: from mail.perches.com ([173.55.12.10]:2626 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827Ab0LNA51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:27 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 7/8] staging: brcm80211: Remove unused ETHER_TYPE_<foo> #defines
Date: Mon, 13 Dec 2010 16:57:03 -0800
Message-Id: <a4230e57e7c1b246d7047c77349c95c749e62392.1292287725.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/include/proto/ethernet.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 888165e..ad55b56 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -28,13 +28,8 @@
 #define	ETHER_MAX_LEN		1518
 #define	ETHER_MAX_DATA		1500
 
-#define ETHER_TYPE_MIN		0x0600
-#define	ETHER_TYPE_IP		0x0800
-#define ETHER_TYPE_ARP		0x0806
-#define ETHER_TYPE_8021Q	0x8100
 #define	ETHER_TYPE_BRCM		0x886c
 #define	ETHER_TYPE_802_1X	0x888e
-#define	ETHER_TYPE_802_1X_PREAUTH 0x88c7
 
 #define ETHER_DEST_OFFSET	(0 * ETH_ALEN)
 #define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
-- 
1.7.3.3.398.g0b0cd.dirty

