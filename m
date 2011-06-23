Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab1FWWlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:41:49 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24551 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab1FWWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:41:47 -0400
Date: Fri, 24 Jun 2011 00:32:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, linux-usb@vger.kernel.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: [PATCH 17/37] Remove unneeded version.h include from drivers/uwb/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240031470.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that a include of
linux/version.h is not needed in drivers/uwb/uwb-internal.h .
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/uwb/uwb-internal.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/uwb-internal.h b/drivers/uwb/uwb-internal.h
index 157485c..a7494bf 100644
--- a/drivers/uwb/uwb-internal.h
+++ b/drivers/uwb/uwb-internal.h
@@ -28,7 +28,6 @@
 #ifndef __UWB_INTERNAL_H__
 #define __UWB_INTERNAL_H__
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/uwb.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

