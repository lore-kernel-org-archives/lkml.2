Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935157Ab0GPBPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:15:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57521 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935038Ab0GPBPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:15:23 -0400
Date: Fri, 16 Jul 2010 11:15:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: manual merge of the devicetree tree with Linus' tree
Message-Id: <20100716111520.732bd29a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/sparc/kernel/prom_64.c between commit
95f72d1ed41a66f1c1c29c24d479de81a0bea36f ("lmb: rename to memblock") from
Linus' tree and commit 035ebefc737cce56d3938e9b7eaa5ac0e9c28715
("of/sparc: move is_root_node() to of.h") from the devicetree tree.

Just context changes. I fixed it up (see below) and can carry the fix for
a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/kernel/prom_64.c
index 466a327,0bffafd..0000000
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@@ -20,8 -20,8 +20,8 @@@
  #include <linux/string.h>
  #include <linux/mm.h>
  #include <linux/module.h>
 -#include <linux/lmb.h>
 +#include <linux/memblock.h>
- #include <linux/of_device.h>
+ #include <linux/of.h>
  
  #include <asm/prom.h>
  #include <asm/oplib.h>
