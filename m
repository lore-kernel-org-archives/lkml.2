Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab0JGEIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:08:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41345 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0JGEIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:08:39 -0400
Date: Thu, 7 Oct 2010 15:08:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the irqflags tree with Linus' tree
Message-Id: <20101007150835.9e1a49f7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the irqflags tree got a conflict in
arch/mips/kernel/irq-gic.c between commit
863cb9bad8f992a9c171e90552045eac77808e84 ("MIPS: GIC: Remove dependencies
from Malta files") from Linus' tree and commit
9cbb8e371af264699522030ec637c55a58765859 ("MIPS: Add missing #inclusions
of <linux/irq.h>") from the irqflags tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/kernel/irq-gic.c
index 82ba9f6,e0ff05d..0000000
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@@ -7,7 -8,7 +8,6 @@@
  #include <asm/io.h>
  #include <asm/gic.h>
  #include <asm/gcmpregs.h>
- #include <asm/irq.h>
 -#include <asm/mips-boards/maltaint.h>
  #include <linux/hardirq.h>
  #include <asm-generic/bitops/find.h>
  
