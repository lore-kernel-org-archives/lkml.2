Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab2KXA2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:28:10 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:60602 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab2KXA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:28:05 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 23/24] MAINTAINERS: fix drivers/staging/sm7xx/
Date: Fri, 23 Nov 2012 22:26:47 -0200
Message-Id: <1353716808-16375-24-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This directory was moved to drivers/staging/sm7xxfb/ by commit 925aa66
(staging: sm7xxfb: sm7xx becomes sm7xxfb).

Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>
Cc: Javier M. Mellid <jmunhoz@igalia.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 328ba4f..e8990d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7073,7 +7073,7 @@ F:	drivers/staging/rtl8712/
 STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
 M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
-F:	drivers/staging/sm7xx/
+F:	drivers/staging/sm7xxfb/
 
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
 M:	Ben Collins <bcollins@bluecherry.net>
-- 
1.7.11.7

