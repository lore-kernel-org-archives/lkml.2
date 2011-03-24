Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1CXCGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:06:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47947 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1CXCGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:06:12 -0400
Date: Thu, 24 Mar 2011 13:06:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the alacrity tree with Linus' tree
Message-Id: <20110324130607.520e2edf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

Today's linux-next merge of the alacrity tree got a conflict in
MAINTAINERS between commit 4e850855d747 ("MAINTAINERS: remove SHARP
LH7A40X section") from Linus' tree and commit 86613d42e644 ("shm-signal:
shared-memory signals") from the alacrity tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

Is this stuff ever going to be merged into Linus' tree?  It is based on
v2.6.34 and the last change was in May, 2010.  If you have given up on it,
I need to remove it from linux-next.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 749f9cd,5268733..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -3406,10 -2990,16 +3406,16 @@@ F:	drivers/net/ioc3-eth.
  
  IOC3 SERIAL DRIVER
  M:	Pat Gefre <pfg@sgi.com>
 -L:	linux-mips@linux-mips.org
 +L:	linux-serial@vger.kernel.org
  S:	Maintained
 -F:	drivers/serial/ioc3_serial.c
 +F:	drivers/tty/serial/ioc3_serial.c
  
+ IOQ LIBRARY
+ M:	Gregory Haskins <ghaskins@novell.com>
+ S:	Maintained
+ F:	include/linux/ioq.h
+ F:	lib/ioq.c
+ 
  IP MASQUERADING
  M:	Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
  S:	Maintained
@@@ -5660,6 -5032,23 +5666,12 @@@ M:	Robin Holt <holt@sgi.com
  S:	Maintained
  F:	drivers/misc/sgi-xp/
  
 -SHARP LH SUPPORT (LH7952X & LH7A40X)
 -M:	Marc Singer <elf@buici.com>
 -W:	http://projects.buici.com/arm
 -L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 -S:	Maintained
 -F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 -F:	arch/arm/mach-lh7a40x/
 -F:	drivers/serial/serial_lh7a40x.c
 -F:	drivers/usb/gadget/lh7a40*
 -F:	drivers/usb/host/ohci-lh7a40*
 -
+ SHM-SIGNAL LIBRARY
+ M:	Gregory Haskins <ghaskins@novell.com>
+ S:	Maintained
+ F:	include/linux/shm_signal.h
+ F:	lib/shm_signal.c
+ 
  SIMPLE FIRMWARE INTERFACE (SFI)
  M:	Len Brown <lenb@kernel.org>
  L:	sfi-devel@simplefirmware.org
