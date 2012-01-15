Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2AOU0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:26:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23787 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2AOU0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:26:48 -0500
Date: Sun, 15 Jan 2012 21:26:46 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Samuel Ortiz <sameo@linux.intel.com>, trivial@kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>
Subject: [PATCH] Don't needlessly include linux/version.h in
 drivers/mfd/ab5500-core.c
Message-ID: <alpine.LNX.2.00.1201152124260.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 'make versioncheck' so nicely points out, there's no need for
drivers/mfd/ab5500-core.c to #include the linux/version.h header.
This patch removes the pointless include.

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
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

