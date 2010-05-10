Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab0EJXAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:00:42 -0400
Received: from kroah.org ([198.145.64.141]:51716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874Ab0EJW55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:57 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:37 2010
Message-Id: <20100510223537.926247838@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ping Cheng <pingc@wacom.com>
Subject: [39/98] serial: 8250_pnp - add Fujitsu Wacom device
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ping Cheng <pingc@wacom.com>

commit d9901660b53b92f0f3551c06588b8be38224b245 upstream.

Add Fujitsu Wacom 1FGT Tablet PC device

Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -348,6 +348,8 @@ static const struct pnp_device_id pnp_de
 	{	"FUJ02E6",		0	},
 	/* Fujitsu Wacom 2FGT Tablet PC device */
 	{	"FUJ02E7",		0	},
+	/* Fujitsu Wacom 1FGT Tablet PC device */
+	{	"FUJ02E9",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
 	 * disguise)


