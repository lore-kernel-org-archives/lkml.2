Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2D3DXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 23:23:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60393 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2D3DXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 23:23:41 -0400
From: 21cnbao@gmail.com
To: arnd@arndb.de, olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] MAINTAINER: add some drivers upstreamed in CSR SIRFPRIMA2
Date: Mon, 30 Apr 2012 11:23:23 +0800
Message-Id: <1335756203-3285-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 MAINTAINERS |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb76fc4..177d3f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -746,7 +746,10 @@ M:	Barry Song <baohua.song@csr.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-prima2/
-F:	drivers/dma/sirf-dma*
+F:	drivers/dma/sirf-dma.c
+F:	drivers/i2c/busses/i2c-sirf.c
+F:	drivers/pinctrl/pinctrl-sirf.c
+F:	drivers/spi/spi-sirf.c
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-- 
1.7.1

