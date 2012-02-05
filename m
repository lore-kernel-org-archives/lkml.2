Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2BEAbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:31:36 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10874 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2BEAbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:31:36 -0500
Date: Sun, 5 Feb 2012 01:32:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Axel Lin <axel.lin@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] power, max8998: Include linux/module.h just once in
 drivers/power/max8998_charger.c
Message-ID: <alpine.LNX.2.00.1202050130210.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/power/max8998_charger.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
index 9b3f2bf..5c5f281 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

