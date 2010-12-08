Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab0LHBDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:06 -0500
Received: from kroah.org ([198.145.64.141]:33573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab0LHBC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:59 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:41 2010
Message-Id: <20101208005741.874807808@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Brownell <dbrownell@users.sourceforge.net>,
        Stefan Weil <weil@mail.berlios.de>
Subject: [204/289] USB: ohci-jz4740: Fix spelling in MODULE_ALIAS
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Weil <weil@mail.berlios.de>

commit 1c0a38038e8fcfaa6b5a81d53a4898f3f939f582 upstream.

platfrom -> platform

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-jz4740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-jz4740.c
+++ b/drivers/usb/host/ohci-jz4740.c
@@ -273,4 +273,4 @@ static struct platform_driver ohci_hcd_j
 	},
 };
 
-MODULE_ALIAS("platfrom:jz4740-ohci");
+MODULE_ALIAS("platform:jz4740-ohci");


