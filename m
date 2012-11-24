Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2KXA2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:28:00 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:50978 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab2KXA1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:51 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Sascha Hauer <s.hauer@pengutronix.de>, Pavel Pisa <ppisa@pikron.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/24] MAINTAINERS: remove drivers/mmc/host/imxmmc.*
Date: Fri, 23 Nov 2012 22:26:42 -0200
Message-Id: <1353716808-16375-19-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was removed by commit 6187fee (mmc: remove imxmmc driver).

Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pavel Pisa <ppisa@pikron.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fc646ef..cac8e49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4905,12 +4905,6 @@ F:	Documentation/video4linux/meye.txt
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

