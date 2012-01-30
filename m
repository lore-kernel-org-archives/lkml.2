Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2A3VI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:08:29 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26955 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2A3VI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:08:28 -0500
Date: Mon, 30 Jan 2012 22:08:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Samuel Ortiz <sameo@linux.intel.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>
Subject: [PATCH] mfd, ab5500: Remove unneeded version.h include
Message-ID: <alpine.LNX.2.00.1201302206480.31586@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 'make versioncheck' points out, there's no need for
drivers/mfd/ab5500-core.c to #include <linux/version.h>, so this patch
removes the unneeded include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mfd/ab5500-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab5500-core.c b/drivers/mfd/ab5500-core.c
index bd56a76..54d0fe4 100644
--- a/drivers/mfd/ab5500-core.c
+++ b/drivers/mfd/ab5500-core.c
@@ -28,7 +28,6 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/mfd/core.h>
-#include <linux/version.h>
 #include <linux/mfd/db5500-prcmu.h>
 
 #include "ab5500-core.h"
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

