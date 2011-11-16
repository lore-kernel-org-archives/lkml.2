Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1KPHzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:55:23 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22082 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1KPHzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:55:22 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bh8275dhz2ei87h2a8h668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] MAINTAINERS: update maintainers for blackfin arch and drivers.
Date: Wed, 16 Nov 2011 15:48:28 +0800
Message-ID: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f6bc29..86941ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1481,6 +1481,7 @@ F:	fs/bfs/
 F:	include/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
+M:	Bob Liu <lliubbo@kernel.org>
 M:	Mike Frysinger <vapier@gentoo.org>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
@@ -1494,14 +1495,12 @@ S:	Supported
 F:	drivers/net/ethernet/adi/
 
 BLACKFIN RTC DRIVER
-M:	Mike Frysinger <vapier.adi@gmail.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SDH DRIVER
-M:	Cliff Cai <cliff.cai@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
@@ -1515,7 +1514,6 @@ S:	Supported
 F:	drivers/tty/serial/bfin_5xx.c
 
 BLACKFIN WATCHDOG DRIVER
-M:	Mike Frysinger <vapier.adi@gmail.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
-- 
1.7.0.4


