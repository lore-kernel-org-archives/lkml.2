Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0LNA5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:18 -0500
Received: from mail.perches.com ([173.55.12.10]:2609 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795Ab0LNA5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:16 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/8] staging: brcm80211: Remove unused ether_<foo> #defines and struct
Date: Mon, 13 Dec 2010 16:56:59 -0800
Message-Id: <499374d1530aa26f69954d20a3506250d3b9d6f4.1292287723.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are unused, just remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/include/proto/ethernet.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index a2353a5..1b352c5 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -64,17 +64,7 @@ BWL_PRE_PACKED_STRUCT struct ether_addr {
 
 #define ETHER_SET_UNICAST(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] & ~1))
 
-#define	ether_cmp(a, b)	(!(((short *)a)[0] == ((short *)b)[0]) | \
-			 !(((short *)a)[1] == ((short *)b)[1]) | \
-			 !(((short *)a)[2] == ((short *)b)[2]))
-
-#define	ether_copy(s, d) { \
-		((short *)d)[0] = ((short *)s)[0]; \
-		((short *)d)[1] = ((short *)s)[1]; \
-		((short *)d)[2] = ((short *)s)[2]; }
-
 static const struct ether_addr ether_bcast = { {255, 255, 255, 255, 255, 255} };
-static const struct ether_addr ether_null = { {0, 0, 0, 0, 0, 0} };
 
 #define ETHER_ISBCAST(ea)	((((u8 *)(ea))[0] &		\
 	((u8 *)(ea))[1] &		\
-- 
1.7.3.3.398.g0b0cd.dirty

