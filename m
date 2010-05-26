Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0EZFXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:23:34 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:35323 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0EZFXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Tu+ijc2KRtwYLW0tKCX4k1kDqMyUVM6xC2XXuNfM59q2g4vZNWdL6utn2U5h62fpyY
         ZC7B92Mojo9rpAH4Ou60AGDXK1yK/J+IdcWQIvHgRH1N2R6KIFwE3YfU++BOuu2VUiiP
         QCha+ORpYx6PL3skt9QxgFG34PjgiN2KtRFrc=
MIME-Version: 1.0
Date: Tue, 25 May 2010 23:23:30 -0600
Message-ID: <AANLkTilqascTmKEr_aFu2QxqabXaz7z2UXAQNV7HA6sT@mail.gmail.com>
Subject: [ANNOUNCE] ndiswrapper-2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always here to support the hated projects of Evil Emperor Linus.
Needed this fucking thing to work on my laptop so fixed the busted
shit.  There you go whoever needs it.

http://merkeydebugger.googlecode.com/files/ndiswrapper-2.6.34.tar.gz

Also, Peter Anvins busted SYSLINUX loader doesn't boot Fedora Core 12
on Windows Laptops for overinstall.   Locks up on a Compaq.  Guess I
have to rebuild FC12
and use a loader that actually works "cannot find linux kernel to
load"  Geeeeezzzzzzzzzzz....

FIXES - Fixed all this busted shit.  The netdev_ops structure is a
good idea since making these tables const prevents dirty hooking.  Too
bad the netdev_ops pointer still allows it though.  Whoever mucked
with the request_irq handlers needs to finish what they broke.  Having
an intermediary handler var seems fucking braindead not to mention it
s little late to be screwing arounf with IRQ handlers -- this shit
should have been dealt with in 1997 guys.

make -C /lib/modules/2.6.34/build M=/archive/ndis/ndiswrapper-1.54-2.6.34/driver
make[2]: Entering directory `/kernel/linux-2.6.34'
  LD      /archive/ndis/ndiswrapper-1.54-2.6.34/driver/built-in.o
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/crt_exports.h
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/hal_exports.h
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/ndis_exports.h
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel_exports.h
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel_io_exports.h
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/rtl_exports.h
  MKEXPORT /archive/ndis/ndiswrapper-1.54-2.6.34/driver/usb_exports.h
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/crt.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/hal.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/iw_ndis.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/loader.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/ndis.o
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ndis.c: In function
‘NdisMAllocateMapRegisters’:
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ndis.c:948: warning:
‘DMA_nnBIT_MASK’ is deprecated
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ndis.c:950: warning:
‘DMA_nnBIT_MASK’ is deprecated
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ndis.c:954: warning:
‘DMA_nnBIT_MASK’ is deprecated
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel.o
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel.c: In function
‘MmAllocateContiguousMemorySpecifyCache’:
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel.c:1706:
warning: ‘DMA_nnBIT_MASK’ is deprecated
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel.c:1708:
warning: ‘DMA_nnBIT_MASK’ is deprecated
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel_io.o
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel_io.c: In
function ‘IoConnectInterrupt’:
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/ntoskernel_io.c:566:
warning: passing argument 2 of ‘request_irq’ from incompatible pointer
type
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/pe_linker.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/pnp.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/proc.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/rtl.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapmem.o
  CC [M]  /archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.o
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c: In function
‘notifier_event’:
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1693: error:
‘struct net_device’ has no member named ‘open’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c: In function
‘ndis_start_device’:
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1749: error:
‘struct net_device’ has no member named ‘open’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1750: error:
‘struct net_device’ has no member named ‘hard_start_xmit’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1751: error:
‘struct net_device’ has no member named ‘stop’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1752: error:
‘struct net_device’ has no member named ‘get_stats’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1753: error:
‘struct net_device’ has no member named ‘change_mtu’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1754: error:
‘struct net_device’ has no member named ‘do_ioctl’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1758: error:
‘struct net_device’ has no member named ‘set_multicast_list’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1759: error:
‘struct net_device’ has no member named ‘set_mac_address’
/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.c:1774: error:
‘struct net_device’ has no member named ‘poll_controller’
make[3]: *** [/archive/ndis/ndiswrapper-1.54-2.6.34/driver/wrapndis.o] Error 1
make[2]: *** [_module_/archive/ndis/ndiswrapper-1.54-2.6.34/driver] Error 2
make[2]: Leaving directory `/kernel/linux-2.6.34'
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/archive/ndis/ndiswrapper-1.54-2.6.34/driver'
make: *** [all] Error 2

All this shit is fixed.

Jeff Merkey
