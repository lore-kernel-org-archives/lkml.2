Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab1CNVlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:41:52 -0400
Received: from kroah.org ([198.145.64.141]:46552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab1CNVl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:41:29 -0400
Date: Mon, 14 Mar 2011 14:41:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.33
Message-ID: <20110314214102.GA3833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.33 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 -
 arch/powerpc/include/asm/hvcall.h               |    1 
 arch/powerpc/kernel/crash.c                     |   11 +++++-
 arch/powerpc/kernel/machine_kexec_64.c          |   25 +++++++++++++++
 arch/powerpc/kernel/setup_64.c                  |   17 ++++++++--
 arch/powerpc/platforms/pseries/hvCall.S         |   38 ++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/lpar.c           |   33 ++++++++++++--------
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++++++++
 drivers/net/ixgbe/ixgbe_main.c                  |    4 ++
 drivers/net/r8169.c                             |    6 ++-
 drivers/s390/char/keyboard.c                    |    3 +
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 +++-
 fs/nfsd/nfs4xdr.c                               |    4 +-
 include/keys/rxrpc-type.h                       |    1 
 include/linux/netdevice.h                       |    4 ++
 kernel/cpuset.c                                 |    7 +++-
 mm/mremap.c                                     |    4 --
 net/core/dev.c                                  |   12 ++++++-
 net/ipv4/ip_gre.c                               |    1 
 net/ipv4/ipip.c                                 |    1 
 net/ipv6/ip6_tunnel.c                           |    1 
 net/ipv6/sit.c                                  |    2 -
 net/netfilter/nf_log.c                          |    4 ++
 23 files changed, 170 insertions(+), 36 deletions(-)

Anton Blanchard (4):
      RxRPC: Fix v1 keys
      powerpc/kdump: CPUs assume the context of the oopsing CPU
      powerpc/kdump: Use chip->shutdown to disable IRQs
      powerpc: Use more accurate limit for first segment memory allocations

Dan Carpenter (1):
      keyboard: integer underflow bug

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Greg Kroah-Hartman (1):
      Linux 2.6.32.33

Hugh Dickins (1):
      mm: fix possible cause of a page_mapped BUG

Ian Abbott (1):
      Staging: comedi: jr3_pci: Don't ioremap too much space. Check result.

Ivan Vecera (1):
      r8169: use RxFIFO overflow workaround for 8168c chipset.

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Li Zefan (1):
      cpuset: add a missing unlock in cpuset_write_resmask()

Matt Evans (1):
      powerpc/kexec: Fix orphaned offline CPUs across kexec

Maxim Uvarov (1):
      powerpc/crashdump: Do not fail on NULL pointer dereferencing

Michael Neuling (2):
      powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
      powerpc/kexec: Speedup kexec hash PTE tear down

Vasiliy Kulikov (1):
      net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules

roel (1):
      nfsd: wrong index used in inner loop

stephen hemminger (1):
      ip6ip6: autoload ip6 tunnel

