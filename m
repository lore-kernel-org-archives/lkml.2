Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2LRWHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:07:11 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:36437 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab2LRWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:07:08 -0500
Date: Tue, 18 Dec 2012 23:07:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        trivial@kernel.org
Subject: [PATCH] bq2415x_charger: Remove unneeded version.h include
Message-ID: <alpine.LNX.2.00.1212182305220.14788@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file uses nothing from the header, so including it is pointless.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/power/bq2415x_charger.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index ee842b3..2d1b568 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -28,7 +28,6 @@
  * http://www.ti.com/product/bq24155
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/param.h>
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

