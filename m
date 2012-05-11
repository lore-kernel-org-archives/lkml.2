Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137Ab2EKXok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:44:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759000Ab2EKXoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:44:34 -0400
Message-ID: <1336779865.8274.476.camel@deadeye>
Subject: Linux 3.2.17
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sat, 12 May 2012 00:44:25 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2enZ+lUkzFnR06FVIbXo"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 91.103.132.49
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2enZ+lUkzFnR06FVIbXo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.17 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                       |    2 +-
 arch/arm/Kconfig                               |    9 +
 arch/arm/include/asm/tls.h                     |    4 +
 arch/arm/kernel/irq.c                          |    6 +-
 arch/arm/kernel/smp.c                          |    4 +-
 arch/arm/kernel/sys_arm.c                      |    2 +-
 arch/arm/mach-omap1/timer.c                    |    4 +-
 arch/arm/mm/abort-ev6.S                        |   17 +-
 arch/arm/mm/cache-l2x0.c                       |   25 ++-
 arch/x86/boot/compressed/relocs.c              |    2 -
 arch/x86/kernel/apic/apic.c                    |   34 +--
 arch/x86/kernel/microcode_core.c               |    4 +-
 arch/x86/kernel/setup_percpu.c                 |   14 +-
 arch/x86/xen/enlighten.c                       |    7 +-
 arch/x86/xen/mmu.c                             |    7 +-
 arch/x86/xen/smp.c                             |   15 ++
 arch/x86/xen/xen-asm.S                         |    2 +-
 crypto/sha512_generic.c                        |    2 +-
 drivers/ata/libata-eh.c                        |    3 +-
 drivers/bluetooth/ath3k.c                      |    2 +
 drivers/bluetooth/btusb.c                      |    1 +
 drivers/dma/at_hdmac.c                         |    4 -
 drivers/firmware/efivars.c                     |  196 +++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_execbuffer.c     |   40 ++--
 drivers/gpu/drm/i915/i915_reg.h                |    2 +
 drivers/gpu/drm/i915/intel_hdmi.c              |    2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c        |   16 ++
 drivers/gpu/drm/i915/intel_sdvo.c              |   40 ++--
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c         |    4 +-
 drivers/hwmon/coretemp.c                       |    6 +-
 drivers/hwmon/fam15h_power.c                   |   42 ++++
 drivers/i2c/busses/i2c-pnx.c                   |    3 +-
 drivers/md/md.c                                |    3 +-
 drivers/media/dvb/frontends/drxk_hard.c        |    6 +-
 drivers/media/rc/winbond-cir.c                 |    1 +
 drivers/mmc/card/block.c                       |   54 +++--
 drivers/mmc/card/queue.c                       |    2 +-
 drivers/mmc/core/core.c                        |    9 +-
 drivers/mmc/host/sdhci-esdhc-imx.c             |    3 +-
 drivers/net/bonding/bond_main.c                |    6 +-
 drivers/net/dummy.c                            |    6 +-
 drivers/net/ethernet/atheros/atlx/atl1.c       |   12 +-
 drivers/net/ethernet/atheros/atlx/atl1.h       |    3 +-
 drivers/net/ethernet/atheros/atlx/atlx.c       |    2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c       |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c          |    2 +-
 drivers/net/ethernet/realtek/8139cp.c          |   10 +-
 drivers/net/ethernet/smsc/smsc911x.c           |   14 +-
 drivers/net/ethernet/ti/davinci_mdio.c         |    5 +
 drivers/net/ppp/ppp_generic.c                  |    3 +-
 drivers/net/usb/smsc75xx.c                     |    1 +
 drivers/net/usb/smsc95xx.c                     |    2 +-
 drivers/net/wimax/i2400m/netdev.c              |    3 +-
 drivers/net/wireless/b43/main.c                |   10 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 +
 drivers/net/wireless/ipw2x00/ipw2200.c         |   13 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c        |   16 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |   11 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |    3 -
 drivers/net/wireless/iwlwifi/iwl-core.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h          |   24 ++-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |   27 ++-
 drivers/net/wireless/mwifiex/pcie.h            |   18 +-
 drivers/net/wireless/rt2x00/rt2800usb.c        |   28 +--
 drivers/net/wireless/rtlwifi/pci.c             |    1 +
 drivers/net/wireless/wl1251/main.c             |    1 +
 drivers/net/wireless/wl1251/sdio.c             |    2 +-
 drivers/pci/quirks.c                           |   34 +++
 drivers/platform/x86/dell-laptop.c             |   29 +++
 drivers/scsi/libsas/sas_expander.c             |   26 ++-
 drivers/spi/spi-fsl-spi.c                      |    4 +-
 drivers/spi/spi.c                              |    2 +-
 drivers/staging/rtl8712/os_intfs.c             |    3 -
 drivers/staging/rtl8712/usb_intf.c             |    5 +
 drivers/tty/amiserial.c                        |    4 +-
 drivers/tty/serial/clps711x.c                  |   14 +-
 drivers/tty/serial/pch_uart.c                  |    4 +-
 drivers/usb/class/cdc-wdm.c                    |    7 +-
 drivers/usb/core/hcd-pci.c                     |    9 +
 drivers/usb/core/hub.c                         |    3 -
 drivers/usb/core/message.c                     |    6 +-
 drivers/usb/dwc3/ep0.c                         |    3 +-
 drivers/usb/gadget/dummy_hcd.c                 |    1 -
 drivers/usb/gadget/f_fs.c                      |    2 +-
 drivers/usb/gadget/f_mass_storage.c            |    2 +-
 drivers/usb/gadget/file_storage.c              |    2 +-
 drivers/usb/gadget/udc-core.c                  |    6 +-
 drivers/usb/gadget/uvc.h                       |    2 +-
 drivers/usb/gadget/uvc_v4l2.c                  |    2 +-
 drivers/usb/host/ehci-hcd.c                    |    9 +-
 drivers/usb/host/ehci-pci.c                    |    8 +
 drivers/usb/misc/yurex.c                       |   10 +-
 drivers/usb/musb/omap2430.c                    |    9 +-
 drivers/usb/serial/cp210x.c                    |    9 +-
 drivers/usb/serial/sierra.c                    |    6 +-
 drivers/uwb/hwa-rc.c                           |    3 +-
 drivers/uwb/neh.c                              |   12 +-
 drivers/xen/gntdev.c                           |    2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c     |   69 ++++--
 fs/autofs4/autofs_i.h                          |   12 +-
 fs/autofs4/dev-ioctl.c                         |    3 +-
 fs/autofs4/inode.c                             |    4 +-
 fs/autofs4/waitq.c                             |   22 +-
 fs/btrfs/ctree.h                               |    2 +-
 fs/cifs/cifssmb.c                              |    6 +-
 fs/eventpoll.c                                 |    4 +
 fs/exec.c                                      |    3 +
 fs/ext4/extents.c                              |    2 +-
 fs/hfsplus/catalog.c                           |    4 +
 fs/hfsplus/dir.c                               |   11 +
 fs/jbd2/commit.c                               |    4 +-
 fs/lockd/clnt4xdr.c                            |    2 +-
 fs/lockd/clntxdr.c                             |    2 +-
 fs/nfs/nfs4proc.c                              |   23 +-
 fs/nfs/read.c                                  |    2 +-
 fs/nfs/super.c                                 |    8 +-
 fs/nfs/write.c                                 |    2 +-
 fs/nfsd/nfs3xdr.c                              |   22 +-
 fs/nfsd/nfs4proc.c                             |   15 +-
 fs/nfsd/nfs4state.c                            |   23 +-
 fs/nfsd/nfs4xdr.c                              |    2 +-
 fs/nfsd/vfs.c                                  |    2 +-
 fs/ocfs2/alloc.c                               |    2 +-
 fs/ocfs2/refcounttree.c                        |   12 +-
 fs/ocfs2/suballoc.c                            |    4 +-
 fs/pipe.c                                      |   31 ++-
 fs/splice.c                                    |    5 +-
 include/asm-generic/statfs.h                   |    2 +-
 include/linux/efi.h                            |   13 +-
 include/linux/kvm_host.h                       |    6 +
 include/linux/netdevice.h                      |    2 -
 include/linux/pipe_fs_i.h                      |    1 +
 include/linux/seqlock.h                        |    2 +-
 include/linux/skbuff.h                         |   13 ++
 include/linux/socket.h                         |    2 +-
 include/linux/usb/hcd.h                        |    2 +
 kernel/exit.c                                  |   19 --
 kernel/power/swap.c                            |   28 ++-
 kernel/sched.c                                 |   75 ++++---
 kernel/signal.c                                |    9 +
 kernel/trace/trace_output.c                    |    5 +
 mm/swap_state.c                                |    2 +-
 net/ax25/af_ax25.c                             |    9 +-
 net/bridge/br_multicast.c                      |   81 -------
 net/bridge/br_private.h                        |    4 -
 net/core/dev.c                                 |   58 ++---
 net/core/dev_addr_lists.c                      |    3 +-
 net/core/net_namespace.c                       |   33 +--
 net/core/skbuff.c                              |    8 +-
 net/ipv4/tcp.c                                 |   10 +-
 net/ipv4/tcp_input.c                           |    8 +-
 net/ipv4/tcp_output.c                          |   16 +-
 net/ipv6/mcast.c                               |    2 +-
 net/ipv6/tcp_ipv6.c                            |    4 +
 net/mac80211/tx.c                              |    3 +-
 net/netlink/af_netlink.c                       |   24 ++-
 net/phonet/pep.c                               |    3 +
 net/sched/sch_gred.c                           |    7 +-
 net/sctp/socket.c                              |    5 +-
 net/socket.c                                   |    6 +-
 net/wireless/nl80211.c                         |   29 +--
 net/wireless/util.c                            |    2 +-
 scripts/mod/file2alias.c                       |    4 +
 sound/pci/hda/patch_conexant.c                 |   37 +++-
 sound/pci/hda/patch_realtek.c                  |    1 +
 sound/soc/codecs/tlv320aic23.c                 |    4 +-
 sound/soc/codecs/wm8994.c                      |  276 +++++++++++++++++++-=
