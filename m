Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0JHAJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:09:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0JHACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PjM9By8JU7RkxDZD6IqInAPFWwYRBA+cTJCKO+UVdVV0WdlL1nFiUwQutP+MhRSBMb
         3+yOkPrtSsN4EHfJE0uX2B2Cn7c+guNYDzIAP9xKw/yNaIWXIMGlqKlYPILFflGgh2h2
         faPFEvzsD+U7hYVHsgrGB0NW/yZtig8v49XR4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 06/33] Staging: cx25821: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:26 -0400
Message-Id: <1286496113-11897-6-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cx25821/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
index 6448364..aedde18 100644
--- a/drivers/staging/cx25821/Makefile
+++ b/drivers/staging/cx25821/Makefile
@@ -1,4 +1,4 @@
-cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
+cx25821-y   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 		       cx25821-gpio.o cx25821-medusa-video.o \
 		       cx25821-video.o cx25821-video-upstream.o \
 		       cx25821-video-upstream-ch2.o \
-- 
1.7.3.1.50.g1e633

