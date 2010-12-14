Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab0LNA5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:14 -0500
Received: from mail.perches.com ([173.55.12.10]:2602 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770Ab0LNA5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:12 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/8] staging: brcm80211: Remove unused #defines ETHER_<foo>_LOCALADDR
Date: Mon, 13 Dec 2010 16:56:57 -0800
Message-Id: <b5bfe566dc136f354a483f99888ffc1849239de5.1292287721.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/include/proto/ethernet.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index cc17b42..a8981f6 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -62,13 +62,6 @@ BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETHER_ADDR_LEN];
 } BWL_POST_PACKED_STRUCT;
 
-#define ETHER_SET_LOCALADDR(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] | 2))
-#define ETHER_IS_LOCALADDR(ea) 	(((u8 *)(ea))[0] & 2)
-#define ETHER_CLR_LOCALADDR(ea)	(((u8 *)(ea))[0] = \
-	(((u8 *)(ea))[0] & 0xd))
-#define ETHER_TOGGLE_LOCALADDR(ea)	(((u8 *)(ea))[0] = \
-	(((u8 *)(ea))[0] ^ 2))
-
 #define ETHER_SET_UNICAST(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] & ~1))
 
 #define ETHER_ISMULTI(ea) (((const u8 *)(ea))[0] & 1)
-- 
1.7.3.3.398.g0b0cd.dirty

