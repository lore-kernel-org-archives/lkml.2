Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1LIINt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:13:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34592 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751429Ab1LIINr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:13:47 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 5/8] MAINTAINERS: serial:blackfin: Update F: pattern
Date: Fri,  9 Dec 2011 00:12:51 -0800
Message-Id: <a3cdc345b319a8208e5c177887ecba60e7f2e30f.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
@@ -1499,7 +1499,7 @@ M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
-F:	drivers/tty/serial/bfin_5xx.c
+F:	drivers/tty/serial/bfin_uart.c
 
 BLACKFIN WATCHDOG DRIVER
 M:	Mike Frysinger <vapier.adi@gmail.com>
-- 
1.7.8.111.gad25c.dirty

