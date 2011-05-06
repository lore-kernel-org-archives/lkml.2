Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1EFA5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:57:43 -0400
Received: from kroah.org ([198.145.64.141]:36755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab1EFAYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.752978482@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [046/143] pcnet-cs: declare MODULE_FIRMWARE
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 8489992e723b5def1a807e615854f51b75d10600 upstream.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/pcmcia/pcnet_cs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -1768,6 +1768,13 @@ static struct pcmcia_device_id pcnet_ids
 	PCMCIA_DEVICE_NULL
 };
 MODULE_DEVICE_TABLE(pcmcia, pcnet_ids);
+MODULE_FIRMWARE("cis/PCMLM28.cis");
+MODULE_FIRMWARE("cis/DP83903.cis");
+MODULE_FIRMWARE("cis/LA-PCM.cis");
+MODULE_FIRMWARE("PE520.cis");
+MODULE_FIRMWARE("cis/NE2K.cis");
+MODULE_FIRMWARE("cis/PE-200.cis");
+MODULE_FIRMWARE("cis/tamarack.cis");
 
 static struct pcmcia_driver pcnet_driver = {
 	.drv		= {


