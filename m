Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2JZAGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:06:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:52638 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab2JZAGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: =?UTF-8?q?=5B=2000/42=5D=203=2E4=2E16-stable=20review?=
Date: Thu, 25 Oct 2012 17:05:08 -0700
Message-Id: <20121026000124.790781113@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.16 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 28 00:01:07 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.16-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Brian Norris <computersforpeace@gmail.com>
    mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver

David S. Miller <davem@davemloft.net>
    sparc64: Be less verbose during vmemmap population.

Jiri Kosina <jkosina@suse.cz>
    sparc64: do not clobber personality flags in sys_sparc64_personality()

David S. Miller <davem@davemloft.net>
    sparc64: Fix bit twiddling in sparc_pmu_enable_event().

David S. Miller <davem@davemloft.net>
    sparc64: Like x86 we should check current->mm during perf backtrace generation.

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix ptrace interaction with force_successful_syscall_return()

Eric Dumazet <edumazet@google.com>
    ipv6: addrconf: fix /proc/net/if_inet6

Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
    tcp: resets are misrouted

jeff.liu <jeff.liu@oracle.com>
    RDS: fix rds-ping spinlock recursion

Florian Zumbiehl <florz@florz.de>
    vlan: don't deliver frames for unknown vlans to protocols

Graham Gower <graham.gower@gmail.com>
    skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboard

ramesh.nagappa@gmail.com <ramesh.nagappa@gmail.com>
    net: Fix skb_under_panic oops in neigh_resolve_output

Gao feng <gaofeng@cn.fujitsu.com>
    infiniband: pass rdma_cm module to netlink_dump_start

Gao feng <gaofeng@cn.fujitsu.com>
    netlink: add reference of module in netlink_dump_start

Devin Heitmueller <dheitmueller@kernellabs.com>
    media: au0828: fix case where STREAMOFF being called on stopped stream causes BUG()

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: fix 'endpoint always busy' bug

Andrew Morton <akpm@linux-foundation.org>
    amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Hiro Sugawara <hsugawara@nvidia.com>
    iommu/tegra: smmu: Fix deadly typo

Pritesh Raithatha <praithatha@nvidia.com>
    pinctrl: tegra: set low power mode bank width to 2

Pritesh Raithatha <praithatha@nvidia.com>
    pinctrl: tegra: correct bank for pingroup and drv pingroup

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Remove task_lock() from cgroup_post_fork()"

Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
    cgroup: notify_on_release may not be triggered in some cases

Bjørn Mork <bjorn@mork.no>
    USB: option: add more ZTE devices

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist net interface on ZTE devices

Alexis R. Cortes <alexis.cortes@ti.com>
    usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP

Nicolas Boullis <nboullis@debian.org>
    usb: acm: fix the computation of the number of data bits

Ming Lei <ming.lei@canonical.com>
    USB: cdc-acm: fix pipe type of write endpoint

David Vrabel <david.vrabel@citrix.com>
    xen/x86: don't corrupt %eip when returning from a signal handler

Jacob Shin <jacob.shin@amd.com>
    x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.

Kees Cook <keescook@chromium.org>
    use clamp_t in UNAME26 fix

Kees Cook <keescook@chromium.org>
    kernel/sys.c: fix stack memory content leak via UNAME26

Arnd Bergmann <arnd@arndb.de>
    pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix a UDP transport regression

Sasha Levin <levinsasha928@gmail.com>
    SUNRPC: Prevent kernel stack corruption on long values of flush

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390: fix linker script for 31 bit builds

Dan Carpenter <dan.carpenter@oracle.com>
    oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

Trond Myklebust <Trond.Myklebust@netapp.com>
    NLM: nlm_lookup_file() may return NLMv4-specific error codes

Chris Metcalf <cmetcalf@tilera.com>
    arch/tile: avoid generating .eh_frame information in modules

Michal Hocko <mhocko@suse.cz>
    nohz: Fix idle ticks in cpu summary line of /proc/stat

Lukas Czerner <lczerner@redhat.com>
    ext4: Avoid underflow in ext4_trim_fs()

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: race-condition protection for ext4_convert_unwritten_extents_endio


-------------

Diffstat:

 Makefile                                  |  4 +-
 arch/s390/boot/compressed/vmlinux.lds.S   |  2 +-
 arch/s390/kernel/vmlinux.lds.S            |  2 +-
 arch/sparc/kernel/perf_event.c            | 15 +++---
 arch/sparc/kernel/sys_sparc_64.c          | 10 ++--
 arch/sparc/kernel/syscalls.S              | 32 ++++++------
 arch/sparc/mm/init_64.c                   | 28 +++++++++--
 arch/tile/Makefile                        |  4 ++
 arch/x86/kernel/entry_32.S                |  8 +--
 arch/x86/kernel/entry_64.S                |  2 +-
 arch/x86/kernel/setup.c                   | 17 ++++++-
 arch/x86/oprofile/nmi_int.c               |  2 +-
 drivers/edac/amd64_edac.c                 | 11 ++--
 drivers/infiniband/core/cma.c             |  3 +-
 drivers/infiniband/core/netlink.c         |  1 +
 drivers/iommu/tegra-smmu.c                |  2 +-
 drivers/media/video/au0828/au0828-video.c | 12 +++--
 drivers/mtd/nand/nand_base.c              |  9 ++--
 drivers/net/ethernet/marvell/skge.c       |  7 +++
 drivers/pcmcia/pxa2xx_sharpsl.c           |  2 +-
 drivers/pinctrl/pinctrl-tegra.c           |  2 +-
 drivers/pinctrl/pinctrl-tegra30.c         | 24 ++++-----
 drivers/usb/class/cdc-acm.c               | 22 +++++---
 drivers/usb/dwc3/gadget.c                 |  1 +
 drivers/usb/host/xhci.c                   |  3 +-
 drivers/usb/serial/option.c               | 84 +++++++++++++++++++++++--------
 fs/ext4/extents.c                         | 57 +++++++++++++++++----
 fs/ext4/mballoc.c                         |  5 +-
 fs/lockd/clntxdr.c                        |  2 +-
 fs/lockd/svcproc.c                        |  3 +-
 fs/proc/stat.c                            | 14 ++++--
 include/linux/if_vlan.h                   |  8 +--
 include/linux/mtd/nand.h                  |  3 --
 include/linux/netlink.h                   | 21 ++++++--
 include/linux/sunrpc/xprt.h               |  3 ++
 include/rdma/rdma_netlink.h               |  1 +
 kernel/cgroup.c                           | 41 ++++-----------
 kernel/sys.c                              | 12 +++--
 net/8021q/vlan_core.c                     | 10 +---
 net/core/dev.c                            |  7 ++-
 net/core/neighbour.c                      |  6 +--
 net/ipv4/tcp_ipv4.c                       |  7 +--
 net/ipv6/addrconf.c                       | 15 +++---
 net/ipv6/tcp_ipv6.c                       |  3 +-
 net/netlink/af_netlink.c                  | 29 ++++++++---
 net/rds/send.c                            |  2 +-
 net/sunrpc/cache.c                        |  4 +-
 net/sunrpc/xprt.c                         | 34 +++++++------
 net/sunrpc/xprtrdma/transport.c           |  1 +
 net/sunrpc/xprtsock.c                     |  4 ++
 50 files changed, 381 insertions(+), 220 deletions(-)