----
 sound/soc/soc-dapm.c                           |    2 +
 tools/perf/util/hist.c                         |    4 +-
 virt/kvm/iommu.c                               |   12 +-
 virt/kvm/kvm_main.c                            |    5 +-
 174 files changed, 1551 insertions(+), 700 deletions(-)

AceLan Kao (3):
      dell-laptop: add 3 machines that has touchpad LED
      dell-laptop: touchpad LED should persist its status after S3
      Bluetooth: Add support for Atheros [04ca:3005]

Adrian Hunter (2):
      mmc: fixes for eMMC v4.5 discard operation
      mmc: fixes for eMMC v4.5 sanitize operation

Al Viro (11):
      ext4: fix endianness breakage in ext4_split_extent_at()
      nfsd: fix b0rken error value for setattr on read-only mount
      nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fai=
ls
      nfsd: fix endianness breakage in TEST_STATEID handling
      nfsd: fix compose_entry_fh() failure exits
      btrfs: btrfs_root_readonly() broken on big-endian
      ocfs2: ->l_next_free_req breakage on big-endian
      ocfs: ->rl_used breakage on big-endian
      ocfs2: ->rl_count endianness breakage
      ocfs2: ->e_leaf_clusters endianness breakage
      lockd: fix the endianness bug

Alan Cox (1):
      rt2800: Add support for the Fujitsu Stylistic Q550

