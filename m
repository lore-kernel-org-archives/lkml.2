Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2LKVuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:50:24 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:34690 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2LKVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:17 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/19] MAINTAINERS: fix drivers/rtc/rtc-vt8500.c
Date: Tue, 11 Dec 2012 19:49:46 -0200
Message-Id: <1355262601-4263-5-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e013f00..f5df323 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1232,7 +1232,7 @@ F:	drivers/video/vt8500lcdfb.*
 F:	drivers/video/wm8505fb*
 F:	drivers/video/wmt_ge_rops.*
 F:	drivers/tty/serial/vt8500_serial.c
-F:	drivers/rtc/rtc-vt8500-c
+F:	drivers/rtc/rtc-vt8500.c
 
 ARM/ZIPIT Z2 SUPPORT
 M:	Marek Vasut <marek.vasut@gmail.com>
-- 
1.7.11.7

