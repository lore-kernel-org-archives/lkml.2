Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0FWWFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:05:20 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34602 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab0FWWFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:05:18 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] MAINTAINERS: Add an entry for the input MT protocol
Date: Thu, 24 Jun 2010 00:04:24 +0200
Message-Id: <1277330664-13884-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORY3g-0007DX-55.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1ORY3g-0007DX-55 4bdbe230d6fefe76d2565c1de0fb2ad5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a maintainer for the input multitouch (MT) protocol,
such that get_maintainer.pl selects it whenever an MT event is present
in the patch.

Cc: Joe Perches <joe@perches.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..32157c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3858,6 +3858,13 @@ S:	Maintained
 F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
 
+MULTITOUCH INPUT MT PROTOCOL
+M:	Henrik Rydberg <rydberg@euromail.se>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	Documentation/input/multi-touch-protocol.txt
+K:	ABS_MT
+
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
 M:	Felipe Balbi <felipe.balbi@nokia.com>
 L:	linux-usb@vger.kernel.org
-- 
1.6.3.3

