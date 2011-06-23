Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380Ab1FWXAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:00:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25023 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab1FWXAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:00:07 -0400
Date: Fri, 24 Jun 2011 00:51:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Mike Thomas <rmthomas@sciolus.org>
Subject: [PATCH 25/37] Remove unneeded version.h includes (and add where
 needed) for drivers/staging/easycap/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240050160.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that linux/version.h was not
always being included where needed and sometimes included needlessly
in drivers/staging/easycap/.
This patch fixes up the includes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/easycap/easycap.h       |    1 -
 drivers/staging/easycap/easycap_ioctl.c |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/easycap/easycap.h
index 1f94e23..efbd61b 100644
--- a/drivers/staging/easycap/easycap.h
+++ b/drivers/staging/easycap/easycap.h
@@ -62,7 +62,6 @@
 #include <linux/uaccess.h>
 
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/easycap/easycap_ioctl.c b/drivers/staging/easycap/easycap_ioctl.c
index b3bd11d..f767f2e 100644
--- a/drivers/staging/easycap/easycap_ioctl.c
+++ b/drivers/staging/easycap/easycap_ioctl.c
@@ -25,6 +25,7 @@
 */
 /*****************************************************************************/
 
+#include <linux/version.h>
 #include "easycap.h"
 
 /*--------------------------------------------------------------------------*/
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

