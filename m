Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2HOTIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:08:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38307 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2HOTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:08:33 -0400
Date: Wed, 15 Aug 2012 12:08:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.41
Message-ID: <20120815190829.GA2318@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.41 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 MAINTAINERS                           |    2=20
 Makefile                              |    2=20
 arch/arm/configs/mxs_defconfig        |    1=20
 arch/arm/include/asm/cacheflush.h     |    8=20
 arch/arm/mm/tlb-v7.S                  |   12 +
 arch/ia64/include/asm/atomic.h        |    4=20
 arch/ia64/kernel/irq_ia64.c           |    1=20
 arch/x86/include/asm/processor.h      |    2=20
 arch/x86/kernel/alternative.c         |    2=20
 arch/x86/kernel/amd_nb.c              |    8=20
 arch/x86/kernel/cpu/amd.c             |    2=20
 arch/x86/kernel/cpu/common.c          |    5=20
 arch/x86/kernel/cpu/intel.c           |    2=20
 arch/x86/kernel/cpu/mcheck/mce.c      |    2=20
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    5=20
 arch/x86/kernel/cpu/proc.c            |    4=20
 arch/x86/kernel/microcode_core.c      |   31 +-
 drivers/char/mspec.c                  |    2=20
 drivers/char/random.c                 |  374 +++++++++++++++++++++++------=
-----
 drivers/edac/i7core_edac.c            |    2=20
 drivers/firmware/dmi_scan.c           |    3=20
 drivers/firmware/pcdp.c               |    4=20
 drivers/hwmon/coretemp.c              |    7=20
 drivers/input/tablet/wacom_wac.c      |    2=20
 drivers/mfd/ab3100-core.c             |    5=20
 drivers/mfd/ab3550-core.c             |    2=20
 drivers/mfd/ezx-pcap.c                |    2=20
 drivers/mfd/wm831x-otp.c              |    8=20
 drivers/net/e1000e/82571.c            |    4=20
 drivers/net/wireless/rt2x00/rt61pci.c |    3=20
 drivers/rtc/rtc-wm831x.c              |   24 ++
 drivers/usb/core/hub.c                |    9=20
 fs/nilfs2/ioctl.c                     |    4=20
 fs/nilfs2/super.c                     |    3=20
 fs/nilfs2/the_nilfs.c                 |    1=20
 fs/nilfs2/the_nilfs.h                 |    2=20
 include/linux/irqdesc.h               |    1=20
 include/linux/mfd/ezx-pcap.h          |    1=20
 include/linux/random.h                |   19 +
 include/trace/events/random.h         |  134 ++++++++++++
 kernel/irq/handle.c                   |    7=20
 kernel/irq/manage.c                   |   17 -
 mm/hugetlb.c                          |   25 ++
 mm/memory-failure.c                   |    6=20
 mm/mmu_notifier.c                     |   45 ++--
 net/core/dev.c                        |    3=20
 net/core/rtnetlink.c                  |    1=20
 net/mac80211/mesh.c                   |    1=20
 net/sunrpc/rpcb_clnt.c                |    4=20
 net/wireless/core.c                   |    5=20
 net/wireless/core.h                   |    1=20
 net/wireless/util.c                   |    5=20
 52 files changed, 585 insertions(+), 244 deletions(-)

Alan Cox (1):
      x86, nops: Missing break resulting in incorrect selection on Intel

Arnd Bergmann (1):
      ARM: pxa: remove irq_to_gpio from ezx-pcap driver

Borislav Petkov (1):
      x86, microcode: Sanitize per-cpu microcode reloading interface

Chris Bagwell (1):
      Input: wacom - Bamboo One 1024 pressure fix

Daniel Drake (1):
      cfg80211: process pending events when unregistering net device

Greg Kroah-Hartman (1):
      Linux 3.0.41

Greg Pearson (1):
      pcdp: use early_ioremap/early_iounmap to access pcdp table

H. Peter Anvin (3):
      random: Add support for architectural random hooks
      random: Adjust the number of loops when initializing
      random: mix in architectural randomness in extract_buf()

Johannes Berg (1):
      mac80211: cancel mesh path timer

