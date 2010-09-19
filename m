Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0ISXLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:11:07 -0400
Received: from mail.perches.com ([173.55.12.10]:2130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab0ISXKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:10:37 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 5/6] MAINTAINERS: Remove USB OV511 DRIVER
Date: Sun, 19 Sep 2010 16:10:33 -0700
Message-Id: <635c8d639054e6497097a40fee080857b1ba39d0.1284937055.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284937055.git.joe@perches.com>
References: <cover.1284937055.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed by commit 7373ab3669aec93f8c8f1ace7845c41d54ed6e3e

CC: Amerigo Wang <amwang@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5011ac4..01cc1e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6021,13 +6021,6 @@ L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/option.c
 
-USB OV511 DRIVER
-M:	Mark McClelland <mmcclell@bigfoot.com>
-L:	linux-usb@vger.kernel.org
-W:	http://alpha.dyndns.org/ov511/
-S:	Maintained
-F:	drivers/media/video/ov511.*
-
 USB PEGASUS DRIVER
 M:	Petko Manolov <petkan@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
-- 
1.7.3.rc1

