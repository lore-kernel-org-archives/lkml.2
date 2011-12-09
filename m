Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1LIINQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:13:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43749 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751710Ab1LIINK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:13:10 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/8] MAINTAINERS: staging: media: Update F: patterns
Date: Fri,  9 Dec 2011 00:12:47 -0800
Message-Id: <f0af8da0b1955d23ae18b4f9bf3d57665cef6c43.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4860c73804c ("staging: Move media drivers to staging/media")
moved the files, update the F: patterns.

CC: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2173f6b..04fb68c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6322,7 +6322,7 @@ STAGING - LIRC (LINUX INFRARED REMOTE CONTROL) DRIVERS
 M:	Jarod Wilson <jarod@wilsonet.com>
 W:	http://www.lirc.org/
 S:	Odd Fixes
-F:	drivers/staging/lirc/
+F:	drivers/staging/media/lirc/
 
 STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
 M:	Julian Andres Klode <jak@jak-linux.org>
@@ -6358,7 +6358,7 @@ F:	drivers/staging/sm7xx/
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
 M:	Ben Collins <bcollins@bluecherry.net>
 S:	Odd Fixes
-F:	drivers/staging/solo6x10/
+F:	drivers/staging/media/solo6x10/
 
 STAGING - SPEAKUP CONSOLE SPEECH DRIVER
 M:	William Hubbs <w.d.hubbs@gmail.com>
-- 
1.7.8.111.gad25c.dirty

