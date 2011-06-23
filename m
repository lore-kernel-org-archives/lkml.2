Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488Ab1FWWvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:51:07 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24762 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457Ab1FWWvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:51:04 -0400
Date: Fri, 24 Jun 2011 00:42:09 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Vipin Mehta <vmehta@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org
Subject: [PATCH 21/37] Remove unneeded version.h includes from
 drivers/staging/ath6kl/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240041051.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/ath6kl/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 .../staging/ath6kl/os/linux/include/config_linux.h |    2 --
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |    2 --
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    1 -
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/config_linux.h b/drivers/staging/ath6kl/os/linux/include/config_linux.h
index d4030e2..dbbe1a0 100644
--- a/drivers/staging/ath6kl/os/linux/include/config_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/config_linux.h
@@ -28,8 +28,6 @@
 extern "C" {
 #endif
 
-#include <linux/version.h>
-
 /*
  * Host side Test Command support
  */
diff --git a/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h b/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
index 769a480..e6e96de 100644
--- a/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
+++ b/drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
@@ -24,8 +24,6 @@
 #ifndef _IEEE80211_IOCTL_H_
 #define _IEEE80211_IOCTL_H_
 
-#include <linux/version.h>
-
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index 07078b4..41f4373 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -29,7 +29,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

