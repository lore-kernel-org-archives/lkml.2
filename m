Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0EJUIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:08:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab0EJUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uP55Xj/jrGMYy2PfsJ7w4iRBZYmiGaLmp6fqA3bu8fuTN2oQlBhZ89+K87NZyIq7Em
         D3sD4k4Sdux4jUr5/LJuFKnq/hlZ3VBSt0myyPDKGMnGXIHbkym6hOJ/c0aZbXcvJvS/
         XkvSABbHoOodlBel7mapP+UPgxejrfjksKTIE=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: paulius.zaleckas@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH 4/4] MAINTAINERS: update for ARM/Gemini
Date: Mon, 10 May 2010 22:07:01 +0200
Message-Id: <1273522021-14436-5-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
References: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 MAINTAINERS |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 449d444..8a0fe7f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -620,10 +620,10 @@ M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
-M:	Paulius Zaleckas <paulius.zaleckas@gmail.com>
+M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-T:	git git://gitorious.org/linux-gemini/mainline.git
-S:	Odd Fixes
+T:	git git://git.berlios.de/gemini-board
+S:	Maintained
 F:	arch/arm/mach-gemini/
 
 ARM/EBSA110 MACHINE SUPPORT
@@ -645,9 +645,10 @@ T:	topgit git://git.openezx.org/openezx.git
 F:	arch/arm/mach-pxa/ezx.c
 
 ARM/FARADAY FA526 PORT
-M:	Paulius Zaleckas <paulius.zaleckas@gmail.com>
+M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Odd Fixes
+S:	Maintained
+T:	git://git.berlios.de/gemini-board
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
-- 
1.7.0.3

