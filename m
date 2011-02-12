Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1BLIsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 03:48:22 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39530 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1BLIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 03:48:18 -0500
Subject: [PATCH] MAINTAINERS: Add entry for GPIO subsystem
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 12 Feb 2011 01:48:14 -0700
Message-ID: <20110212084814.22218.92022.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll probably regret this....

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1af022e..2f61f67 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2768,6 +2768,15 @@ F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
 F:	include/linux/gigaset_dev.h
 
+GPIO SUBSYSTEM
+M:	Grant Likely <grant.likely@secretlab.ca>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+T:	git git://git.secretlab.ca/git/linux-2.6.git
+F:	Documentation/gpio/gpio.txt
+F:	drivers/gpio/
+F:	include/linux/gpio*
+
 GRETH 10/100/1G Ethernet MAC device driver
 M:	Kristoffer Glembo <kristoffer@gaisler.com>
 L:	netdev@vger.kernel.org

