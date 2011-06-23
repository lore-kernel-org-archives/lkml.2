Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141Ab1FWXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:09:19 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25306 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab1FWXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:09:19 -0400
Date: Fri, 24 Jun 2011 01:00:24 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org, wei_wang@realsil.com.cn,
        Alexander Beregalov <a.beregalov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/37] Remove unneeded version.h include from
 drivers/staging/rts_pstor/rtsx.h
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240059320.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that include of
linux/version.h is not needed in drivers/staging/rts_pstor/rtsx.h
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/rts_pstor/rtsx.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.h b/drivers/staging/rts_pstor/rtsx.h
index 6afb635..247615b 100644
--- a/drivers/staging/rts_pstor/rtsx.h
+++ b/drivers/staging/rts_pstor/rtsx.h
@@ -29,7 +29,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

