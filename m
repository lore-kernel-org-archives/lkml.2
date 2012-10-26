Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2JZAcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:32:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:53252 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2JZAHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: =?UTF-8?q?=5B=2000/85=5D=203=2E6=2E4-stable=20review?=
Date: Thu, 25 Oct 2012 17:05:18 -0700
Message-Id: <20121026000031.107227138@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.4 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct 27 23:59:01 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Thomas Pedersen <thomas@cozybit.com>
    mac80211: call drv_get_tsf() in sleepable context

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

Julian Anastasov <ja@ssi.bg>
    ipvs: fix ARP resolving for direct routing mode

Julian Anastasov <ja@ssi.bg>
    ipv4: Add FLOWI_FLAG_KNOWN_NH

Julian Anastasov <ja@ssi.bg>
    ipv4: introduce rt_uses_gateway

Julian Anastasov <ja@ssi.bg>
    ipv4: make sure nh_pcpu_rth_output is always allocated

Julian Anastasov <ja@ssi.bg>
    ipv4: fix forwarding for strict source routes

Julian Anastasov <ja@ssi.bg>
    ipv4: fix sending of redirects

Florian Zumbiehl <florz@florz.de>
    vlan: don't deliver frames for unknown vlans to protocols

Graham Gower <graham.gower@gmail.com>
    skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboard

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Don't report stale pmtu values to userspace

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Don't create nh exeption when the device mtu is smaller than the reported pmtu

Steffen Klassert <steffen.klassert@secunet.com>
    ipv4: Always invalidate or update the route on pmtu events

Eric Dumazet <edumazet@google.com>
    ipv6: GRO should be ECN friendly

ramesh.nagappa@gmail.com <ramesh.nagappa@gmail.com>
    net: Fix skb_under_panic oops in neigh_resolve_output

Eric Dumazet <edumazet@google.com>
    net: remove skb recycling

Gao feng <gaofeng@cn.fujitsu.com>
    infiniband: pass rdma_cm module to netlink_dump_start

Gao feng <gaofeng@cn.fujitsu.com>
    netlink: add reference of module in netlink_dump_start

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Use cpu relocations if the object is in the GTT but not mappable

Devin Heitmueller <dheitmueller@kernellabs.com>
    media: au0828: fix case where STREAMOFF being called on stopped stream causes BUG()

Chris Zankel <chris@zankel.net>
    xtensa: add missing system calls to the syscall table

Andrew Morton <akpm@linux-foundation.org>
    amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Hiro Sugawara <hsugawara@nvidia.com>
    iommu/tegra: smmu: Fix deadly typo

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    pinctrl: fix missing unlock on error in pinctrl_groups_show()

Haojian Zhuang <haojian.zhuang@gmail.com>
    pinctrl: remove mutex lock in groups show

Pritesh Raithatha <praithatha@nvidia.com>
    pinctrl: tegra: set low power mode bank width to 2

Pritesh Raithatha <praithatha@nvidia.com>
    dt: Document: correct tegra20/30 pinctrl slew-rate name

Pritesh Raithatha <praithatha@nvidia.com>
    pinctrl: tegra: correct bank for pingroup and drv pingroup

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"

Tejun Heo <tj@kernel.org>
    Revert "cgroup: Remove task_lock() from cgroup_post_fork()"

Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
    cgroup: notify_on_release may not be triggered in some cases

Alan Stern <stern@rowland.harvard.edu>
    USB: fix port probing and removal in garmin_gps

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    usb: Send Set SEL before enabling parent U1/U2 timeout.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Enable LPM after a failed probe.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    usb: Don't enable LPM if the exit latency is zero.

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: fix 'endpoint always busy' bug

Bjørn Mork <bjorn@mork.no>
    USB: option: add more ZTE devices

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist net interface on ZTE devices

Johan Hovold <jhovold@gmail.com>
    USB: keyspan_pda: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: io_edgeport: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: kl5kusb105: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: spcp8x5: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: cp210x: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: cypress_m8: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: kobil_sct: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: ssu100: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: pl2303: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: belkin_sa: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: oti6858: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: f81232: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: ark3116: fix NULL-pointer dereference

Johan Hovold <jhovold@gmail.com>
    USB: iuu_phoenix: fix sysfs-attribute creation

