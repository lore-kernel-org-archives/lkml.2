Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1HWWHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:07:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43516 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1HWWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:07:35 -0400
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangjie@qca.qualcomm.com,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>, stable@kernel.org,
        netdev@vger.kernel.org, jouni@qca.qualcomm.com,
        vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com
Subject: [PATCH] MAINTANERS: update Qualcomm Atheros addresses
Date: Tue, 23 Aug 2011 15:07:31 -0700
Message-Id: <1314137251-32096-1-git-send-email-lrodriguez@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Qualcomm ate up Atheros, all of the old e-mail addresses
no longer work and e-mails sent to it will bounce. Update
the addresses to the new shiny Qualcomm Atheros (QCA) ones.

Cc: stable@kernel.org
Cc: netdev@vger.kernel.org
Cc: jouni@qca.qualcomm.com
Cc: yangjie@qca.qualcomm.com
Cc: vthiagar@qca.qualcomm.com
Cc: senthilb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---

John, I've left out ath6kl as you removed that so I take it
the respective MAINTAINERS entry was deleted as well (although
I do not see this on wireless-testing.git)

I've thrown in one Ethernet driver maintainers update as well
for QCA, so hope its OK this goes through you. Given that the
e-mail addresses no longer work Cc'ing stable as well.

 MAINTAINERS |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 069ee3b..a286bc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1230,7 +1230,7 @@ F:	Documentation/aoe/
 F:	drivers/block/aoe/
 
 ATHEROS ATH GENERIC UTILITIES
-M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/net/wireless/ath/*
@@ -1238,7 +1238,7 @@ F:	drivers/net/wireless/ath/*
 ATHEROS ATH5K WIRELESS DRIVER
 M:	Jiri Slaby <jirislaby@gmail.com>
 M:	Nick Kossifidis <mickflemm@gmail.com>
-M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
 M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
@@ -1247,10 +1247,10 @@ S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
 ATHEROS ATH9K WIRELESS DRIVER
-M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
-M:	Jouni Malinen <jmalinen@atheros.com>
-M:	Vasanthakumar Thiagarajan <vasanth@atheros.com>
-M:	Senthil Balasubramanian <senthilkumar@atheros.com>
+M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
+M:	Jouni Malinen <jouni@qca.qualcomm.com>
+M:	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
+M:	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath9k
@@ -1278,7 +1278,7 @@ F:	drivers/input/misc/ati_remote2.c
 ATLX ETHERNET DRIVERS
 M:	Jay Cliburn <jcliburn@gmail.com>
 M:	Chris Snook <chris.snook@gmail.com>
-M:	Jie Yang <jie.yang@atheros.com>
+M:	Jie Yang <yangjie@qca.qualcomm.com>
 L:	netdev@vger.kernel.org
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
-- 
1.7.4.15.g7811d

