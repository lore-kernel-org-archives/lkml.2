Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1LIJvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:51:25 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:30081 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1LIJvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:51:23 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 9 Dec 2011 04:51:21 -0500
Subject: RE: [PATCH 5/8] MAINTAINERS: serial:blackfin: Update F: pattern
Thread-Topic: [PATCH 5/8] MAINTAINERS: serial:blackfin: Update F: pattern
Thread-Index: Acy2Sn5UkKDtEJk6Qf2UBWdXWGW9lgADYmJQ
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16D766CE57F@NWD2CMBX1.ad.analog.com>
References: <cover.1323418149.git.joe@perches.com>
 <a3cdc345b319a8208e5c177887ecba60e7f2e30f.1323418149.git.joe@perches.com>
In-Reply-To: <a3cdc345b319a8208e5c177887ecba60e7f2e30f.1323418149.git.joe@perches.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com]
Sent: Friday, December 09, 2011 4:13 PM
To: Andrew Morton; linux-kernel@vger.kernel.org
Cc: Zhang, Sonic
Subject: [PATCH 5/8] MAINTAINERS: serial:blackfin: Update F: pattern

commit 0c6967b5a0
("serial:blackfin: rename Blackfin serial driver to bfin_uart.c")
renamed the file, update the pattern.

CC: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e397c1f..b40e522 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1499,7 +1499,7 @@ M:        Sonic Zhang <sonic.zhang@analog.com>
 L:     uclinux-dist-devel@blackfin.uclinux.org
 W:     http://blackfin.uclinux.org
 S:     Supported
-F:     drivers/tty/serial/bfin_5xx.c
+F:     drivers/tty/serial/bfin_uart.c

 BLACKFIN WATCHDOG DRIVER
 M:     Mike Frysinger <vapier.adi@gmail.com>
--
1.7.8.111.gad25c.dirty



