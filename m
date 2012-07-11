Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2GKMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:09:58 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39575 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2GKMJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:09:56 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6BC9JwS004598, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <dwmw2@infradead.org>, <ben@decadent.org.uk>
CC: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH firmware] rtl_nic: update firmware for RTL8168G
Date: Wed, 11 Jul 2012 20:10:03 +0800
Message-ID: <1342008603-1279-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341878937.25597.309.camel@deadeye.wl.decadent.org.uk>
References: <1341878937.25597.309.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File: rtl_nic/rtl8168g-1.fw
Version: 0.0.2

Change the ocp_base of linux driver to OCP_STD_PHY_BASE after setting
firmware. The firmware would modify the ocp_base, and that results the
driver uses the wrong ocp_base to access standard phy after setting
firmware.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 WHENCE                |    2 +-
 rtl_nic/rtl8168g-1.fw |  Bin 4272 -> 4272 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/WHENCE b/WHENCE
index 1fb7951..f46c842 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1817,7 +1817,7 @@ File: rtl_nic/rtl8106e-1.fw
 Version: 0.0.1
 
 File: rtl_nic/rtl8168g-1.fw
-Version: 0.0.1
+Version: 0.0.2
 
 Licence:
  * Copyright © 2011, Realtek Semiconductor Corporation
diff --git a/rtl_nic/rtl8168g-1.fw b/rtl_nic/rtl8168g-1.fw
index dace1ea98c66de08107ee0857d8a8680d57d7898..bc03a5d28fd07d99a6cc89aa115d8ef8942629a6 100644
GIT binary patch
delta 78
zcmdm>xIs~u0SJmpax4tZEYfui;|=r-^o$e?%=HZo^$m?cl0c9E#6m0#40#iERoN}A
WOw6oI3^qo33-CB_$u|JyzyJVS1PxdK

delta 78
zcmdm>xIs~u0SJmpax4tZEYfui;|=r-^b8dY%=C>c^$m?cl0c9E#DXjg3}F*>RoTs~
Qj7)%NW2CnL4@eRQ08i5lSO5S3

-- 
1.7.10.4

