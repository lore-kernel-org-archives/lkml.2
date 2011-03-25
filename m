Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab1CZAP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:15:58 -0400
Received: from kroah.org ([198.145.64.141]:41837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab1CYXwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:12 2011
Message-Id: <20110325234512.346322245@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Frysinger <vapier@gentoo.org>
Subject: [43/63] usb: musb: blackfin: fix typo in new bfin_musb_vbus_status func
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 45567c28d29a8766a67c53f898d502aef71b7ef0 upstream.

The common code has a "get" in the middle, but each implementation
does not have it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/blackfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -322,7 +322,7 @@ static void bfin_musb_try_idle(struct mu
 		mod_timer(&musb_conn_timer, jiffies + TIMER_DELAY);
 }
 
-static int bfin_musb_get_vbus_status(struct musb *musb)
+static int bfin_musb_vbus_status(struct musb *musb)
 {
 	return 0;
 }


