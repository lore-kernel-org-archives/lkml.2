Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1BWFmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:42:35 -0500
Received: from mail.perches.com ([173.55.12.10]:3856 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1BWFme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:34 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeroen Vreeken <pe1rxq@amsat.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 17/18] MAINTAINERS: USB SE401 moved to staging, update pattern
Date: Tue, 22 Feb 2011 21:42:10 -0800
Message-Id: <b71216322abdb099ca0fc5a5fa997fa03ed773d0.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And set the status to Orphan.

cc: Jeroen Vreeken <pe1rxq@amsat.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cdab39b..2b4dfa4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6420,12 +6420,11 @@ S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
 USB SE401 DRIVER
-M:	Jeroen Vreeken <pe1rxq@amsat.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Maintained
+S:	Orphan
 F:	Documentation/video4linux/se401.txt
-F:	drivers/media/video/se401.*
+F:	drivers/staging/se401/
 
 USB SERIAL BELKIN F5U103 DRIVER
 M:	William Greathouse <wgreathouse@smva.com>
-- 
1.7.4.rc3

