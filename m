Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1FXAZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:25:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37333 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923Ab1FXAZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:25:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: socketcan-core@lists.berlios.de,
        Urs Thuermann <urs.thuermann@volkswagen.de>,
        Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: mark socketcan-core lists as subscribers-only
Date: Thu, 23 Jun 2011 20:25:42 -0400
Message-Id: <1308875142-10429-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The socketcan-core lists require subscription, so mark them as such.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f0358cd..d3765e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1639,7 +1639,7 @@ CAN NETWORK LAYER
 M:	Oliver Hartkopp <socketcan@hartkopp.net>
 M:	Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
 M:	Urs Thuermann <urs.thuermann@volkswagen.de>
-L:	socketcan-core@lists.berlios.de
+L:	socketcan-core@lists.berlios.de (subscribers-only)
 L:	netdev@vger.kernel.org
 W:	http://developer.berlios.de/projects/socketcan/
 S:	Maintained
@@ -1651,7 +1651,7 @@ F:	include/linux/can/raw.h
 
 CAN NETWORK DRIVERS
 M:	Wolfgang Grandegger <wg@grandegger.com>
-L:	socketcan-core@lists.berlios.de
+L:	socketcan-core@lists.berlios.de (subscribers-only)
 L:	netdev@vger.kernel.org
 W:	http://developer.berlios.de/projects/socketcan/
 S:	Maintained
-- 
1.7.5.3

