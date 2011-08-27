Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1H0TOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 15:14:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47473 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751357Ab1H0TN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 15:13:59 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18wvXxpGLYwTXXYrhkoPlUhxwUflkHlvo2P2fRCQb
	sVgY8TX3TyOTvj
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] MAINTAINERS: change framebuffer maintainer
Date: Sat, 27 Aug 2011 19:32:34 +0000
Message-Id: <1314473554-3317-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4E4A1AB1.6040001@gmx.de>
References: <4E4A1AB1.6040001@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Paul has not much time for it I take over maintaining the
framebuffer subsystem.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d445f5..ac7e485 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2649,11 +2649,11 @@ F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
 FRAMEBUFFER LAYER
-M:	Paul Mundt <lethal@linux-sh.org>
+M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
 L:	linux-fbdev@vger.kernel.org
 W:	http://linux-fbdev.sourceforge.net/
 Q:	http://patchwork.kernel.org/project/linux-fbdev/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git
+T:	git git://github.com/schandinat/linux-2.6.git fbdev-next
 S:	Maintained
 F:	Documentation/fb/
 F:	Documentation/devicetree/bindings/fb/
-- 
1.6.3.2

