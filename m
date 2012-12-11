Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2LKVum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:50:42 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:38013 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2LKVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:26 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>
Subject: [PATCH 19/19] MAINTAINERS: fix drivers/staging/sm7xx/
Date: Tue, 11 Dec 2012 19:50:01 -0200
Message-Id: <1355262601-4263-20-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This directory was moved to drivers/staging/sm7xxfb/ by commit 925aa66
(staging: sm7xxfb: sm7xx becomes sm7xxfb).

Acked-by: Javier Muñoz <jmunhoz@igalia.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f900562..6bcc044 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7076,7 +7076,7 @@ F:	drivers/staging/rtl8712/
 STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
 M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
-F:	drivers/staging/sm7xx/
+F:	drivers/staging/sm7xxfb/
 
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
 M:	Ben Collins <bcollins@bluecherry.net>
-- 
1.7.11.7

