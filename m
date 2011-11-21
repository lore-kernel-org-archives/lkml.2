Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1KUUyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:54:33 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:53697 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1KUUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/8] fbdev/amifb: Make amifb_setup() static
Date: Mon, 21 Nov 2011 21:53:55 +0100
Message-Id: <1321908839-11419-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
References: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index d7961bd..d3847e7 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2363,7 +2363,7 @@ static void __init amifb_setup_mcap(char *spec)
 	fb_info.monspecs.hfmax = hmax;
 }
 
-int __init amifb_setup(char *options)
+static int __init amifb_setup(char *options)
 {
 	char *this_opt;
 
-- 
1.7.0.4

