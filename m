Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2FUC1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:27:52 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:22619 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2FUC1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:27:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1340245669!12036188!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/12] staging: comedi: s626: remove private INLINE macro
Date: Wed, 20 Jun 2012 19:27:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201927.44202.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The INLINE macro is not used in the code. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.h b/drivers/staging/comedi/drivers/s626.h
index 82de03f..1796236 100644
--- a/drivers/staging/comedi/drivers/s626.h
+++ b/drivers/staging/comedi/drivers/s626.h
@@ -70,10 +70,6 @@
 #define FALSE   (0)
 #endif
 
-#if !defined(INLINE)
-#define INLINE static __inline
-#endif
-
 #include<linux/slab.h>
 
 #define S626_SIZE 0x0200
-- 
1.7.11

