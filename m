Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab1CZAQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:16:15 -0400
Received: from kroah.org ([198.145.64.141]:41831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab1CYXwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:12 2011
Message-Id: <20110325234512.246744140@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier@gentoo.org>
Subject: [42/63] usb: musb: blackfin: fix typo in new dev_pm_ops struct
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Liu <lliubbo@gmail.com>

commit 8f7e7b87ec7c3202941ef2770bacd353ab93368b upstream.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/blackfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -540,7 +540,7 @@ static struct dev_pm_ops bfin_pm_ops = {
 	.resume		= bfin_resume,
 };
 
-#define DEV_PM_OPS	&bfin_pm_op,
+#define DEV_PM_OPS	&bfin_pm_ops
 #else
 #define DEV_PM_OPS	NULL
 #endif


