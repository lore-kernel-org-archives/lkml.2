Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab1FWXKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:10:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25352 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab1FWXKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:10:45 -0400
Date: Fri, 24 Jun 2011 01:01:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Christopher Brannon <chris@the-brannons.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 32/37] Remove unneeded version.h includes from
 drivers/staging/speakup/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240100290.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/speakup/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/speakup/main.c    |    1 -
 drivers/staging/speakup/speakup.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 42fcf7e..8be5604 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -23,7 +23,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/vt.h>
 #include <linux/tty.h>
 #include <linux/mm.h>		/* __get_free_page() and friends */
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
index 46edabe..412b879 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -1,6 +1,5 @@
 #ifndef _SPEAKUP_H
 #define _SPEAKUP_H
-#include <linux/version.h>
 
 #include "spk_types.h"
 #include "i18n.h"
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