Alan Stern (6):
      EHCI: fix criterion for resuming the root hub
      EHCI: always clear the STS_FLR status bit
      USB: fix deadlock in bConfigurationValue attribute method
      usb: gadget: udc-core: fix incompatibility with dummy-hcd
      USB: EHCI: fix crash during suspend on ASUS computers
      USB: gadget: storage gadgets send wrong error code for unknown comman=
ds

Alex Deucher (1):
      drm/radeon/kms: need to set up ss on DP bridges as well

Alex Williamson (1):
      KVM: unmap pages from the iommu when slots are removed

Alexander Shiyan (1):
      ARM: clps711x: serial driver hungs are a result of call disable_irq w=
ithin ISR

Alexey Khoroshilov (1):
      drxk: Does not unlock mutex if sanity check failed in scu_command()

Andre Przywara (1):
      hwmon: fam15h_power: fix bogus values with current BIOSes

Andreas Herrmann (1):
      x86, microcode: Fix sysfs warning during module unload on unsupported=
 CPUs

Andrzej Pietrasiewicz (1):
      usb: gadget: eliminate NULL pointer dereference (bugfix)

Arend van Spriel (1):
      brcm80211: smac: resume transmit fifo upon receiving frames

Ben Hutchings (1):
      Linux 3.2.17

