Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0ISXLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:11:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2131 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab0ISXKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:10:37 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 6/6] MAINTAINERS: Remove USB ZC0301 DRIVER
Date: Sun, 19 Sep 2010 16:10:34 -0700
Message-Id: <21eb0d73a9045e6d91c40793b98894e5ae176a2a.1284937055.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284937055.git.joe@perches.com>
References: <cover.1284937055.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed by commit 0d58cef664e01fb1848833455bfdbe1a3d91044c

CC: Amerigo Wang <amwang@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 01cc1e2..34337b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6181,16 +6181,6 @@ S:	Supported
 F:	drivers/usb/host/xhci*
 F:	drivers/usb/host/pci-quirks*
 
-USB ZC0301 DRIVER
-M:	Luca Risolia <luca.risolia@studio.unibo.it>
-L:	linux-usb@vger.kernel.org
-L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
-W:	http://www.linux-projects.org
-S:	Maintained
-F:	Documentation/video4linux/zc0301.txt
-F:	drivers/media/video/zc0301/
-
 USB ZD1201 DRIVER
 L:	linux-wireless@vger.kernel.org
 W:	http://linux-lc100020.sourceforge.net
-- 
1.7.3.rc1

