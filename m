Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1EIXnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:43:53 -0400
Received: from mail.perches.com ([173.55.12.10]:1409 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1EIXnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:43:52 -0400
Subject: [PATCH] MAINTAINERS: Orphan DMFE, move Tobias Ringstrom to CREDITS
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 16:43:50 -0700
Message-ID: <1304984630.19586.78.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias' email bounces and he hasn't submitted
or acked a patch in git history.

Signed-off-by: Joe Perches <joe@perches.com>
---
 CREDITS     |    4 ++++
 MAINTAINERS |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index dca6abc..d87a338 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2943,6 +2943,10 @@ S: Kasarmikatu 11 A4
 S: 70110 Kuopio
 S: Finland
 
+N: Tobias Ringström
+E: tori@unhappy.mine.nu
+D: Davicom DM9102(A)/DM9132/DM9801 fast ethernet driver
+
 N: Luca Risolia
 E: luca.risolia@studio.unibo.it
 P: 1024D/FCE635A4 88E8 F32F 7244 68BA 3958  5D40 99DA 5D2A FCE6 35A4
diff --git a/MAINTAINERS b/MAINTAINERS
index e653a99..dffe26f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2027,9 +2027,8 @@ F:	net/ax25/ax25_timer.c
 F:	net/ax25/sysctl_net_ax25.c
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
-M:	Tobias Ringstrom <tori@unhappy.mine.nu>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	Documentation/networking/dmfe.txt
 F:	drivers/net/tulip/dmfe.c
 


