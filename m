Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2J1SB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:01:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63867 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2J1SBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:01:55 -0400
Date: Sun, 28 Oct 2012 11:02:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.16
Message-ID: <20121028180245.GA24247@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.16 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 arch/s390/boot/compressed/vmlinux.lds.S   |    2=20
 arch/s390/kernel/vmlinux.lds.S            |    2=20
 arch/sparc/kernel/perf_event.c            |   15 +++--
 arch/sparc/kernel/sys_sparc_64.c          |   10 +--
 arch/sparc/kernel/syscalls.S              |   32 +++++------
 arch/sparc/mm/init_64.c                   |   28 ++++++++--
 arch/tile/Makefile                        |    4 +
 arch/x86/kernel/entry_32.S                |    8 +-
 arch/x86/kernel/entry_64.S                |    2=20
 arch/x86/kernel/setup.c                   |   17 +++++-
 arch/x86/oprofile/nmi_int.c               |    2=20
 drivers/edac/amd64_edac.c                 |   11 +--
 drivers/infiniband/core/cma.c             |    3 -
 drivers/infiniband/core/netlink.c         |    1=20
 drivers/iommu/tegra-smmu.c                |    2=20
 drivers/media/video/au0828/au0828-video.c |   12 ++--
 drivers/mtd/nand/nand_base.c              |    9 +--
 drivers/net/ethernet/marvell/skge.c       |    7 ++
 drivers/pcmcia/pxa2xx_sharpsl.c           |    2=20
 drivers/pinctrl/pinctrl-tegra.c           |    2=20
 drivers/pinctrl/pinctrl-tegra30.c         |   24 ++++----
 drivers/usb/class/cdc-acm.c               |   22 +++++--
 drivers/usb/dwc3/gadget.c                 |    1=20
 drivers/usb/host/xhci.c                   |    3 -
 drivers/usb/serial/option.c               |   84 ++++++++++++++++++++++---=
-----
 fs/ext4/extents.c                         |   57 ++++++++++++++++----
 fs/ext4/mballoc.c                         |    5 +
 fs/lockd/clntxdr.c                        |    2=20
 fs/lockd/svcproc.c                        |    3 -
 fs/proc/stat.c                            |   14 +++--
 include/linux/if_vlan.h                   |    8 +-
 include/linux/mtd/nand.h                  |    3 -
 include/linux/netlink.h                   |   21 ++++++-
 include/linux/sunrpc/xprt.h               |    3 +
 include/rdma/rdma_netlink.h               |    1=20
 kernel/cgroup.c                           |   41 +++-----------
 kernel/sys.c                              |   12 ++--
 net/8021q/vlan_core.c                     |   10 ---
 net/core/dev.c                            |    7 +-
 net/core/neighbour.c                      |    6 --
 net/ipv4/tcp_ipv4.c                       |    7 +-
 net/ipv6/addrconf.c                       |   15 +++--
 net/ipv6/tcp_ipv6.c                       |    3 -
 net/netlink/af_netlink.c                  |   29 +++++++---
 net/rds/send.c                            |    2=20
 net/sunrpc/cache.c                        |    4 -
 net/sunrpc/xprt.c                         |   34 +++++++-----
 net/sunrpc/xprtrdma/transport.c           |    1=20
 net/sunrpc/xprtsock.c                     |    4 +
 50 files changed, 380 insertions(+), 219 deletions(-)

Al Viro (1):
      sparc64: fix ptrace interaction with force_successful_syscall_return()

Alexey Kuznetsov (1):
      tcp: resets are misrouted

Alexis R. Cortes (1):
      usb: host: xhci: New system added for Compliance Mode Patch on SN65LV=
PE502CP

Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Arnd Bergmann (1):
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Bj=F8rn Mork (2):
      USB: option: blacklist net interface on ZTE devices
      USB: option: add more ZTE devices

Brian Norris (1):
      mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver

Chris Metcalf (1):
      arch/tile: avoid generating .eh_frame information in modules

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Dan Carpenter (1):
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

David S. Miller (3):
      sparc64: Like x86 we should check current->mm during perf backtrace g=
