Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1FAR7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:59:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2387 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab1FAR7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:59:22 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 6/6] MAINTAINERS: Remove section USB SE401 DRIVER
Date: Wed,  1 Jun 2011 10:59:14 -0700
Message-Id: <bdd0f9aac1146797b4be3f5c2c62066df6a166c1.1306950701.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306950701.git.joe@perches.com>
References: <cover.1306950701.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b287db119edb ("[media] se401: remove last V4L1 driver")
removed the driver, so remove the section from MAINTAINERS.

cc: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 49d9fb1..07b6bcd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6524,13 +6524,6 @@ W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
-USB SE401 DRIVER
-L:	linux-usb@vger.kernel.org
-W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Orphan
-F:	Documentation/video4linux/se401.txt
-F:	drivers/staging/se401/
-
 USB SERIAL BELKIN F5U103 DRIVER
 M:	William Greathouse <wgreathouse@smva.com>
 L:	linux-usb@vger.kernel.org
-- 
1.7.5.rc3.dirty

