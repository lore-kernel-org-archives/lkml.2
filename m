Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0HWJ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:59:53 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57004 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab0HWJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:59:51 -0400
Date: Mon, 23 Aug 2010 11:59:48 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/2] drivers/video: Removing dead FB_68328_INVERT config
 option
Message-ID: <3f81ddc3e70dad3b1c162440b5d3d93a5c754d09.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FB_68328_INVERT doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/video/68328fb.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/video/68328fb.c b/drivers/video/68328fb.c
index 75a39ea..bec3fd2 100644
--- a/drivers/video/68328fb.c
+++ b/drivers/video/68328fb.c
@@ -49,11 +49,7 @@
 #error wrong architecture for the MC68x328 frame buffer device
 #endif
 
-#if defined(CONFIG_FB_68328_INVERT)
-#define MC68X328FB_MONO_VISUAL FB_VISUAL_MONO01
-#else
 #define MC68X328FB_MONO_VISUAL FB_VISUAL_MONO10
-#endif
 
 static u_long videomemory;
 static u_long videomemorysize;
-- 
1.7.0.4

