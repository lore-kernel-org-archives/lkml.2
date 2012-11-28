Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2K1Oj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:39:59 -0500
Received: from hhlx01.visionsystems.de ([62.145.30.242]:38013 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab2K1Oj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:39:58 -0500
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 09:39:57 EST
From: yegorslists@googlemail.com
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, FlorianSchandinat@gmx.de,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] modedb.txt: fix modedb.c path
Date: Wed, 28 Nov 2012 15:15:50 +0100
Message-Id: <1354112150-18974-1-git-send-email-yegorslists@googlemail.com>
X-Mailer: git-send-email 1.7.7
X-OriginalArrivalTime: 28 Nov 2012 14:16:00.0635 (UTC) FILETIME=[E47374B0:01CDCD72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Remove "linux" in modedb.c path, otherwise such editors as
vi won't be able to jump to this file.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/fb/modedb.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/fb/modedb.txt b/Documentation/fb/modedb.txt
index 16aa084..683db79 100644
--- a/Documentation/fb/modedb.txt
+++ b/Documentation/fb/modedb.txt
@@ -131,7 +131,7 @@ To specify a video mode at bootup, use the following boot options:
     video=<driver>:<xres>x<yres>[-<bpp>][@refresh]
 
 where <driver> is a name from the table below.  Valid default modes can be
-found in linux/drivers/video/modedb.c.  Check your driver's documentation.
+found in drivers/video/modedb.c.  Check your driver's documentation.
 There may be more modes.
 
     Drivers that support modedb boot options
-- 
1.7.7