Joonsoo Kim (1):
      mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_p=
age()

Kevin Winchester (1):
      x86: Simplify code by removing a !SMP #ifdefs from 'struct cpuinfo_x8=
6'

Liang Li (1):
      cfg80211: fix interface combinations check for ADHOC(IBSS)

Linus Torvalds (2):
      random: Use arch_get_random_int instead of cycle counter if avail
      random: create add_device_randomness() interface

Marek Vasut (1):
      ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig

Mark Brown (2):
      rtc: wm831x: Feed the write counter into device_add_randomness()
      mfd: wm831x: Feed the device UUID into device_add_randomness()

Mathieu Desnoyers (1):
      drivers/char/random.c: fix boot id uniqueness race

Mel Gorman (1):
      mm: hugetlbfs: close race during teardown of hugetlbfs shared page ta=
bles

Ryusuke Konishi (1):
      nilfs2: fix deadlock issue between chcp and thaw ioctls

Shuah Khan (1):
      x86, microcode: microcode_core.c simple_strtoul cleanup

Stanislav Kinsbursky (1):
      SUNRPC: return negative value in case rpcbind client creation error

Stanislaw Gruszka (1):
      rt61pci: fix NULL pointer dereference in config_lna_gain

Theodore Ts'o (10):
      random: Use arch-specific RNG to initialize the entropy store
      random: make 'add_interrupt_randomness()' do something sane
      random: use lockless techniques in the interrupt path
      usb: feed USB device information to the /dev/random driver
      net: feed /dev/random with the MAC address when registering a device
      random: use the arch-specific rng in xfer_secondary_pool
      random: add new get_random_bytes_arch() function
      random: add tracepoints for easier debugging and verification
      MAINTAINERS: Theodore Ts'o is taking over the random driver
      random: remove rand_initialize_irq()

Tony Luck (4):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
      fix typo/thinko in get_random_bytes()
      random: Add comment to random_initialize()
      dmi: Feed DMI table to /dev/random driver

Tushar Dave (1):
      e1000e: NIC goes up and immediately goes down

Will Deacon (2):
      ARM: 7478/1: errata: extend workaround for erratum #720789
      ARM: 7479/1: mm: avoid NULL dereference when flushing gate_vma with V=
IVT caches

Xiao Guangrong (1):
      mm: mmu_notifier: fix freed page still mapped in secondary MMU


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQK/OtAAoJEDjbvchgkmk+D2QQAIgfhTmkmG9CfWCumLEEnOrK
FjUQprg+5sdM/zybHJoasols/XAUMN71CCBeqkMBKqsam+hyjnB8BB0lpaJJUxql
UFFV+1fhuvhNdNxr+uOeycyHoPGL87CfmUAuCs5z3XJrbDBrk2M/4eoByuBOuHGp
oHwv0QZaV4wNRu84bSyL2P7wnAwe6cC4GCn2BG6fSJ2IGetAa9+UDTXgBlk9bBPQ
XhofVqSaQJuu57zTSv8VH90W5dz/GxU0ccMU6leUd0bCDH93eyAEaF0dTKn74LZR
9QrAe+8iKQi4D93mXRNvwiXiqmgmxyy5L8WqO1BhmHFv+tY3FoRqBxvx//QXrI0U
V0VpRdiOB/+oYsCHFkaJ7NYBBYnxUMh92fvw6lXecdAG8Pz52Jjg4doTLjqfhe4B
80OtwjGCPbluKWmITGVRClOhlaFzGl5aE6w/O2Pbj8zgA2PgRsJvC/RjuDJJYij4
yfiLfjhZlE9mmK99ku/3XRGy2tIYLGlMsKpRUq5gevdgT4ySBjs3EAgZBkMroRfF
vXRXc5OvJtjDdELBiG/4eRgg5AgRod5KF+oZtnWnBLSPhFNP17MRTOi55zxB9Cqx
cU9XACcuT+yAeqgd801pom4NXTIuVvGhMVPQ8FMLzT7NQVkDHlcmaAQ7i1ImgpRV
8cLDq8k36+UZWklbB400
=pyXS
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
