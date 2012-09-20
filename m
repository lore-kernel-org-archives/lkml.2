Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2ITB3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:29:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648Ab2ITB3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:29:18 -0400
Message-ID: <1348104546.4836.65.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.30
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Thu, 20 Sep 2012 02:29:06 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cTV2GueyPVhYJNswbhFU"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cTV2GueyPVhYJNswbhFU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.30 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |    8 +-
 Documentation/i2c/busses/i2c-i801                  |    2 +
 Makefile                                           |    2 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/Makefile                                  |    4 +-
 arch/arm/boot/dts/imx51-babbage.dts                |    4 +-
 arch/arm/include/asm/pgtable.h                     |   34 ++---
 arch/arm/kernel/hw_breakpoint.c                    |   55 ++++++--
 arch/arm/kernel/traps.c                            |   11 +-
 arch/arm/mach-dove/common.c                        |    2 +-
 arch/arm/mach-imx/hotplug.c                        |   23 +--
 arch/arm/mach-kirkwood/common.c                    |    4 +-
 arch/arm/mach-mv78xx0/common.c                     |    6 +-
 arch/arm/mach-orion5x/common.c                     |    3 +-
 arch/arm/mm/flush.c                                |    2 -
 arch/arm/plat-omap/dmtimer.c                       |    2 +-
 arch/arm/plat-orion/common.c                       |    8 +-
 arch/arm/plat-orion/include/plat/common.h          |    6 +-
 arch/arm/plat-s3c24xx/dma.c                        |    2 +-
 arch/parisc/include/asm/atomic.h                   |    4 +-
 arch/powerpc/kernel/asm-offsets.c                  |    1 +
 arch/powerpc/kernel/dbell.c                        |    2 +
 arch/powerpc/kernel/entry_64.S                     |   23 ++-
 arch/powerpc/kernel/process.c                      |   12 +-
 arch/powerpc/kernel/smp.c                          |   11 +-
 arch/powerpc/kernel/sysfs.c                        |   10 ++
 arch/powerpc/kernel/traps.c                        |    3 +-
 arch/powerpc/sysdev/xics/icp-hv.c                  |   42 ++++--
 arch/x86/xen/setup.c                               |    9 +-
 drivers/ata/ahci.c                                 |    2 +
 drivers/gpu/drm/drm_crtc.c                         |   19 +--
 drivers/gpu/drm/drm_edid.c                         |   25 +++-
 drivers/gpu/drm/i915/i915_irq.c                    |   20 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |   10 +-
 drivers/gpu/drm/i915/intel_display.c               |   41 ++----
 drivers/gpu/drm/i915/intel_lvds.c                  |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   30 ++--
 drivers/gpu/drm/nouveau/nouveau_display.c          |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  146 ++++++++++++++++=
