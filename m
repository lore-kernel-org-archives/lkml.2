Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0FGSuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:46 -0400
Received: from mail.perches.com ([173.55.12.10]:2728 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0FGSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:09 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 15/17] MAINTAINERS: Add STAGING - WINBOND IS89C35 WLAN USB DRIVER
Date: Mon,  7 Jun 2010 11:49:49 -0700
Message-Id: <22eeb83af4fc0a210e9e3837d075faca178a4e74.1275935091.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0605c2..799d37a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5527,6 +5527,11 @@ M:	Forest Bond <forest@alittletooquiet.net>
 S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
+STAGING - WINBOND IS89C35 WLAN USB DRIVER
+M:	Pavel Machek <pavel@ucw.cz>
+S:	Odd Fixes
+F:	drivers/staging/winbond/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

