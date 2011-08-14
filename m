Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1HNUuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:50:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40939 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1HNUuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:50:18 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Marin Mitov <mitov@issp.bas.bg>,
        devel@driverdev.osuosl.org
Subject: [PATCH] dt3155v4l: fix build failure
Date: Sun, 14 Aug 2011 23:52:52 +0300
Message-Id: <1313355177-12605-2-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on allmodconfig build (ARCH=alpha)

    drivers/staging/dt3155v4l/dt3155v4l.c: In function 'dt3155_open':
    drivers/staging/dt3155v4l/dt3155v4l.c:410: error: implicit declaration of function 'kzalloc'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marin Mitov <mitov@issp.bas.bg>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/dt3155v4l/dt3155v4l.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index fe02d22..05aa41c 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -22,6 +22,7 @@
 #include <linux/stringify.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/slab.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-dma-contig.h>
-- 
1.7.3.4

