Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1CZAQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:16:44 -0400
Received: from kroah.org ([198.145.64.141]:41821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab1CYXwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:12 2011
Message-Id: <20110325234512.154456710@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Frysinger <vapier@gentoo.org>
Subject: [41/63] usb: musb: blackfin: fix typo in platform driver name
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 417ddf86c8c499fada439b8ee89bb4c6f282ed6c upstream.

The modularization of the Blackfin driver set the name to "musb-blackfin"
in all the boards, but "musb-bfin" in the driver itself.  Since the driver
file name uses "blackfin", change the driver to "musb-blackfin".  This is
also easier as it's only one file to change.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/blackfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -548,7 +548,7 @@ static struct dev_pm_ops bfin_pm_ops = {
 static struct platform_driver bfin_driver = {
 	.remove		= __exit_p(bfin_remove),
 	.driver		= {
-		.name	= "musb-bfin",
+		.name	= "musb-blackfin",
 		.pm	= DEV_PM_OPS,
 	},
 };


