Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2LKVuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:50:18 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:50290 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2LKVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:16 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, linux-arm-msm@vger.kernel.org
Subject: [PATCH 01/19] MAINTAINERS: remove drivers/platform/msm/
Date: Tue, 11 Dec 2012 19:49:43 -0200
Message-Id: <1355262601-4263-2-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added by commit 8a5700c (add drivers/platform/msm to MSM subsystem) in
2011, but I could not find any trace of that directory being ever added
to the repository.

Acked-by: David Brown <davidb@codeaurora.org>
Acked-by: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9386a63..217630e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -987,7 +987,6 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
-F:	drivers/platform/msm/
 F:	drivers/*/pm8???-*
 F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
-- 
1.7.11.7

