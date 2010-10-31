Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0JaWeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:34:36 -0400
Received: from mail.perches.com ([173.55.12.10]:3904 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab0JaWeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:34:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 3/4] drivers/staging/udlfb/udlfb.c: Fix k.alloc switched arguments
Date: Sun, 31 Oct 2010 15:33:55 -0700
Message-Id: <3fafd904076a9bb1f871b2f7b9c5ac07abc72cf7.1288555098.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288555098.git.joe@perches.com>
References: <cover.1288555098.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/udlfb/udlfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/udlfb/udlfb.c b/drivers/staging/udlfb/udlfb.c
index 5969e84..fed2510 100644
--- a/drivers/staging/udlfb/udlfb.c
+++ b/drivers/staging/udlfb/udlfb.c
@@ -887,7 +887,7 @@ static int dlfb_ops_open(struct fb_info *info, int user)
 
 		struct fb_deferred_io *fbdefio;
 
-		fbdefio = kmalloc(GFP_KERNEL, sizeof(struct fb_deferred_io));
+		fbdefio = kmalloc(sizeof(struct fb_deferred_io), GFP_KERNEL);
 
 		if (fbdefio) {
 			fbdefio->delay = DL_DEFIO_WRITE_DELAY;
-- 
1.7.3.1.g432b3.dirty

