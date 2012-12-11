Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2LKVvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:51:49 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:37753 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2LKVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:24 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/19] MAINTAINERS: remove drivers/mmc/host/imxmmc.*
Date: Tue, 11 Dec 2012 19:49:57 -0200
Message-Id: <1355262601-4263-16-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was removed by commit 6187fee (mmc: remove imxmmc driver).

Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b9fc9e..eb0cc18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4908,12 +4908,6 @@ F:	Documentation/video4linux/meye.txt
 F:	drivers/media/pci/meye/
 F:	include/uapi/linux/meye.h
 
-MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
-M:	Pavel Pisa <ppisa@pikron.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	drivers/mmc/host/imxmmc.*
-
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
-- 
1.7.11.7

