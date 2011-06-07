Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1FGC5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 22:57:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41318 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab1FGC5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 22:57:31 -0400
Date: Tue, 7 Jun 2011 12:57:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the gpio tree with the slave-dma tree
Message-Id: <20110607125723.8e591e42.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
arch/arm/mach-ep93xx/Makefile between commit 8e4a93008db7 ("ep93xx:
remove the old M2P DMA code") from the slave-dma tree and commit
c6b52c13de44 ("gpio/ep93xx: move driver to drivers/gpio") from the gpio
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ep93xx/Makefile
index 21e721a,6b7c41d..0000000
--- a/arch/arm/mach-ep93xx/Makefile
+++ b/arch/arm/mach-ep93xx/Makefile
@@@ -1,7 -1,7 +1,7 @@@
  #
  # Makefile for the linux kernel.
  #
- obj-y			:= core.o clock.o gpio.o
 -obj-y			:= core.o clock.o dma-m2p.o
++obj-y			:= core.o clock.o
  obj-m			:=
  obj-n			:=
  obj-			:=