+---
 drivers/gpu/drm/radeon/atombios_encoders.c         |  105 +++++++-------
 drivers/gpu/drm/radeon/radeon_device.c             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   10 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   73 ++++++++++
 drivers/hid/Kconfig                                |    1 +
 drivers/hid/hid-core.c                             |    3 +
 drivers/hid/hid-ids.h                              |    5 +
 drivers/hid/hid-multitouch.c                       |   15 ++
 drivers/hid/usbhid/hid-quirks.c                    |    4 +
 drivers/hwmon/asus_atk0110.c                       |    6 +
 drivers/hwmon/twl4030-madc-hwmon.c                 |    9 +-
 drivers/i2c/busses/Kconfig                         |    7 +
 drivers/i2c/busses/Makefile                        |    5 +-
 drivers/i2c/busses/i2c-designware-core.c           |   11 ++
 drivers/i2c/busses/i2c-i801.c                      |    6 +
 drivers/input/serio/i8042-x86ia64io.h              |   14 ++
 drivers/isdn/isdnloop/isdnloop.c                   |   12 --
 drivers/mmc/card/block.c                           |   27 +++-
 drivers/mmc/host/mxs-mmc.c                         |   12 +-
 drivers/mmc/host/sdhci-esdhc.h                     |    6 +-
 drivers/mtd/ubi/vtbl.c                             |    4 +-
 drivers/net/can/mcp251x.c                          |   11 +-
 drivers/net/ethernet/freescale/gianfar.c           |    2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   26 ++--
 drivers/net/ethernet/intel/e1000e/e1000.h          |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   49 +++----
 drivers/net/ethernet/sfc/efx.c                     |    6 +
 drivers/net/ethernet/sfc/efx.h                     |   14 +-
 drivers/net/ethernet/sfc/ethtool.c                 |   16 ++-
 drivers/net/ethernet/sfc/nic.h                     |    3 +
 drivers/net/ethernet/sfc/tx.c                      |   19 +++
 drivers/net/ppp/pptp.c                             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |   30 ++--
 drivers/net/wireless/rt2x00/rt2400pci.c            |    9 ++
 drivers/net/wireless/rt2x00/rt2400pci.h            |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c            |    9 ++
 drivers/net/wireless/rt2x00/rt2500usb.c            |   11 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |   17 +--
 drivers/net/wireless/rt2x00/rt2800pci.c            |    9 ++
 drivers/net/wireless/rt2x00/rt2800usb.c            |   22 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    9 ++
 drivers/net/wireless/rt2x00/rt61pci.h              |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c              |    9 ++
 drivers/net/wireless/rt2x00/rt73usb.h              |    3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |   13 +-
 drivers/scsi/scsi_error.c                          |   10 ++
 drivers/scsi/scsi_scan.c                           |   10 ++
 drivers/staging/comedi/drivers/das08.c             |    4 +-
 drivers/staging/rtl8712/recv_linux.c               |    7 +-
 drivers/staging/vt6656/dpc.c                       |    2 +-
 drivers/staging/vt6656/rxtx.c                      |   38 ++---
 drivers/staging/zcache/zcache-main.c               |    7 +-
 drivers/tty/serial/imx.c                           |   30 ++--
 drivers/usb/core/quirks.c                          |    4 +
 drivers/usb/host/ehci-q.c                          |   12 +-
 drivers/usb/host/pci-quirks.c                      |   49 ++++++-
 drivers/usb/host/pci-quirks.h                      |    2 +
 drivers/usb/host/xhci-hub.c                        |   42 ++++++
 drivers/usb/host/xhci-pci.c                        |    9 ++
 drivers/usb/host/xhci-ring.c                       |   39 ++++--
 drivers/usb/host/xhci.c                            |  124 ++++++++++++++++=
+
 drivers/usb/host/xhci.h                            |    7 +
 drivers/usb/serial/ftdi_sio.c                      |   22 ++-
 drivers/usb/serial/ftdi_sio_ids.h                  |   29 +++-
 drivers/usb/serial/option.c                        |    4 +
 drivers/video/omap2/omapfb/omapfb-main.c           |    2 +-
 drivers/xen/swiotlb-xen.c                          |    2 +-
 fs/cifs/file.c                                     |    2 +-
 fs/ecryptfs/inode.c                                |    5 +
 fs/ext3/inode.c                                    |   17 ++-
 fs/fuse/dev.c                                      |    1 +
 fs/nfs/inode.c                                     |    2 +-
 fs/nfs/nfs3proc.c                                  |    2 +-
 fs/nfs/nfs4proc.c                                  |    4 +-
 fs/nfs/nfs4xdr.c                                   |    3 +-
 fs/nfs/super.c                                     |    2 +
 fs/stat.c                                          |    5 +-
 fs/udf/file.c                                      |   35 ++++-
 include/drm/drm_mode.h                             |    5 +-
 include/linux/kobject.h                            |    2 +-
 include/linux/ktime.h                              |    7 -
 include/linux/mmc/card.h                           |    1 +
 include/linux/mv643xx_eth.h                        |    2 +
 include/linux/netdevice.h                          |    4 +
 include/linux/nfs_fs.h                             |    5 -
 include/linux/pci_ids.h                            |    2 +-
 include/linux/perf_event.h                         |    2 +-
 include/linux/sunrpc/xprt.h                        |    3 +
 include/linux/time.h                               |   29 +++-
 include/net/scm.h                                  |    4 +-
 include/net/sock.h                                 |    2 +
 kernel/events/core.c                               |   62 +++++----
 kernel/time/timekeeping.c                          |   32 ++++-
 kernel/workqueue.c                                 |    9 +-
 mm/mempolicy.c                                     |    2 +-
 net/atm/common.c                                   |    1 +
 net/atm/pvc.c                                      |    1 +
 net/bluetooth/hci_sock.c                           |    2 +
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |    2 +
 net/bluetooth/rfcomm/tty.c                         |    2 +-
 net/core/dev.c                                     |   27 +++-
 net/core/sock.c                                    |    1 +
 net/dccp/ccids/ccid3.c                             |    1 +
 net/ipv4/ipmr.c                                    |   14 +-
 net/ipv4/tcp.c                                     |    4 +-
 net/ipv4/tcp_cong.c                                |    3 +-
 net/ipv4/tcp_output.c                              |   21 +--
 net/ipv6/addrconf.c                                |    4 +-
 net/l2tp/l2tp_core.c                               |    3 +-
 net/l2tp/l2tp_core.h                               |    1 +
 net/llc/af_llc.c                                   |    3 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    1 +
 net/netlink/af_netlink.c                           |    6 +-
 net/packet/af_packet.c                             |   10 +-
 net/sched/act_gact.c                               |   14 +-
 net/socket.c                                       |    1 +
 net/sunrpc/xprt.c                                  |   34 +++--
 net/sunrpc/xprtrdma/transport.c                    |    1 +
 net/sunrpc/xprtsock.c                              |    3 +
 net/unix/af_unix.c                                 |    4 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/ice1712/prodigy_hifi.c                   |    3 +-
 168 files changed, 1543 insertions(+), 577 deletions(-)