Johan Hovold <jhovold@gmail.com>
    USB: iuu_phoenix: fix port-data memory leak

Alexis R. Cortes <alexis.cortes@ti.com>
    usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP

Stefano Babic <sbabic@denx.de>
    usb: musb: am35xx: drop spurious unplugging a device

Johan Hovold <jhovold@gmail.com>
    USB: cyberjack: fix port-data memory leak

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix sysfs-attribute creation

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix port-data memory leak

Nicolas Boullis <nboullis@debian.org>
    usb: acm: fix the computation of the number of data bits

Ming Lei <ming.lei@canonical.com>
    USB: cdc-acm: fix pipe type of write endpoint

David Vrabel <david.vrabel@citrix.com>
    xen/x86: don't corrupt %eip when returning from a signal handler

Jacob Shin <jacob.shin@amd.com>
    x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.

Daniel J Blueman <daniel@numascale-asia.com>
    x86, amd, mce: Avoid NULL pointer reference on CPU northbridge lookup

Kees Cook <keescook@chromium.org>
    use clamp_t in UNAME26 fix

Kees Cook <keescook@chromium.org>
    kernel/sys.c: fix stack memory content leak via UNAME26

Arnd Bergmann <arnd@arndb.de>
    pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Vaibhav Nagarnaik <vnagarnaik@google.com>
    ring-buffer: Check for uninitialized cpu buffer before resizing

Bryan Schumaker <bjschuma@netapp.com>
    SUNRPC: Set alloc_slot for backchannel tcp ops

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

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Henrik Rydberg <rydberg@euromail.se>
    usbdevfs: Fix broken scatter-gather transfer

Lukas Czerner <lczerner@redhat.com>
    ext4: Avoid underflow in ext4_trim_fs()

Tao Ma <boyu.mt@taobao.com>
    ext4: Checksum the block bitmap properly with bigalloc enabled

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: race-condition protection for ext4_convert_unwritten_extents_endio


-------------

