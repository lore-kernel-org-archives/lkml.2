Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2ACWll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab2ACWli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:23 2012
Message-Id: <20120103223323.437876252@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gary Thomas <gary@mlbassoc.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [29/75] media: omap_vout: Fix compile error in 3.1
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Thomas <gary@mlbassoc.com>

commit d1ee8878a142f81ea1b40d602c6360b752829437 upstream.

This patch is against the mainline v3.1 release (c3b92c8) and
fixes a compile error when building for OMAP3+DSS+VOUT

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gary Thomas <gary@mlbassoc.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/omap/omap_vout.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -38,6 +38,7 @@
 #include <linux/irq.h>
 #include <linux/videodev2.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>