Aaron Tian (1):
      HID: multitouch: support PixArt optical touch screen

Adam Jackson (2):
      drm/i915: Fix assert_pch_hdmi_disabled to mention HDMI (not DP)
      drm/edid/quirks: ViewSonic VA2026w

Al Viro (1):
      perf_event: Switch to internal refcount, fix race with close()

Alan Cox (1):
      ahci: Add alternate identifier for the 88SE9172

Alan Stern (2):
      HID: add NOGET quirk for Eaton Ellipse MAX UPS
      USB: add device quirk for Joss Optical touchboard

Alex Deucher (5):
      drm/radeon: don't disable plls that are in use by other crtcs
      drm/radeon/atom: rework DIG modesetting on DCE3+
      drm/radeon: fix up pll selection on DCE5/6
      drm/radeon: fix ordering in pll picking on dce4+
      drm/radeon: rework pll selection (v3)

Alexey Khoroshilov (1):
      net/core: Fix potential memory leak in dev_set_alias()

Alexis R. Cortes (1):
      usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware

Anton Blanchard (5):
      powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
      powerpc: Keep thread.dscr and thread.dscr_inherit in sync
      powerpc: Fix DSCR inheritance in copy_thread()
      powerpc: Restore correct DSCR in context switch
      powerpc/xics: Harden xics hypervisor backend

Arnaud Patard (1):
      ARM: Orion: Set eth packet size csum offload limit

Arnd Bergmann (1):
      ARM: imx: select CPU_FREQ_TABLE when needed

Artem Bityutskiy (1):
      UBI: fix a horrible memory deallocation bug

Axel Lin (1):
      i2c-designware: Fix build error if CONFIG_I2C_DESIGNWARE_PLATFORM=3Dy=
 && CONFIG_I2C_DESIGNWARE_PCI=3Dy

Ben Hutchings (5):
      net: Allow driver to limit number of GSO segments per skb
      sfc: Fix maximum number of TSO segments and minimum TX queue size
      tcp: Apply device TSO segment limit earlier
      ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side =
lock
      Linux 3.2.30

Beno=C3=AEt Locher (1):
      can: mcp251x: avoid repeated frame bug

Bj=C3=B8rn Mork (4):
      USB: option: add ZTE K5006-Z
      USB: option: replace ZTE K5006-Z entry with vendor class rule
      kobject: fix oops with "input0: bad kobj_uevent_env content in show_u=
event()"
      USB: ftdi_sio: do not claim CDC ACM function

Bruce Allan (1):
      e1000e: DoS while TSO enabled caused by link partner with small MSS

Chris Wilson (2):
      drm/i915: Wait for all pending operations to the fb before disabling =
the pipe
      drm/i915: SDVO hotplug have different interrupt status bits for i915/=
i965/g4x

Claudiu Manoil (1):
      gianfar: fix default tx vlan offload feature flag

Dan Carpenter (1):
      xhci: Fix a logical vs bitwise AND bug

Dave Airlie (3):
      drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot
      vmwgfx: add dumb ioctl support
      drm/nouveau: fix booting with plymouth + dumb support

Dave Jones (1):
      Remove user-triggerable BUG from mpol_to_str

David Brown (1):
      ARM: 7513/1: Make sure dtc is built before running it

Dirk Behme (1):
      tty: serial: imx: don't reinit clock in imx_setup_ufcr()

