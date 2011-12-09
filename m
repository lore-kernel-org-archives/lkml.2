Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1LIINW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:13:22 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48696 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751710Ab1LIINT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:13:19 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/8] MAINTAINERS: tm6000: Update F: patterns
Date: Fri,  9 Dec 2011 00:12:48 -0800
Message-Id: <c161ff9b75651d9da542fa657bc282ea25c508c5.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit be30497085080 ("[media] move tm6000 to drivers/media/video")
move the files, update the F: pattern.

CC: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 04fb68c..149c676 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6375,11 +6375,6 @@ M:	Omar Ramirez Luna <omar.ramirez@ti.com>
 S:	Odd Fixes
 F:	drivers/staging/tidspbridge/
 
-STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
-L:	linux-media@vger.kernel.org
-S:	Odd Fixes
-F:	drivers/staging/tm6000/
-
 STAGING - USB ENE SM/MS CARD READER DRIVER
 M:	Al Cho <acho@novell.com>
 S:	Odd Fixes
@@ -6634,6 +6629,11 @@ F:	include/linux/trace*.h
 F:	include/trace/
 F:	kernel/trace/
 
+TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/video/tm6000/
+
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
-- 
1.7.8.111.gad25c.dirty

