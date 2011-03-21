Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1CULxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:53:34 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52279 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1CULxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:53:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p2LBrPQm027668
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/3] net/r8169: add a new chip for RTL8105
Date: Mon, 21 Mar 2011 19:50:30 +0800
X-BOX-Message-Id: p2LBrPQm027668
Message-ID: <1300708230-1934-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1300708230-1934-1-git-send-email-hayeswang@realtek.com>
References: <1300708230-1934-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new chip for RTL8105 whose settings are the same with RTL_GIGA_MAC_VER_30.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/r8169.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 493b0de..0111a14 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1574,6 +1574,7 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp,
 		{ 0x7c800000, 0x30000000,	RTL_GIGA_MAC_VER_11 },
 
 		/* 8101 family. */
+		{ 0x7cf00000, 0x40b00000,	RTL_GIGA_MAC_VER_30 },
 		{ 0x7cf00000, 0x40a00000,	RTL_GIGA_MAC_VER_30 },
 		{ 0x7cf00000, 0x40900000,	RTL_GIGA_MAC_VER_29 },
 		{ 0x7c800000, 0x40800000,	RTL_GIGA_MAC_VER_30 },
-- 
1.7.3.2

