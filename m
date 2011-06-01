Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1FASAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:00:37 -0400
Received: from mail.perches.com ([173.55.12.10]:2368 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1FAR7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:59:17 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: [PATCH 1/6] MAINTAINERS: Update MSM pattern
Date: Wed,  1 Jun 2011 10:59:09 -0700
Message-Id: <326591b5bd7f016a40a325fa0a532bfab47218d6.1306950701.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306950701.git.joe@perches.com>
References: <cover.1306950701.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video MSM is still in staging.

cc: David Brown <davidb@codeaurora.org>
cc: Daniel Walker <dwalker@fifo99.com>
cc: Bryan Huntsman <bryanh@codeaurora.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..ae06910 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -926,7 +926,7 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
-F:	drivers/platform/msm/
+F:	drivers/staging/msm/
 F:	drivers/*/pm8???-*
 F:	include/linux/mfd/pm8xxx/
 T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
-- 
1.7.5.rc3.dirty