Ben Widawsky (2):
      drm/i915: relative_constants_mode race fix
      drm/i915: Force sync command ordering (Gen6+)

Bing Zhao (1):
      mwifiex: update pcie8766 scratch register addresses

Bj=C3=B8rn Mork (1):
      USB: sierra: avoid QMI/wwan interface on MC77xx

Bojan Smojver (1):
      PM / Hibernate: fix the number of pages used for hibernate/thaw buffe=
ring

Bryan O'Donoghue (1):
      x86, apic: APIC code touches invalid MSR on P5 class machines

Christian Riesch (1):
      davinci_mdio: Fix MDIO timeout check

Colin Cross (1):
      ARM: 7414/1: SMP: prevent use of the console when using idmap_pgd

Dan Carpenter (1):
      ksz884x: don't copy too much in netdev_set_mac_address()

Dan Williams (1):
      libsas: fix false positive 'device attached' conditions

Daniel Vetter (3):
      drm/i915: handle input/output sdvo timings separately in mode_set
      drm/i915: disable sdvo hotplug on i945g/gm
      drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+

Dave Airlie (1):
      nouveau: initialise has_optimus variable.

David Henningsson (1):
      ALSA: HDA: Add external mic quirk for Asus Zenbook UX31E

David H=C3=A4rdeman (1):
      rc-core: set mode for winbond-cir

David Miller (1):
      Fix modpost failures in fedora 17

David Vrabel (2):
      xen: correctly check for pending events when restoring irq flags
      xen/pci: don't use PCI BIOS service for configuration space accesses

David Ward (1):
      net_sched: gred: Fix oops in gred_dump() in WRED mode

David Woodhouse (1):
      ppp: Don't stop and restart queue on every TX packet

Davide Ciminaghi (1):
      net/ethernet: ks8851_mll fix rx frame buffer overflow

Eric B=C3=A9nard (2):
      mmc: unbreak sdhci-esdhc-imx on i.MX25
      ASoC: tlv312aic23: unbreak resume

Eric Dumazet (8):
      net: fix /proc/net/dev regression
      tcp: allow splice() to build full TSO packets
      netlink: fix races after skb queueing
      net: fix a race in sock_queue_err_skb()
      net: allow pskb_expand_head() to get maximum tailroom
      tcp: fix tcp_trim_head()
      tcp: avoid order-1 allocations on wifi and tx path
      tcp: fix tcp_grow_window() for large incoming frames

Eric W. Biederman (1):
      net ax25: Reorder ax25_exit to remove races.

Felipe Balbi (4):
      usb: gadget: udc-core: stop UDC on device-initiated disconnect
      usb: gadget: udc-core: fix wrong call order
      usb: dwc3: ep0: increment "actual" on bounced ep0 case
      usb: gadget: dummy: do not call pullup() on udc_stop()

Felix Fietkau (1):
      mac80211: fix AP mode EAP tx for VLAN stations

Fred Isaman (2):
      NFS: put open context on error in nfs_pagein_multi
      NFS: put open context on error in nfs_flush_multi

Gertjan van Wingerde (1):
      rt2x00: Identify rt2800usb chipsets.

Grazvydas Ignotas (2):
      wl1251: fix crash on remove due to premature kfree
      wl1251: fix crash on remove due to leftover work item

Greg Kroah-Hartman (1):
      hfsplus: Fix potential buffer overflows

Guenter Roeck (2):
      hwmon: (fam15h_power) Fix pci_device_id array
      hwmon: (coretemp) Increase CPU core limit

H. Peter Anvin (1):
      asm-generic: Use __BITS_PER_LONG in statfs.h

Herbert Xu (1):
      bridge: Do not send queries on multicast group leaves

Hiroaki SHIMODA (1):
      dummy: Add ndo_uninit().

Hugh Dickins (1):
      mm: fix s390 BUG by __set_page_dirty_no_writeback on swap

J. Bruce Fields (1):
      nfsd: don't fail unchecked creates of non-special files

Jan Kara (1):
      nfs: Enclose hostname in brackets when needed in nfs_do_root_mount

Jason Baron (1):
      Don't limit non-nested epoll paths

Jason Wang (1):
      8139cp: set intr mask after its handler is registered

