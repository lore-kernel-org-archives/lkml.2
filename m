Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2KXA1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:09 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:48914 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2KXA1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:06 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH 01/24] MAINTAINERS: remove drivers/platform/msm/
Date: Fri, 23 Nov 2012 22:26:25 -0200
Message-Id: <1353716808-16375-2-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added by commit 8a5700c (add drivers/platform/msm to MSM subsystem) in
2011, but I could not find any trace of that directory being ever added
to the repository.

Cc: Kenneth Heitke <kheitke@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 244b2f2..c2fc7af 100644
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

