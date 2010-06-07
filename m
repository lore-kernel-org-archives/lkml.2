Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0FGSuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2724 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab0FGSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:09 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH 17/17] MAINTAINERS: Add STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
Date: Mon,  7 Jun 2010 11:49:51 -0700
Message-Id: <fa17bce48f9c93e110bc28ae2fa03890f963c908.1275935091.git.joe@perches.com>
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
index bf83c28..3b6dd20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5538,6 +5538,11 @@ M:	Pavel Machek <pavel@ucw.cz>
 S:	Odd Fixes
 F:	drivers/staging/winbond/
 
+STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
+M:	Arnaud Patard <apatard@mandriva.com>
+S:	Odd Fixes
+F:	drivers/staging/xgifb/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