Johannes Berg (3):
      nl80211: ensure interface is up in various APIs
      iwlwifi: fix hardware queue programming
      iwlagn: allow up to uCode API 6 for 6000 devices

Julia Lawall (1):
      drivers/tty/amiserial.c: add missing tty_unlock

Julian Anastasov (1):
      netns: do not leak net_generic data on failed init

Kenneth Graunke (1):
      drm/i915: Set the Stencil Cache eviction policy to non-LRA mode.

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Kenth Eriksson (1):
      spi/mpc83xx: fix NULL pdata dereference bug

Kirill A. Shutemov (1):
      hwmon: (coretemp) fix oops on cpu unplug

Kishon Vijay Abraham I (2):
      usb: gadget: udc-core: fix asymmetric calls in remove_driver
      usb: musb: omap: fix crash when musb glue (omap) gets initialized

Konrad Rzeszutek Wilk (3):
      xen/xenbus: Add quirk to deal with misconfigured backends.
      xen/smp: Fix crash when booting with ACPI hotplug CPUs.
      xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs

Kusanagi Kouichi (1):
      x86, relocs: Remove an unused variable

Larry Finger (2):
      rtlwifi: Fix oops on unload
      staging: r8712u: Fix regression caused by commit 8c213fa

Laurent Pinchart (2):
      spi: Fix device unregistration when unregistering the bus master
      usb gadget: uvc: uvc_request_data::length field must be signed

Lin Ming (1):
      libata: skip old error history when counting probe trials

Linus Torvalds (4):
      Revert "autofs: work around unhappy compat problem on x86-64"
      pipes: add a "packetized pipe" mode for writing
      autofs: make the autofsv5 packet file descriptor use a packetized pip=
e
      Fix __read_seqcount_begin() to use ACCESS_ONCE for sequence value rea=
d

Lukasz Kucharczyk (1):
      cfg80211: fix interface combinations check.

Mark Brown (2):
      ASoC: dapm: Ensure power gets managed for line widgets
      ASoC: wm8994: Improve sequencing of AIF channel enables

Martin Nyhus (1):
      dell-laptop: Terminate quirks list properly

Matthew Garrett (3):
      efi: Add new variable attributes
      efi: Validate UEFI boot variables
      efivars: Improve variable validation

Meenakshi Venkataraman (1):
      iwlwifi: use correct released ucode version

Neal Cardwell (2):
      tcp: fix tcp_rcv_rtt_update() use of an unscaled RTT sample
      tcp: fix TCP_MAXSEG for established IPv6 passive sockets

NeilBrown (1):
      md: fix possible corruption of array metadata on shutdown.

Nicolas Ferre (1):
      dmaengine: at_hdmac: remove clear-on-read in atc_dostart()

Oleg Nesterov (2):
      exit_signal: simplify the "we have changed execution domain" logic
      exit_signal: fix the "parent has changed security domain" logic

Oliver Neukum (3):
      uwb: fix use of del_timer_sync() in interrupt
      uwb: fix error handling
      USB: cdc-wdm: fix race leading leading to memory corruption

Paolo Pisati (1):
      smsc95xx: mark link down on startup and let PHY interrupt deal with c=
arrier changes

Paul Walmsley (1):
      ARM: OMAP1: DMTIMER: fix broken timer clock source selection

Paulo Zanoni (1):
      drm/i915: enable dip before writing data on gen4

Peter Zijlstra (1):
      sched: Fix nohz load accounting -- again!

Phil Sutter (1):
      wimax: i2400m - prevent a possible kernel bug due to missing fw_name =
string

Roland Stigge (1):
      i2c: pnx: Disable clk in suspend

RongQing.Li (1):
      ipv6: fix array index in ip6_mc_add_src()

Sasha Levin (1):
      phonet: Check input from user before allocating

Seth Forshee (1):
      b43: only reload config after successful initialization

Shaohua Li (1):
      jbd2: use GFP_NOFS for blkdev_issue_flush

Shubhrajyoti D (1):
      usb: musb: omap: fix the error check for pm_runtime_get_sync

Stanislav Yakovlev (1):
      ipw2200: Fix race condition in the command completion acknowledge

Stanislaw Gruszka (1):
      iwlwifi: do not nulify ctx->vif on reset