Dmitry Torokhov (1):
      Input: i8042 - add Gigabyte T1005 series netbooks to noloop table

Eric Dumazet (2):
      af_netlink: force credentials passing [CVE-2012-3520]
      staging: r8712u: fix bug in r8712_recv_indicatepkt()

Eric Leblond (1):
      af_packet: don't emit packet on orig fanout group

Francesco Ruggeri (1):
      net: ipv4: ipmr_expire_timer causes crash when removing net namespace

Gao feng (1):
      pptp: lookup route with the proper net namespace

Gertjan van Wingerde (3):
      rt2x00: Identify ASUS USB-N53 device.
      rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
      rt2x00: Fix rfkill polling prior to interface start.

Grazvydas Ignotas (1):
      OMAPFB: fix framebuffer console colors

Guenter Roeck (1):
      hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elemen=
ts

Heiko Stuebner (1):
      ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters

Hiroaki SHIMODA (1):
      net_sched: gact: Fix potential panic in tcf_gact().

Horst Schirmeier (1):
      USB: ftdi_sio: PID for NZR SEM 16+ USB

Ian Abbott (2):
      staging: comedi: das08: Correct AI encoding for das08jr-16-ao
      staging: comedi: das08: Correct AO output for das08jr-16-ao

Ian Chen (1):
      mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corrup=
tion.

Jakob Bornecrantz (1):
      drm: Check for invalid cursor flags

James Bottomley (1):
      Fix 'Device not ready' issue on mpt2sas

James Ralston (1):
      i2c-i801: Add Device IDs for Intel Lynx Point-LP PCH

Jan Kara (2):
      ext3: Fix fdatasync() for files with only i_size changes
      udf: Fix data corruption for files in ICB

Jani Nikula (1):
      drm/i915: only enable sdvo hotplug irq if needed

Jerome Glisse (1):
      drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740

Jesse Barnes (1):
      drm: remove some potentially dangerous DRM_ERRORs

Johannes Berg (2):
      iwlwifi: fix flow handler debug code
      iwlwifi: protect SRAM debugfs

John Stultz (3):
      time: Improve sanity checking of timekeeping inputs
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict

Jon Hunter (1):
      ARM: OMAP2+: Fix dmtimer set source clock failure

Kashyap Desai (1):
      megaraid_sas: Move poll_aen_lock initializer

Keng-Yu Lin (1):
      Intel xhci: Only switch the switchable ports

Konrad Rzeszutek Wilk (1):
      xen/setup: Fix one-off error when adding for-balloon PFNs to the P2M.

Lai Jiangshan (1):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be a=
tomic

Lauri Hintsala (2):
      mmc: mxs-mmc: fix deadlock in SDIO IRQ case
      mmc: mxs-mmc: fix deadlock caused by recursion loop

Linus Torvalds (2):
      VFS: make vfs_fstat() use f[get|put]_light()
      vfs: make O_PATH file descriptors usable for 'fstat()'

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Add quirk for Asus M5A78L

Malcolm Priestley (1):
      staging: vt6656: [BUG] - Failed connection, incorrect endian.

Manoj Iyer (1):
      xhci: Recognize USB 3.0 devices as superspeed at powerup

Marc Gariepy (1):
      fixing dmi match for hp t5745 and hp st5747 thin client

Mathias Krause (12):
      atm: fix info leak in getsockopt(SO_ATMPVC)
      atm: fix info leak via getsockname()
      Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
      Bluetooth: HCI - Fix info leak via getsockname()
      Bluetooth: RFCOMM - Fix info leak in getsockopt(BT_SECURITY)
      Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
      Bluetooth: RFCOMM - Fix info leak via getsockname()
      Bluetooth: L2CAP - Fix info leak via getsockname()
      llc: fix info leak via getsockname()
      dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
      ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
      net: fix info leak in compat dev_ifconf()

Matteo Frigo (1):
      ALSA: ice1724: Use linear scale for AK4396 volume control.

Matthew Garrett (1):
      xhci: Make handover code more robust

Mel Gorman (1):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Miklos Szeredi (1):
      fuse: fix retrieve length

Moiz Sonasath (1):
      usb: host: xhci: fix compilation error for non-PCI based stacks

Pablo Neira Ayuso (1):
      netlink: fix possible spoofing from non-root processes

Paul Mackerras (1):
      powerpc: Make sure IPI handlers see data written by IPI senders

Paul Menzel (1):
      drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S

Pavankumar Kondeti (1):
      EHCI: Update qTD next pointer in QH overlay region during unlink

