Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1GIGWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:22:43 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35296 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab1GIGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:22:41 -0400
X-Sasl-enc: /HqyQQbnFKioU00NbMTOwO3N7KOJOcHTqClWRKZ7vGnn 1310192560
Date: Fri, 8 Jul 2011 23:22:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.39.3
Message-ID: <20110709062220.GA15697@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.39.3 kernel.

All users of the 2.6.39 kernel series must upgrade.

The updated 2.6.39.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.39.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.39.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/caching/netfs-api.txt  |   16 ++++++
 Makefile                                         |    2 
 arch/arm/mach-exynos4/init.c                     |    1 
 arch/arm/plat-samsung/include/plat/regs-serial.h |    2 
 arch/x86/include/asm/pvclock.h                   |    9 ++-
 arch/x86/kernel/acpi/realmode/wakeup.S           |   14 +++++
 arch/x86/kernel/acpi/realmode/wakeup.h           |    6 ++
 arch/x86/kernel/acpi/sleep.c                     |    6 ++
 arch/x86/oprofile/nmi_int.c                      |   14 +++--
 arch/x86/pci/xen.c                               |   40 +++++++++++----
 arch/x86/xen/mmu.c                               |   14 ++++-
 arch/x86/xen/smp.c                               |    7 ++
 block/cfq-iosched.c                              |   11 +++-
 drivers/base/platform.c                          |    2 
 drivers/base/power/main.c                        |   28 ++++++++--
 drivers/connector/connector.c                    |    1 
 drivers/gpu/drm/drm_pci.c                        |    3 -
 drivers/gpu/drm/i915/i915_irq.c                  |   11 ++++
 drivers/gpu/drm/i915/i915_reg.h                  |    1 
 drivers/gpu/drm/i915/intel_i2c.c                 |    3 -
 drivers/gpu/drm/radeon/radeon_encoders.c         |    6 +-
 drivers/gpu/drm/radeon/rv770.c                   |    6 ++
 drivers/hwmon/ibmaem.c                           |    2 
 drivers/hwmon/ibmpex.c                           |    1 
 drivers/hwmon/s3c-hwmon.c                        |    2 
 drivers/i2c/busses/i2c-taos-evm.c                |    8 +--
 drivers/i2c/muxes/pca954x.c                      |    7 +-
 drivers/input/input.c                            |    2 
 drivers/input/mousedev.c                         |    4 -
 drivers/md/md.c                                  |    1 
 drivers/media/rc/ir-raw.c                        |    4 +
 drivers/media/rc/ite-cir.c                       |   12 +++-
 drivers/media/rc/ite-cir.h                       |    3 +
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c   |   58 ++++++++++------------
 drivers/media/video/uvc/uvc_queue.c              |    2 
 drivers/misc/lkdtm.c                             |    8 +++
 drivers/mmc/host/tmio_mmc_pio.c                  |    4 -
 drivers/net/hamradio/6pack.c                     |    4 -
 drivers/net/hamradio/mkiss.c                     |    4 -
 drivers/net/pxa168_eth.c                         |    2 
 drivers/net/wireless/ath/ath5k/base.c            |   11 +++-
 drivers/net/wireless/ath/ath5k/eeprom.c          |    8 +--
 drivers/net/wireless/ath/ath5k/reset.c           |    5 +
 drivers/net/wireless/ath/ath9k/pci.c             |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.c          |    3 -
 drivers/pci/pci-driver.c                         |    4 +
 drivers/pci/quirks.c                             |    2 
 drivers/staging/lirc/lirc_zilog.c                |    4 -
 drivers/tty/serial/pch_uart.c                    |    4 +
 drivers/tty/serial/s5pv210.c                     |    4 -
 drivers/tty/tty_ldisc.c                          |    4 +
 drivers/usb/core/driver.c                        |   17 ++++--
 drivers/usb/core/hub.c                           |   16 ++++--
 drivers/usb/core/message.c                       |   26 +++++++++
 drivers/usb/host/xhci-pci.c                      |    8 +++
 drivers/usb/host/xhci-ring.c                     |   11 ++--
 drivers/usb/host/xhci.c                          |   24 +++++++--
 drivers/usb/host/xhci.h                          |    1 
 drivers/usb/serial/ftdi_sio.c                    |   19 +++++--
 drivers/usb/serial/ftdi_sio.h                    |    3 -
 drivers/usb/serial/ftdi_sio_ids.h                |    1 
 drivers/watchdog/mtx-1_wdt.c                     |    8 +++
 fs/block_dev.c                                   |   14 ++++-
 fs/cifs/fscache.c                                |    1 
 fs/fscache/page.c                                |   44 ++++++++++++++++
 fs/hfsplus/wrapper.c                             |    7 +-
 fs/lockd/clntproc.c                              |    8 ++-
 fs/locks.c                                       |   30 +++++++----
 fs/nfs/fscache.c                                 |    8 +--
 fs/nfs/inode.c                                   |    6 +-
 fs/nfs/internal.h                                |   11 ++++
 fs/nfs/nfs4filelayout.c                          |   15 +++--
 fs/nfs/nfs4proc.c                                |   33 ++++++++----
 fs/nfs/nfs4xdr.c                                 |   14 ++---
 fs/nfsd/Kconfig                                  |    1 
 fs/nfsd/nfsctl.c                                 |   19 ++-----
 fs/nfsd/vfs.c                                    |   19 ++++---
 include/asm-generic/bug.h                        |    3 -
 include/linux/blk_types.h                        |    2 
 include/linux/clocksource.h                      |    1 
 include/linux/connector.h                        |    2 
 include/linux/device.h                           |    4 -
 include/linux/fscache.h                          |   21 ++++++++
 include/linux/if_packet.h                        |    2 
 include/linux/netfilter/ipset/ip_set_ahash.h     |    4 -
 include/linux/netfilter/ipset/ip_set_timeout.h   |   18 +++---
 include/linux/pci_ids.h                          |    1 
 include/linux/pm.h                               |    3 -
 include/linux/ratelimit.h                        |   40 +++++++++++++++
 include/linux/sunrpc/gss_krb5_enctypes.h         |    4 +
 include/linux/sunrpc/sched.h                     |    3 -
 include/net/ip_vs.h                              |    3 -
 init/calibrate.c                                 |   14 +++--
 kernel/power/snapshot.c                          |    6 +-
 kernel/power/user.c                              |    4 +
 kernel/taskstats.c                               |   15 ++++-
 kernel/time/clocksource.c                        |   24 ++++-----
 lib/debugobjects.c                               |    2 
 mm/hugetlb.c                                     |    8 +++
 mm/ksm.c                                         |    6 ++
 mm/memory-failure.c                              |    4 +
 mm/memory_hotplug.c                              |    2 
 mm/migrate.c                                     |    2 
 net/8021q/vlan_dev.c                             |    2 
 net/bridge/br_netfilter.c                        |    6 ++
 net/core/ethtool.c                               |   25 +++++++++
 net/core/filter.c                                |    5 +
 net/ipv4/af_inet.c                               |    3 +
 net/ipv4/inet_diag.c                             |   14 ++---
 net/ipv4/inetpeer.c                              |   42 ++++++++++------
 net/ipv4/netfilter.c                             |   60 ++++++++---------------
 net/ipv4/netfilter/ipt_REJECT.c                  |   14 +----
 net/ipv4/route.c                                 |    4 -
 net/ipv4/udp.c                                   |    3 +
 net/ipv6/udp.c                                   |    5 +
 net/netfilter/ipset/ip_set_core.c                |    2 
 net/netfilter/ipvs/ip_vs_conn.c                  |   10 +++
 net/netfilter/ipvs/ip_vs_core.c                  |    1 
 net/netfilter/ipvs/ip_vs_ftp.c                   |   27 +++++++---
 net/packet/af_packet.c                           |    2 
 net/sunrpc/auth_gss/auth_gss.c                   |    4 -
 net/sunrpc/auth_gss/gss_krb5_mech.c              |    3 -
 net/sunrpc/clnt.c                                |    5 +
 net/sunrpc/sched.c                               |    1 
 net/xfrm/xfrm_replay.c                           |    4 -
 security/keys/request_key.c                      |    3 -
 sound/pci/hda/patch_conexant.c                   |    3 +
 sound/pci/hda/patch_realtek.c                    |    1 
 sound/soc/pxa/pxa2xx-pcm.c                       |    4 -
 virt/kvm/assigned-dev.c                          |    5 -
 130 files changed, 871 insertions(+), 335 deletions(-)