Stefan Metzmacher (1):
      fs/cifs: fix parsing of dfs referrals

Stefano Stabellini (1):
      xen/gntdev: do not set VM_PFNMAP

Stephane Fillod (1):
      net: usb: smsc75xx: fix mtu

Steven Rostedt (1):
      tracing: Fix stacktrace of latency tracers (irqsoff and friends)

Takashi Iwai (2):
      ALSA: hda/conexant - Don't set HP pin-control bit unconditionally
      ALSA: hda/conexant - Set up the missing docking-station pins

Tejun Heo (1):
      percpu, x86: don't use PMD_SIZE as embedded atom_size on 32bit

Thomas Graf (1):
      sctp: Allow struct sctp_event_subscribe to grow without breaking bina=
ries

Thomas Jackson (1):
      libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

Thomas Jarosch (1):
      PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPU=
s

Tim Bird (1):
      ARM: 7410/1: Add extra clobber registers for assembly in kernel_execv=
e

Tomoki Sekiyama (2):
      USB: yurex: Remove allocation of coherent buffer for setup-packet buf=
fer
      USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb

Tomoya MORINAGA (1):
      pch_uart: Fix dma channel unallocated issue

Tony Zelenoff (1):
      atl1: fix kernel panic in case of DMA errors

Trond Myklebust (2):
      NFSv4: Ensure that the LOCK code sets exception->inode
      NFSv4: Ensure that we check lock exclusive/shared type against open m=
odes

Veaceslav Falico (1):
      bonding: properly unset current_arp_slave on slave link up

Wey-Yi Guy (1):
      iwlwifi: use 6000G2B for 6030 device series

Will Deacon (6):
      net: smsc911x: fix skb handling in receive path
      ARM: 7396/1: errata: only handle ARM erratum #326103 on affected core=
s
      ARM: 7397/1: l2x0: only apply workaround for erratum #753970 on PL310
      ARM: 7398/1: l2x0: only write to debug registers on PL310
      ARM: 7403/1: tls: remove covert channel via TPIDRURW
      ARM: 7406/1: hotplug: copy the affinity mask when forcefully migratin=
g IRQs

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()

Yuri Matylitski (1):
      USB: serial: cp210x: Fixed usb_control_msg timeout values

Zeev Tarantov (1):
      Perf: fix build breakage

he, bo (1):
      sched: Fix OOPS when build_sched_domains() percpu allocation fails

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-2enZ+lUkzFnR06FVIbXo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT62kWee/yOyVhhEJAQoHSxAAreYApCwz6iDbO9CQpe1eN5OPXmba5pLA
n3DR3jWsfYAZRX239lmDwQ02iLBpVxOkNb8Gm2FN13nHOGRTFfdQ8O/qZ6A8Dqlb
IzPjkTy1jfDdy9JauesQ1kOJg/IljjUMpAHzVTKFsE8R4o90gOvuqAvFiZk704ae
mIPYmK3Mh1nZw4Y23IPwBc7CM0Y8TqMVJ5jlxtetduzw8N+aa3PTyvyr1evCIhdy
ajWkbsxnEp9xjOd4EdTugEX+W24JKKs+j313UG00h6vxyiyQBgNOuUDXtszpLc9F
JaM8BLMt2E37VqdYeX+gx4eVsv1EU7NemmyQr15OV8N5FGgFlnXzzTY8Af7+g9iK
TEeTG5+rjWFi6JtWI9pu/U3UDwjYrB3Uasz0JTsIq5Z+l/ztIgw1N4YOZYEHbFYD
uknlEI40WEVwPjEiyey47NcJQ0QzxJ/V3UPSFwDEgnTo0EGukqXs3f9/l5BQo1/t
Qt2jLi380jVelENiO/WOvp2aJ7I8x6uhXt4Nxq4UPRDlwep0RRnfqfEeJ+gE5Xv3
LZf+fZkWYDLK3KObsUwi5HskuEbtWm8jpNYnhNSEnGOwD6D6COphqWzIaZ/Vsmvo
XnGjdcAxseo1bx9uU+JchTvWl3o+6zOymkWea2rAj7B90a5V0ge9AZTyH3DHmirV
fvdvXrrlrfI=
=apdi
-----END PGP SIGNATURE-----

--=-2enZ+lUkzFnR06FVIbXo--
