Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab1FWXOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:14:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:38480 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895Ab1FWXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:14:38 -0400
Date: Fri, 24 Jun 2011 01:05:44 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/37] Remove unneeded version.h includes from
 drivers/staging/wlags49_h2/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240104220.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/wlags49_h2/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/wlags49_h2/wl_internal.h |    1 -
 drivers/staging/wlags49_h2/wl_version.h  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index cd129b3..a90c728 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -67,7 +67,6 @@
 /*******************************************************************************
  *  include files
  ******************************************************************************/
-#include <linux/version.h>
 #ifdef BUS_PCMCIA
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/staging/wlags49_h2/wl_version.h b/drivers/staging/wlags49_h2/wl_version.h
index a5e604c..a5faada 100644
--- a/drivers/staging/wlags49_h2/wl_version.h
+++ b/drivers/staging/wlags49_h2/wl_version.h
@@ -66,7 +66,6 @@
  *  include files
  ******************************************************************************/
 //#include <linux/config.h>
-#include <linux/version.h>
 
 #ifndef CONFIG_MODVERSIONS
 #define __NO_VERSION__
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

