Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2J1SDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:03:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40872 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2J1SDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:03:06 -0400
Date: Sun, 28 Oct 2012 11:03:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.4
Message-ID: <20121028180356.GA1414@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.4 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt |    2=
=20
 Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt |    2=
=20
 Documentation/hwmon/coretemp                                        |    1=
=20
 Makefile                                                            |    2=
=20
 arch/s390/boot/compressed/vmlinux.lds.S                             |    2=
=20
 arch/s390/kernel/vmlinux.lds.S                                      |    2=
=20
 arch/sparc/kernel/perf_event.c                                      |   15=
 -
 arch/sparc/kernel/syscalls.S                                        |   32=
 --
 arch/tile/Makefile                                                  |    4=
=20
 arch/x86/kernel/cpu/mcheck/mce_amd.c                                |   10=
=20
 arch/x86/kernel/entry_32.S                                          |    8=
=20
 arch/x86/kernel/entry_64.S                                          |    2=
=20
 arch/x86/kernel/setup.c                                             |   17=
 +
 arch/x86/oprofile/nmi_int.c                                         |    2=
=20
 arch/xtensa/include/asm/unistd.h                                    |   91=
 ++++--
 drivers/edac/amd64_edac.c                                           |   11=
=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c                          |    1=
=20
 drivers/hwmon/coretemp.c                                            |    7=
=20
 drivers/infiniband/core/cma.c                                       |    3=
=20
 drivers/infiniband/core/netlink.c                                   |    1=
=20
 drivers/iommu/tegra-smmu.c                                          |    2=
=20
 drivers/media/video/au0828/au0828-video.c                           |   12=
=20
 drivers/net/ethernet/calxeda/xgmac.c                                |   19=
 -
 drivers/net/ethernet/freescale/gianfar.c                            |   27=
 -
 drivers/net/ethernet/freescale/gianfar.h                            |    2=
=20
 drivers/net/ethernet/freescale/ucc_geth.c                           |   29=
 -
 drivers/net/ethernet/freescale/ucc_geth.h                           |    2=
=20
 drivers/net/ethernet/marvell/mv643xx_eth.c                          |   18=
 -
 drivers/net/ethernet/marvell/skge.c                                 |    7=
=20
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                        |    1=
=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |   20=
 -
 drivers/pcmcia/pxa2xx_sharpsl.c                                     |    2=
=20
 drivers/pinctrl/core.c                                              |    4=
=20
 drivers/pinctrl/pinconf.c                                           |    4=
=20
 drivers/pinctrl/pinctrl-tegra.c                                     |    2=
=20
 drivers/pinctrl/pinctrl-tegra30.c                                   |   24=
 -
 drivers/usb/class/cdc-acm.c                                         |   22=
 +
 drivers/usb/core/devio.c                                            |    1=
=20
 drivers/usb/core/driver.c                                           |    4=
=20
 drivers/usb/core/hub.c                                              |   33=
 +-
 drivers/usb/dwc3/gadget.c                                           |    1=
=20
 drivers/usb/host/xhci.c                                             |    3=
=20
 drivers/usb/musb/am35x.c                                            |    6=
=20
 drivers/usb/serial/ark3116.c                                        |   26=
 -
 drivers/usb/serial/belkin_sa.c                                      |   31=
 +-
 drivers/usb/serial/cp210x.c                                         |   41=
 +-
 drivers/usb/serial/cyberjack.c                                      |   48=
 +--
 drivers/usb/serial/cypress_m8.c                                     |   82=
 ++---
 drivers/usb/serial/f81232.c                                         |   43=
 +-
 drivers/usb/serial/garmin_gps.c                                     |   24=
 -
 drivers/usb/serial/io_edgeport.c                                    |   54=
 +--
 drivers/usb/serial/io_tables.h                                      |    8=
=20
 drivers/usb/serial/io_ti.c                                          |   91=
 +++---
 drivers/usb/serial/iuu_phoenix.c                                    |   84=
 ++---
 drivers/usb/serial/keyspan_pda.c                                    |   30=
 +-
 drivers/usb/serial/kl5kusb105.c                                     |   66=
 +---
 drivers/usb/serial/kobil_sct.c                                      |   23=
 -
 drivers/usb/serial/option.c                                         |   84=
 ++++-
 drivers/usb/serial/oti6858.c                                        |   68=
 +---
 drivers/usb/serial/pl2303.c                                         |   90=
 +++---
 drivers/usb/serial/spcp8x5.c                                        |   46=
 +--
 drivers/usb/serial/ssu100.c                                         |   34=
 +-
 drivers/usb/serial/ti_usb_3410_5052.c                               |   88=
 ++----
 fs/ext4/balloc.c                                                    |    8=