Alan Stern (6):
      PM: Rename dev_pm_info.in_suspend to is_prepared
      PM: Fix async resume following suspend failure
      USB: don't let errors prevent system sleep
      USB: don't let the hub driver prevent system sleep
      USB: fix regression occurring during device removal
      USB: additional regression fix for device removal

Alex Deucher (2):
      drm/radeon/kms/atom: fix duallink on some early DCE3.2 cards
      drm/radeon/kms: Fix chremap setup on RV770 CE

Alex Williamson (1):
      Revert "KVM: Save/restore state of assigned PCI device"

Alexander Holler (1):
      bridge: provide a cow_metrics method for fake_ops

Alexander Stein (1):
      drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info returns NULL

Andrea Arcangeli (1):
      migrate: don't account swapcache as shmem

Andrew Jones (1):
      xen: support CONFIG_MAXSMP

Andrew Morton (1):
      drivers/base/platform.c: don't mark platform_device_register_resndata() as __init_or_module

Andy Adamson (2):
      NFSv4.1: allow nfs_fhget to succeed with mounted on fileid
      NFSv4.1: allow zero fh array in filelayout decode layout

Arnd Bergmann (1):
      6pack,mkiss: fix lock inconsistency

Boojin Kim (1):
      ARM: SAMSUNG: serial: Fix on handling of one clock source for UART

