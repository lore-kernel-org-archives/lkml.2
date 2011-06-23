Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab1FWWTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:19:34 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24079 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849Ab1FWWTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:19:32 -0400
Date: Fri, 24 Jun 2011 00:10:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Mike Frysinger <vapier@gentoo.org>,
        device-drivers-devel@blackfin.uclinux.org, linux-input@vger.kernel.org
Subject: [PATCH 09/37] Remove unneeded version.h includes from
 drivers/input/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240009201.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/input/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/input/keyboard/adp5588-keys.c |    1 -
 drivers/input/keyboard/adp5589-keys.c |    1 -
 drivers/input/misc/bfin_rotary.c      |    1 -
 drivers/input/mouse/pxa930_trkball.c  |    1 -
 drivers/input/mouse/sentelic.c        |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index af45d27..7b404e5 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 6315986..c770826 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
index 4f72bdd..d00edc9 100644
--- a/drivers/input/misc/bfin_rotary.c
+++ b/drivers/input/misc/bfin_rotary.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/input/mouse/pxa930_trkball.c b/drivers/input/mouse/pxa930_trkball.c
index 943cfec..6c5d84f 100644
--- a/drivers/input/mouse/pxa930_trkball.c
+++ b/drivers/input/mouse/pxa930_trkball.c
@@ -12,7 +12,6 @@
 
 #include <linux/init.h>
 #include <linux/input.h>
-#include <linux/version.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 1242775..2fc887a 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/input.h>
 #include <linux/ctype.h>
 #include <linux/libps2.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

