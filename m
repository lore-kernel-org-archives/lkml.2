Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2AWXu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:50:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2AWXuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:30 2012
Message-Id: <20120123234029.931430744@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dirk Eibach <eibach@gdsys.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [82/90] net: Fix driver name for mdio-gpio.c
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Eibach <eibach@gdsys.de>

commit f42af6c486aa5ca6ee62800cb45c5b252020509d upstream.

Since commit
"7488876... dt/net: Eliminate users of of_platform_{,un}register_driver"
there are two platform drivers named "mdio-gpio" registered.
I renamed the of variant to "mdio-ofgpio".

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/phy/mdio-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -241,7 +241,7 @@ MODULE_DEVICE_TABLE(of, mdio_ofgpio_matc
 
 static struct platform_driver mdio_ofgpio_driver = {
 	.driver = {
-		.name = "mdio-gpio",
+		.name = "mdio-ofgpio",
 		.owner = THIS_MODULE,
 		.of_match_table = mdio_ofgpio_match,
 	},