Casey Bodley (1):
      nfsd: link returns nfserr_delay when breaking lease

Chris Wilson (1):
      drm/i915: Apply HWSTAM workaround for BSD ring on SandyBridge

Daniel J Blueman (1):
      drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.

Daniel Mack (1):
      ASoC: pxa-ssp: Correct check for stream presence

David Henningsson (2):
      ALSA: HDA: Remove quirk for an HP device
      ALSA: HDA: Add a new Conexant codec ID (506c)

David Howells (2):
      KEYS: Fix error handling in construct_key_and_link()
      FS-Cache: Add a helper to bulk uncache pages on an inode

David Rientjes (1):
      mm, hotplug: fix error handling in mem_online_node()

David S. Miller (2):
      bug.h: Fix build with CONFIG_PRINTK disabled.
      bug.h: Move ratelimit warn interfaces to ratelimit.h

Eric Dumazet (4):
      inetpeer: fix race in unused_list manipulations
      af_packet: prevent information leak
      inet_diag: fix inet_diag_bc_audit()
      ipv4: fix multicast losses

Eugene A. Shatokhin (1):
      ath5k: fix memory leak when fewer than N_PD_CURVES are in use

Florian Fainelli (1):
      watchdog: mtx1-wdt: request gpio before using it

Greg Kroah-Hartman (1):
      Linux 2.6.39.3

Guennadi Liakhovetski (1):
      mmc: tmio: fix regression in TMIO_MMC_WRPROTECT_DISABLE handling

Guenter Roeck (3):
      hwmon: (ibmaem) Initialize sysfs attributes
      hwmon: (s3c) Initialize sysfs attributes
      hwmon: (ibmpex) Initialize sysfs attributes

Hans Petter Selasky (1):
      Input: properly assign return value of clamp() macro.

Hans Schillstrom (2):
      IPVS: bug in ip_vs_ftp, same list heaad used in all netns.
      IPVS netns exit causes crash in conntrack

Hugh Dickins (1):
      ksm: fix NULL pointer dereference in scan_get_next_rmap_item()

J. Bruce Fields (2):
      nfsd: fix dependency of nfsd on auth_rpcgss
      nfsd4: fix break_lease flags on nfsd open

Jarod Wilson (4):
      rc: fix ghost keypresses with certain hw
      lirc_zilog: fix spinning rx thread
      keymaps: fix table for pinnacle pctv hd devices
      ite-cir: 8709 needs to use pnp resource 2

Jean Delvare (2):
      Revert "drm/i915: Enable GMBUS for post-gen2 chipsets"
      i2c-taos-evm: Fix log messages

Jens Axboe (1):
      cfq-iosched: fix locking around ioc->ioc_data assignment

Jiri Slaby (1):
      TTY: ldisc, do not close until there are readers

Joe Perches (2):
      bug.h: Add WARN_RATELIMIT
      net: filter: Use WARN_RATELIMIT

Johannes Berg (1):
      iwlagn: fix change_interface for P2P types

Josh Hunt (1):
      drivers/misc/lkdtm.c: fix race when crashpoint is hit multiple times before checking count

