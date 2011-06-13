Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1FMMTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:19:48 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41838 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1FMMTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:19:45 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 3/5] staging/easycap: There is no need to support V4L1 ioctls
Date: Mon, 13 Jun 2011 16:18:30 +0400
Message-Id: <b086aa757c64aee349cea66cb652f6d4f333b50c.1307967011.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because V4L1 was completly removed from the kernel in 2.6.38. See e.g.

08af245d ([media] V4L: remove V4L1 compatibility mode).

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/staging/easycap/README |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
index cd55eea..08f649d 100644
--- a/drivers/staging/easycap/README
+++ b/drivers/staging/easycap/README
@@ -106,8 +106,6 @@ hardware, but as yet it has actually been tested on only a few of these.
 I have been unable to test and calibrate the S-video input myself because I
 do not possess any equipment with S-video output.
 
-This driver does not understand the V4L1 IOCTL commands.
-
 
 UDEV RULES
 ----------
-- 
1.7.6.rc1

