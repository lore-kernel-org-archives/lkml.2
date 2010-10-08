Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab0JHT3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:29:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52505 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556Ab0JHT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P8nPEmT1hlkPo/Px65iukED02X9waInNIbbernT+ocXYk6On2Ml+xwt+jQ0hdQtGSa
         LvBK+oRyvLmpyqzeM/Wm168EcYpX3R/pk1z0+0QRFse6smDbrtSpGGSPFhqJIbg3+HMY
         WTosHmlRBhYXdIf4tlvn/QV0yWeEmmd+TZgvw=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 1/6] MAINTAINERS: Coccinelle: Update email address
Date: Fri,  8 Oct 2010 21:27:36 +0200
Message-Id: <1286566061-17122-2-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update my email address

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4f9e41..146090d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1479,7 +1479,7 @@ F:	drivers/platform/x86/classmate-laptop.c
 COCCINELLE/Semantic Patches (SmPL)
 M:	Julia Lawall <julia@diku.dk>
 M:	Gilles Muller <Gilles.Muller@lip6.fr>
-M:	Nicolas Palix <npalix@diku.dk>
+M:	Nicolas Palix <npalix.work@gmail.com>
 L:	cocci@diku.dk (moderated for non-subscribers)
 W:	http://coccinelle.lip6.fr/
 S:	Supported
-- 
1.7.0.4