Jozsef Kadlecsik (3):
      netfilter: ipset: Use proper timeout value to jiffies conversion
      netfilter: ipset: remove unused variable from type_pf_tdel()
      netfilter: ipset: fix ip_set_flush return code

Julian Anastasov (1):
      netfilter: Fix ip_route_me_harder triggering ip_rt_bug

K. Y. Srinivasan (2):
      Connector: Set the CN_NETLINK_USERS correctly
      Connector: Correctly set the error code in case of success when dispatching receive callbacks

Kees Cook (1):
      x86, suspend: Restore MISC_ENABLE MSR in realmode wakeup

Konrad Rzeszutek Wilk (3):
      xen/pci: Use the INT_SRC_OVR IRQ (instead of GSI) to preset the ACPI SCI IRQ.
      xen/mmu: Fix for linker errors when CONFIG_SMP is not defined.
      xen/pci: Move check for acpi_sci_override_gsi to xen_setup_acpi_sci.

Maarten Lankhorst (1):
      xhci: Add reset on resume quirk for asrock p67 host

Manoj Iyer (1):
      mmc: Add PCI fixup quirks for Ricoh 1180:e823 reader

Marcin Slusarz (1):
      debugobjects: Fix boot crash when kmemleak and debugobjects enabled

Marcus Meissner (1):
      net/ipv4: Check for mistakenly passed in non-IPv4 address

Michal Kubecek (1):
      PM: Free memory bitmaps if opening /dev/snapshot fails

Michał Mirosław (1):
      net: fix ETHTOOL_SFEATURES compatibility with old ethtool_ops.set_flags

Miklos Szeredi (1):
      fs: fix lock initialization

Minchan Kim (1):
      mm/memory-failure.c: fix page isolated count mismatch

Namhyung Kim (1):
      block: add REQ_SECURE to REQ_COMMON_MASK

NeilBrown (1):
      md: avoid endless recovery loop when waiting for fail device to complete.

Nick Kossifidis (1):
      ath5k: Disable fast channel switching by default

Peng Tao (1):
      NFS41: do not update isize if inode needs layoutcommit

Petri Gynther (1):
      i2c/pca954x: Initialize the mux to disconnected state

Rafael Aquini (1):
      mm: fix negative commitlimit when gigantic hugepages are allocated

Rafael J. Wysocki (2):
      PCI / PM: Block races between runtime PM and system sleep
      PM / Hibernate: Fix free_unnecessary_pages()

Rajkumar Manoharan (1):
      ath9k: Fix suspend/resume when no interface is UP

Randy Dunlap (1):
      nfsd: v4 support requires CRYPTO

Richard Cochran (1):
      pxa168_eth: fix race in transmit path.

Robert Richter (1):
      oprofile, x86: Fix race in nmi handler while starting counters

Russell King (1):
      Fix CPU spinlock lockups on secondary CPU bringup

Sarah Sharp (3):
      xhci: Reject double add of active endpoints.
      xhci: Always set urb->status to zero for isoc endpoints.
      USB: Free bandwidth when usb_disable_device is called.

Seth Forshee (1):
      hfsplus: add missing call to bio_put()

Shaohua Li (2):
      cfq-iosched: fix a rcu warning
      cfq-iosched: make code consistent

Sjoerd Simons (1):
      uvcvideo: Remove buffers from the queues when freeing

Stefano Stabellini (1):
      xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"

Steffen Klassert (1):
      xfrm: Fix off by one in the replay advance functions

Tejun Heo (1):
      block: use the passed in @bdev when claiming if partno is zero

Thomas Gleixner (1):
      clocksource: Make watchdog robust vs. interruption

Trond Myklebust (3):
      NFSv4: Fix a readdir regression
      SUNRPC: Ensure the RPC client only quits on fatal signals
      NLM: Don't hang forever on NLM unlock requests

Uwe Bonnes (1):
      USB: Add new FT232H chip to drivers/usb/serial/ftdi_sio.c

Vasiliy Kulikov (1):
      taskstats: don't allow duplicate entries in listener mode

Wei Yongjun (1):
      vlan: fix typo in vlan_dev_hard_start_xmit()

Wolfram Sang (1):
      drm: populate irq_by_busid-member for pci

Xufeng Zhang (2):
      ipv6/udp: Use the correct variable to determine non-blocking condition
      udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet

Zachary Amsden (1):
      KVM: Fix register corruption in pvclock_scale_delta

