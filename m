Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab1FWWwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:52:07 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24812 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933433Ab1FWWwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:52:04 -0400
Date: Fri, 24 Jun 2011 00:43:10 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 22/37] Remove unneeded version.h include from
 drivers/staging/bcm/headers.h
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240042110.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that a include of
linux/version.h is not needed in drivers/staging/bcm/headers.h .
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/bcm/headers.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/bcm/headers.h b/drivers/staging/bcm/headers.h
index 1148e5e..ab0a1db 100644
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@ -25,7 +25,6 @@
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 
-#include <linux/version.h>
 #include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/stat.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