Pavel Shilovsky (1):
      CIFS: Fix error handling in cifs_push_mandatory_locks

Ronny Hegewald (1):
      xen: Use correct masking in xen_swiotlb_alloc_coherent.

Santiago Leon (1):
      ibmveth: Fix alignment of rx queue bug

Sarah Sharp (2):
      xhci: Fix bug after deq ptr set to link TRB.
      xhci: Switch PPT ports to EHCI on shutdown.

Sergei Poselenov (1):
      rt2800usb: Added rx packet length validity check

Seth Heasley (1):
      i2c-i801: Add device IDs for Intel Lynx Point

Seth Jennings (1):
      staging: zcache: fix cleancache race condition with shrinker

Shawn Guo (3):
      ARM: imx6: spin the cpu until hardware takes it down
      ARM: dts: imx51-babbage: fix esdhc cd/wp properties
      mmc: sdhci-esdhc: break out early if clock is 0

Takashi Iwai (1):
      ALSA: hda - Fix Oops at codec reset/reconfig

Trond Myklebust (3):
      NFS: Fix the initialisation of the readdir 'cookieverf' array
      NFS: Fix a problem with the legacy binary mount code
      SUNRPC: Fix a UDP transport regression

Tyler Hicks (1):
      eCryptfs: Copy up attributes of the lower target inode after rename

Weston Andros Adamson (1):
      NFS: return error from decode_getfh in decode open

Will Deacon (3):
      ARM: 7487/1: mm: avoid setting nG bit for user mappings that aren't p=
resent
      ARM: 7496/1: hw_breakpoint: don't rely on dfsr to show watchpoint acc=
ess type
      ARM: 7526/1: traps: send SIGILL if get_user fails on undef handling p=
ath

Wu Fengguang (1):
      isdnloop: fix and simplify isdnloop_init()

Xinyu Chen (1):
      tty: serial: imx: console write routing is unsafe on SMP

Xu, Anhua (1):
      drm/i915: fix wrong order of parameters in port checking functions

Yuval Mintz (1):
      bnx2x: fix 57840_MF pci id

danborkmann@iogearbox.net (1):
      af_packet: remove BUG statement in tpacket_destruct_skb

sreekanth.reddy@lsi.com (1):
      mpt2sas: Fix for Driver oops, when loading driver with max_queue_dept=
h command line option to a very small value

xeb@mail.ru (1):
      l2tp: avoid to use synchronize_rcu in tunnel free function

=C3=89ric Piel (1):
      USB: ftdi-sio: add support for more Physik Instrumente devices


--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-cTV2GueyPVhYJNswbhFU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFpxYue/yOyVhhEJAQpZ4xAA0VyeQ9uptpye3hKEKD3WERH8D+D0xcI2
7FZN9vtT3GljebQr/0HXURFCDvDhlulO01klNNF7rQAwJtjqiL+AXVrC2a4c6vXr
dVh3X1IjwGUBdxO/DHmR04FPEiz9pHsT8TZTNGbljuDH5BnW+bFRVVeMCR2jd97m
u5ot1pvV94arJXwl6tD0YyxpuAHxrrjXKLQIP1EMrfbwmgZyAJVkQEW9pCaEPKuW
t8WYAwRJ4CzG8xMwrahAIDZAkbzdlVFuDVADKK1eugRNGIcS/Mw50iFZGmadJHD+
t4w3g7CstUdUrrmJ1PWeebAcrebUAdydnmUePxDxzYYHacywDIRS4MyuWbGRW11s
djxSElTD1SfC7DcHOZj15r/lIFPN6aWTnkI/ZJ3G7YQuN8snp4zA5xuiLCBRUFgE
OJaZZLaFRrhO0xho9W5pBLeWM5pL25qwOR6j/mN3rJuipHAqHOrU9z5Z4i6KVbhT
zUjo/eZFTRpQYQGfkZTQLEOPJ7agRB5exwx//0JhRul6Sgq1hzWC3WJz1tWUAPM8
bDA0HCZHakhQHL+5d0HH1dtC8LxZlc3QCdOg0knVepX3JJyJ88pQSaqQrfC+gq5S
nOgnGtW2YENBOCtDE8ApVcdKgQHH65Yk1iMollH5vYn28SeHOWNXeZtn57PqKwVG
2P2bGErKx54=
=OMKH
-----END PGP SIGNATURE-----

--=-cTV2GueyPVhYJNswbhFU--