=20
 fs/ext4/bitmap.c                                                    |    6=
=20
 fs/ext4/ext4.h                                                      |    4=
=20
 fs/ext4/extents.c                                                   |   57=
 +++
 fs/ext4/ialloc.c                                                    |    4=
=20
 fs/ext4/mballoc.c                                                   |   14=
=20
 fs/ext4/resize.c                                                    |    3=
=20
 fs/lockd/clntxdr.c                                                  |    2=
=20
 fs/lockd/svcproc.c                                                  |    3=
=20
 fs/proc/stat.c                                                      |   14=
=20
 include/linux/if_vlan.h                                             |    8=
=20
 include/linux/netlink.h                                             |   21=
 +
 include/linux/skbuff.h                                              |   24=
 -
 include/net/flow.h                                                  |    1=
=20
 include/net/route.h                                                 |    3=
=20
 include/rdma/rdma_netlink.h                                         |    1=
=20
 kernel/cgroup.c                                                     |   41=
 --
 kernel/sys.c                                                        |   12=
=20
 kernel/trace/ring_buffer.c                                          |    4=
=20
 net/8021q/vlan_core.c                                               |   10=
=20
 net/core/dev.c                                                      |    7=
=20
 net/core/neighbour.c                                                |    6=
=20
 net/core/skbuff.c                                                   |   47=
 ---
 net/ipv4/fib_frontend.c                                             |    3=
=20
 net/ipv4/fib_semantics.c                                            |    2=
=20
 net/ipv4/inet_connection_sock.c                                     |    4=
=20
 net/ipv4/ip_forward.c                                               |    2=
=20
 net/ipv4/ip_output.c                                                |    4=
=20
 net/ipv4/route.c                                                    |  146=
 +++++-----
 net/ipv4/tcp_ipv4.c                                                 |    7=
=20
 net/ipv4/xfrm4_policy.c                                             |    1=
=20
 net/ipv6/addrconf.c                                                 |   15=
 -
 net/ipv6/af_inet6.c                                                 |   11=
=20
 net/ipv6/tcp_ipv6.c                                                 |    3=
=20
 net/mac80211/mesh_sync.c                                            |    3=
=20
 net/netfilter/ipvs/ip_vs_xmit.c                                     |    8=
=20
 net/netlink/af_netlink.c                                            |   29=
 +
 net/rds/send.c                                                      |    2=
=20
 net/sunrpc/cache.c                                                  |    4=
=20
 net/sunrpc/xprtsock.c                                               |    1=
=20
 103 files changed, 1060 insertions(+), 1006 deletions(-)

Al Viro (1):
      sparc64: fix ptrace interaction with force_successful_syscall_return()

Alan Stern (1):
      USB: fix port probing and removal in garmin_gps

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

Bryan Schumaker (1):
      SUNRPC: Set alloc_slot for backchannel tcp ops

Chris Metcalf (1):
      arch/tile: avoid generating .eh_frame information in modules

Chris Wilson (1):
      drm/i915: Use cpu relocations if the object is in the GTT but not map=
pable

Chris Zankel (1):
      xtensa: add missing system calls to the syscall table

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Dan Carpenter (1):
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

Daniel J Blueman (1):
      x86, amd, mce: Avoid NULL pointer reference on CPU northbridge lookup

David S. Miller (2):
      sparc64: Like x86 we should check current->mm during perf backtrace g=
eneration.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler

Devin Heitmueller (1):
      media: au0828: fix case where STREAMOFF being called on stopped strea=
m causes BUG()

Dmitry Monakhov (1):
      ext4: race-condition protection for ext4_convert_unwritten_extents_en=
dio

Eric Dumazet (3):
      net: remove skb recycling
      ipv6: GRO should be ECN friendly
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
      Linux 3.6.4

Guenter Roeck (1):
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Haojian Zhuang (1):
      pinctrl: remove mutex lock in groups show

Heiko Carstens (1):
      s390: fix linker script for 31 bit builds

Henrik Rydberg (1):
      usbdevfs: Fix broken scatter-gather transfer

Hiro Sugawara (1):
      iommu/tegra: smmu: Fix deadly typo

Jacob Shin (1):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from d=
irect mapping.

