Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1FUUYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:24:16 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54126 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755039Ab1FUUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:24:15 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [PATCH] staging: ft1000-pcmcia: fix compilation with FT_DEBUG enabled
Date: Tue, 21 Jun 2011 22:24:03 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106212224.05504.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete DEBUG statement that prevents compilation with FT_DEBUG enabled.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -266,8 +266,6 @@ static int ft1000_suspend(struct pcmcia_device *link)
 {
 	struct net_device *dev = ((local_info_t *) link->priv)->dev;
 
-	DEBUG(1, "ft1000_cs: ft1000_event(0x%06x)\n", event);
-
 	if (link->open)
 		netif_device_detach(dev);
 	return 0;


-- 
Ondrej Zary
