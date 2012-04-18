Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2DREe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:34:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60385 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2DREeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:34:23 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: [PATCH 09/12] drivers: staging: media: as102: as102_usb_drv.h: Remove include of version.h
Date: Wed, 18 Apr 2012 01:30:09 -0300
Message-Id: <1334723412-5034-10-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" told us that:

drivers/staging/media/as102/as102_usb_drv.h: 20 linux/version.h not
needed.

If we take a look at the code, we can agree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-media@vger.kernel.org>
Cc: <devel@driverdev.osuosl.org >
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/media/as102/as102_usb_drv.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index fc2884a..1ad1ec5 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#include <linux/version.h>
-
 #ifndef _AS102_USB_DRV_H_
 #define _AS102_USB_DRV_H_
 
-- 
1.7.7.6