Johan Hovold (19):
      USB: io_ti: fix port-data memory leak
      USB: io_ti: fix sysfs-attribute creation
      USB: cyberjack: fix port-data memory leak
      USB: iuu_phoenix: fix port-data memory leak
      USB: iuu_phoenix: fix sysfs-attribute creation
      USB: ark3116: fix NULL-pointer dereference
      USB: f81232: fix port-data memory leak
      USB: oti6858: fix port-data memory leak
      USB: belkin_sa: fix port-data memory leak
      USB: pl2303: fix port-data memory leak
      USB: ssu100: fix port-data memory leak
      USB: kobil_sct: fix port-data memory leak
      USB: cypress_m8: fix port-data memory leak
      USB: cp210x: fix port-data memory leak
      USB: spcp8x5: fix port-data memory leak
      USB: ti_usb_3410_5052: fix port-data memory leak
      USB: kl5kusb105: fix port-data memory leak
      USB: io_edgeport: fix port-data memory leak
      USB: keyspan_pda: fix port-data memory leak

Julian Anastasov (6):
      ipv4: fix sending of redirects
      ipv4: fix forwarding for strict source routes
      ipv4: make sure nh_pcpu_rth_output is always allocated
      ipv4: introduce rt_uses_gateway
      ipv4: Add FLOWI_FLAG_KNOWN_NH
      ipvs: fix ARP resolving for direct routing mode

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

Pritesh Raithatha (3):
      pinctrl: tegra: correct bank for pingroup and drv pingroup
      dt: Document: correct tegra20/30 pinctrl slew-rate name
      pinctrl: tegra: set low power mode bank width to 2

Sarah Sharp (3):
      usb: Don't enable LPM if the exit latency is zero.
      USB: Enable LPM after a failed probe.
      usb: Send Set SEL before enabling parent U1/U2 timeout.

Sasha Levin (1):
      SUNRPC: Prevent kernel stack corruption on long values of flush

Stefano Babic (1):
      usb: musb: am35xx: drop spurious unplugging a device

Steffen Klassert (3):
      ipv4: Always invalidate or update the route on pmtu events
      ipv4: Don't create nh exeption when the device mtu is smaller than th=
e reported pmtu
      ipv4: Don't report stale pmtu values to userspace

Tao Ma (1):
      ext4: Checksum the block bitmap properly with bigalloc enabled

Tejun Heo (2):
      Revert "cgroup: Remove task_lock() from cgroup_post_fork()"
      Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"

Thomas Pedersen (1):
      mac80211: call drv_get_tsf() in sleepable context

Trond Myklebust (1):
      NLM: nlm_lookup_file() may return NLMv4-specific error codes

Vaibhav Nagarnaik (1):
      ring-buffer: Check for uninitialized cpu buffer before resizing

Wei Yongjun (1):
      pinctrl: fix missing unlock on error in pinctrl_groups_show()

jeff.liu (1):
      RDS: fix rds-ping spinlock recursion

ramesh.nagappa@gmail.com (1):
      net: Fix skb_under_panic oops in neigh_resolve_output


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQjXOMAAoJEDjbvchgkmk++awP/3tCv72jyuKm9/BSyUNq1oyD
A7vfNRJ41Ia2BqcJykys2Ee7dJ5jKSjOGlRMAWpRHARQLgcK+jjwsQAvZ37Hpm8E
yfNkhj5+YiNI9fzOv6xfmhiGLw2Mw7m8KnTTzXrNGuVHyLTr4neYR9nF778ILtgr
/bOvnwaUW/4vLpCkStu/w9p+XkgXCSl+PIdtX4MAVbxY+1klYmbd2TL53xj0/v7/
RgceWdg3rFuxDauimcbjukgUIZaVU853w+jM6gjCbegUQus48szHOL+MDPBPorg3
h1owRmpvfrA8Me9bDxi5w6ysskdyf2ymRpHLWHFZufF6zaYDWlsrNJsOBDKyTgAm
JNGyHXPsA27p1tNk56EEJbOCwDvhobmCHXn7VulanoD31qhzfBCkefrBGNT0NKM7
v15ApvSoAbsqZZBL22YWGFzwbWScBzdgGiZkISUEX/zkWcRlyHL8FawpXrXKJboB
ir1hoM8SuqVnBVeXYgyuYg7q0gyLLeoT3jOvfRPNTXFUOEVvupv9B8Jo9rF5AO8G
qjVOdojIFs8aA5a3IoVLKBAZShXN0XmDLV62UNL76mWqoeuWFXAru5/fDBqZi2Up
mV0/OvqBt12z+qFZ9/mN1Q0eR24wjzDoeP1szaDD8vhX98YlELCCKG+VaP5x3iAP
jZ08ux0kLO2/6IaW94od
=HaKL
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
