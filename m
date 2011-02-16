Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1BPAlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:41:37 -0500
Received: from kroah.org ([198.145.64.141]:49447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab1BPAXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:44 2011
Message-Id: <20110216001444.433367698@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [193/272] n_gsm: copy mtu over when configuring via ioctl interface
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ken Mills <ken.k.mills@intel.com>

commit 91f78f36694b8748fda855b1f9e3614b027a744f upstream.

This field is settable but did not get copied.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/n_gsm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2375,6 +2375,7 @@ static int gsmld_config(struct tty_struc
 
 	gsm->initiator = c->initiator;
 	gsm->mru = c->mru;
+	gsm->mtu = c->mtu;
 	gsm->encoding = c->encapsulation;
 	gsm->adaption = c->adaption;
 	gsm->n2 = c->n2;


