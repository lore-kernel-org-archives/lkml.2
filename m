Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab0D1GL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:11:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60629 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0D1GLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:11:55 -0400
Date: Wed, 28 Apr 2010 16:11:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: manual merge of the staging-next tree with the pcmcia
 tree
Message-Id: <20100428161153.e683cb12.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/netwave/netwave_cs.c between commit
c8bf6e66c254bba7d0ea3f5d02420776dceac657 ("pcmcia: re-work
pcmcia_request_irq()") from the pcmcia tree and commit
3c7475d0aaad3614f6b1db291310c577eee3fb33 ("Staging: netwave: fixed
trailing whitespace style issue in netwave_cs.c") from the staging-next
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/netwave/netwave_cs.c
index f1ee2cb,7b31621..0000000
--- a/drivers/staging/netwave/netwave_cs.c
+++ b/drivers/staging/netwave/netwave_cs.c
@@@ -377,10 -378,14 +377,10 @@@ static int netwave_probe(struct pcmcia_
      /* The io structure describes IO port mapping */
      link->io.NumPorts1 = 16;
      link->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
-     /* link->io.NumPorts2 = 16; 
+     /* link->io.NumPorts2 = 16;
         link->io.Attributes2 = IO_DATA_PATH_WIDTH_16; */
      link->io.IOAddrLines = 5;
-     
+ 
 -    /* Interrupt setup */
 -    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 -    link->irq.Handler = &netwave_interrupt;
 -
      /* General socket configuration */
      link->conf.Attributes = CONF_ENABLE_IRQ;
      link->conf.IntType = INT_MEMORY_AND_IO;