eneration.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().
      sparc64: Be less verbose during vmemmap population.

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler

Devin Heitmueller (1):
      media: au0828: fix case where STREAMOFF being called on stopped strea=
m causes BUG()

Dmitry Monakhov (1):
      ext4: race-condition protection for ext4_convert_unwritten_extents_en=
dio

Eric Dumazet (1):
      ipv6: addrconf: fix /proc/net/if_inet6

Felipe Balbi (1):
      usb: dwc3: gadget: fix 'endpoint always busy' bug

Florian Zumbiehl (1):
      vlan: don't deliver frames for unknown vlans to protocols

Gao feng (2):
      netlink: add reference of module in netlink_dump_start
      infiniband: pass rdma_cm module to netlink_dump_start

Graham Gower (1):
      skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboa=
rd

Greg Kroah-Hartman (1):
      Linux 3.4.16

Heiko Carstens (1):
      s390: fix linker script for 31 bit builds

Hiro Sugawara (1):
      iommu/tegra: smmu: Fix deadly typo

Jacob Shin (1):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from d=
irect mapping.

Jiri Kosina (1):
      sparc64: do not clobber personality flags in sys_sparc64_personality()

Kees Cook (2):
      kernel/sys.c: fix stack memory content leak via UNAME26
      use clamp_t in UNAME26 fix

Lukas Czerner (1):
      ext4: Avoid underflow in ext4_trim_fs()

Michal Hocko (1):
      nohz: Fix idle ticks in cpu summary line of /proc/stat

Ming Lei (1):
      USB: cdc-acm: fix pipe type of write endpoint

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits

Pritesh Raithatha (2):
      pinctrl: tegra: correct bank for pingroup and drv pingroup
      pinctrl: tegra: set low power mode bank width to 2

Sasha Levin (1):
      SUNRPC: Prevent kernel stack corruption on long values of flush

Tejun Heo (2):
      Revert "cgroup: Remove task_lock() from cgroup_post_fork()"
      Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"

Trond Myklebust (2):
      NLM: nlm_lookup_file() may return NLMv4-specific error codes
      SUNRPC: Fix a UDP transport regression

jeff.liu (1):
      RDS: fix rds-ping spinlock recursion

ramesh.nagappa@gmail.com (1):
      net: Fix skb_under_panic oops in neigh_resolve_output


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQjXNFAAoJEDjbvchgkmk+dQ8QALY2F0DDoGErpjw3KVJicSy3
NHi+lccwDBlkAs/L7AQYvOBmPbdiBBNXan+lgdRa3TE35+7I7zC8EK+rg+tS6bde
c22r2WGFEw/PCG88oW1ciIrwYaVviu25gD4Y45AOcccoJCT7EhLC+bAHfFAnh3SW
s53ABgmLdBPrg5yBzK1p36kbZZbrceWwU0/AjA45L7XUxQUpOV53zkWOqfQ6ntJQ
66Ibp23XSjg3KUSoyEeoOrHhLvgEhuPoL2wdR6OMYPNzxm0DsZUZAqEkHsEKxu+Y
48UxvpPEai+pJMZjlogNPaaMxBQU9NTvlzXL8ac8yZhooYLd2KZVYMNfmrnqy9rP
uipDaqNBIOqgL/9Uv5lmMf4cpSX4eZCQBrWAjIxpfDXksUiduob0NigATLocqs3K
M2xIbU0D6cLJvOuwowR7Pe+a71+G2Al3rGf2e0PrV8fwUyesSgIRzk/oT6XPg+DS
4HjEqnvydmVAZ1ZyjXBrXzROtkR6jzT+clq+6hzTsSaAIC0kowYUAXSefuRxSseZ
/+8XPEolLBTV4mMTk5j+WTvr/ltRXxldC12t3mQ9O6N5rvr1mOu/rsoN7Qk19tAc
NxL8WmT8DCdAp0jiGTaTiviAabqjuQ8oIntzmEmOi1zUEUSm4tOrCQX1jUU2plq5
Yky+TDzuuC3U2FMoMNmL
=cqrg
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
