Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0LMAXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:23:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44856 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab0LLXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:49 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: ken_kawasaki@spring.nifty.jp, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [51/223] pcnet_cs: add new_id
Message-Id: <20101212234548.9CEBCB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>

commit 62391f97babb7fe0c769830b6f0e0bd184bd0704 upstream.

pcnet_cs:
    add new_id: "corega Ether CF-TD" 10Base-T PCMCIA card.

Signed-off-by: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/pcmcia/pcnet_cs.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/net/pcmcia/pcnet_cs.c
===================================================================
--- linux.orig/drivers/net/pcmcia/pcnet_cs.c
+++ linux/drivers/net/pcmcia/pcnet_cs.c
@@ -1602,6 +1602,7 @@ static struct pcmcia_device_id pcnet_ids
 	PCMCIA_DEVICE_PROD_ID12("COMPU-SHACK", "FASTline PCMCIA 10/100 Fast-Ethernet", 0xfa2e424d, 0x3953d9b9),
 	PCMCIA_DEVICE_PROD_ID12("CONTEC", "C-NET(PC)C-10L", 0x21cab552, 0xf6f90722),
 	PCMCIA_DEVICE_PROD_ID12("corega", "FEther PCC-TXF", 0x0a21501a, 0xa51564a2),
+	PCMCIA_DEVICE_PROD_ID12("corega", "Ether CF-TD", 0x0a21501a, 0x6589340a),
 	PCMCIA_DEVICE_PROD_ID12("corega K.K.", "corega EtherII PCC-T", 0x5261440f, 0xfa9d85bd),
 	PCMCIA_DEVICE_PROD_ID12("corega K.K.", "corega EtherII PCC-TD", 0x5261440f, 0xc49bd73d),
 	PCMCIA_DEVICE_PROD_ID12("Corega K.K.", "corega EtherII PCC-TD", 0xd4fdcbd8, 0xc49bd73d),