Diffstat:

 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt      |   2 +-
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt      |   2 +-
 Documentation/hwmon/coretemp                        |   1 +
 Makefile                                            |   4 +-
 arch/s390/boot/compressed/vmlinux.lds.S             |   2 +-
 arch/s390/kernel/vmlinux.lds.S                      |   2 +-
 arch/sparc/kernel/perf_event.c                      |  15 ++-
 arch/sparc/kernel/syscalls.S                        |  32 ++---
 arch/tile/Makefile                                  |   4 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c                |  10 +-
 arch/x86/kernel/entry_32.S                          |   8 +-
 arch/x86/kernel/entry_64.S                          |   2 +-
 arch/x86/kernel/setup.c                             |  17 ++-
 arch/x86/oprofile/nmi_int.c                         |   2 +-
 arch/xtensa/include/asm/unistd.h                    |  91 ++++++++++---
 drivers/edac/amd64_edac.c                           |  11 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c          |   1 +
 drivers/hwmon/coretemp.c                            |   7 +-
 drivers/infiniband/core/cma.c                       |   3 +-
 drivers/infiniband/core/netlink.c                   |   1 +
 drivers/iommu/tegra-smmu.c                          |   2 +-
 drivers/media/video/au0828/au0828-video.c           |  12 +-
 drivers/net/ethernet/calxeda/xgmac.c                |  19 +--
 drivers/net/ethernet/freescale/gianfar.c            |  27 +---
 drivers/net/ethernet/freescale/gianfar.h            |   2 -
 drivers/net/ethernet/freescale/ucc_geth.c           |  29 +---
 drivers/net/ethernet/freescale/ucc_geth.h           |   2 -
 drivers/net/ethernet/marvell/mv643xx_eth.c          |  18 +--
 drivers/net/ethernet/marvell/skge.c                 |   7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h        |   1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |  20 +--
 drivers/pcmcia/pxa2xx_sharpsl.c                     |   2 +-
 drivers/pinctrl/core.c                              |   4 +-
 drivers/pinctrl/pinconf.c                           |   4 -
 drivers/pinctrl/pinctrl-tegra.c                     |   2 +-
 drivers/pinctrl/pinctrl-tegra30.c                   |  24 ++--
 drivers/usb/class/cdc-acm.c                         |  22 +++-
 drivers/usb/core/devio.c                            |   1 +
 drivers/usb/core/driver.c                           |   4 +
 drivers/usb/core/hub.c                              |  33 +++--
 drivers/usb/dwc3/gadget.c                           |   1 +
 drivers/usb/host/xhci.c                             |   3 +-
 drivers/usb/musb/am35x.c                            |   6 +
 drivers/usb/serial/ark3116.c                        |  26 ++--
 drivers/usb/serial/belkin_sa.c                      |  31 +++--
 drivers/usb/serial/cp210x.c                         |  41 +++---
 drivers/usb/serial/cyberjack.c                      |  48 +++----
 drivers/usb/serial/cypress_m8.c                     |  82 ++++++------
 drivers/usb/serial/f81232.c                         |  43 +++---
 drivers/usb/serial/garmin_gps.c                     |  24 +---
 drivers/usb/serial/io_edgeport.c                    |  54 ++++----
 drivers/usb/serial/io_tables.h                      |   8 ++
 drivers/usb/serial/io_ti.c                          |  91 +++++++------
 drivers/usb/serial/iuu_phoenix.c                    |  84 ++++++------
 drivers/usb/serial/keyspan_pda.c                    |  30 +++--
 drivers/usb/serial/kl5kusb105.c                     |  66 ++++------
 drivers/usb/serial/kobil_sct.c                      |  23 ++--
 drivers/usb/serial/option.c                         |  84 +++++++++---
 drivers/usb/serial/oti6858.c                        |  68 ++++------
 drivers/usb/serial/pl2303.c                         |  90 ++++++++-----
 drivers/usb/serial/spcp8x5.c                        |  46 +++----
 drivers/usb/serial/ssu100.c                         |  34 +++--
 drivers/usb/serial/ti_usb_3410_5052.c               |  88 ++++++-------
 fs/ext4/balloc.c                                    |   8 +-
 fs/ext4/bitmap.c                                    |   6 +-
 fs/ext4/ext4.h                                      |   4 +-
 fs/ext4/extents.c                                   |  57 ++++++--
 fs/ext4/ialloc.c                                    |   4 +-
 fs/ext4/mballoc.c                                   |  14 +-
 fs/ext4/resize.c                                    |   3 +-
 fs/lockd/clntxdr.c                                  |   2 +-
 fs/lockd/svcproc.c                                  |   3 +-
 fs/proc/stat.c                                      |  14 +-
 include/linux/if_vlan.h                             |   8 +-
 include/linux/netlink.h                             |  21 ++-
 include/linux/skbuff.h                              |  24 ----
 include/net/flow.h                                  |   1 +
 include/net/route.h                                 |   3 +-
 include/rdma/rdma_netlink.h                         |   1 +
 kernel/cgroup.c                                     |  41 ++----
 kernel/sys.c                                        |  12 +-
 kernel/trace/ring_buffer.c                          |   4 +
 net/8021q/vlan_core.c                               |  10 +-
 net/core/dev.c                                      |   7 +-
 net/core/neighbour.c                                |   6 +-
 net/core/skbuff.c                                   |  47 -------
 net/ipv4/fib_frontend.c                             |   3 +-
 net/ipv4/fib_semantics.c                            |   2 +
 net/ipv4/inet_connection_sock.c                     |   4 +-
 net/ipv4/ip_forward.c                               |   2 +-
 net/ipv4/ip_output.c                                |   4 +-
 net/ipv4/route.c                                    | 146 ++++++++++++---------
 net/ipv4/tcp_ipv4.c                                 |   7 +-
 net/ipv4/xfrm4_policy.c                             |   1 +
 net/ipv6/addrconf.c                                 |  15 ++-
 net/ipv6/af_inet6.c                                 |  11 +-
 net/ipv6/tcp_ipv6.c                                 |   3 +-
 net/mac80211/mesh_sync.c                            |   3 +-
 net/netfilter/ipvs/ip_vs_xmit.c                     |   8 +-
 net/netlink/af_netlink.c                            |  29 ++--
 net/rds/send.c                                      |   2 +-
 net/sunrpc/cache.c                                  |   4 +-
 net/sunrpc/xprtsock.c                               |   1 +
 103 files changed, 1061 insertions(+), 1007 deletions(-)


