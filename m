Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2JBSRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:17:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45913 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab2JBSRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:17:15 -0400
X-Sasl-enc: CoOB23KhX7nD/6+lMnwbUURloUUBW+1P5M09CFqbsDVh 1349201834
Date: Tue, 2 Oct 2012 11:17:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.12
Message-ID: <20121002181713.GA5735@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.12 kernel.

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

 Documentation/sound/alsa/HD-Audio-Models.txt          |    1=20
 Makefile                                              |    2=20
 arch/alpha/include/asm/atomic.h                       |    4=20
 arch/arm/Makefile                                     |    4=20
 arch/arm/boot/compressed/head.S                       |    1=20
 arch/arm/include/asm/assembler.h                      |    8 +
 arch/arm/include/asm/mutex.h                          |  119 -------------=
--
 arch/arm/include/asm/uaccess.h                        |   40 +++--
 arch/arm/kernel/hw_breakpoint.c                       |   55 +++++--
 arch/arm/kernel/traps.c                               |   11 -
 arch/arm/lib/getuser.S                                |   23 +-
 arch/arm/lib/putuser.S                                |    6=20
 arch/arm/mm/mm.h                                      |    3=20
 arch/arm/mm/mmu.c                                     |    4=20
 arch/mips/mm/gup.c                                    |    2=20
 arch/powerpc/platforms/85xx/p1022_ds.c                |  102 +++++++++++--
 arch/s390/oprofile/init.c                             |   10 -
 arch/x86/include/asm/xen/page.h                       |    3=20
 arch/x86/pci/fixup.c                                  |   17 ++
 arch/x86/xen/p2m.c                                    |   27 +--
 arch/x86/xen/setup.c                                  |    4=20
 drivers/acpi/power.c                                  |   36 +++-
 drivers/ata/ahci.c                                    |    2=20
 drivers/ata/libata-core.c                             |    1=20
 drivers/base/power/runtime.c                          |    5=20
 drivers/block/cciss_scsi.c                            |    1=20
 drivers/block/nbd.c                                   |    9 +
 drivers/block/xen-blkback/blkback.c                   |    2=20
 drivers/bluetooth/btusb.c                             |   10 -
 drivers/cpufreq/powernow-k8.c                         |   63 ++++----
 drivers/dma/at_hdmac.c                                |   13 +
 drivers/dma/pl330.c                                   |   21 +-
 drivers/gpio/gpio-lpc32xx.c                           |    5=20
 drivers/gpu/drm/drm_crtc.c                            |    2=20
 drivers/gpu/drm/i915/intel_crt.c                      |   36 ++++
 drivers/gpu/drm/i915/intel_display.c                  |   12 -
 drivers/gpu/drm/i915/intel_drv.h                      |    2=20
 drivers/gpu/drm/i915/intel_hdmi.c                     |    2=20
 drivers/gpu/drm/i915/intel_modes.c                    |   31 ++-
 drivers/gpu/drm/i915/intel_ringbuffer.c               |    7=20
 drivers/gpu/drm/nouveau/nouveau_display.c             |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c                |   61 ++++---
 drivers/gpu/drm/radeon/atombios_encoders.c            |  140 +++++++++----=
-----
 drivers/gpu/drm/radeon/radeon.h                       |   15 -
 drivers/gpu/drm/radeon/radeon_atombios.c              |    2=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c          |   56 -------
 drivers/gpu/drm/radeon/radeon_bios.c                  |  138 +++++++++++++=
++++
 drivers/gpu/drm/radeon/radeon_device.c                |    2=20
 drivers/gpu/drm/udl/udl_connector.c                   |    7=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                   |    5=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                   |   10 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c                 |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c              |   73 +++++++++
 drivers/hid/hid-logitech-dj.c                         |   41 +++++
 drivers/hid/hid-logitech-dj.h                         |    1=20
 drivers/hwmon/ad7314.c                                |    8 +
 drivers/hwmon/ads7871.c                               |    9 +
 drivers/hwmon/fam15h_power.c                          |   15 +
 drivers/hwmon/twl4030-madc-hwmon.c                    |    9 -
 drivers/input/serio/i8042-x86ia64io.h                 |    6=20
 drivers/iommu/intr_remapping.c                        |   18 +-
 drivers/isdn/isdnloop/isdnloop.c                      |   12 -
 drivers/md/md.c                                       |   15 +
 drivers/md/raid10.c                                   |   16 +-
 drivers/md/raid10.h                                   |    2=20
 drivers/md/raid5.c                                    |    4=20
 drivers/media/rc/rc-main.c                            |    5=20
 drivers/media/video/cx25821/cx25821-core.c            |    3=20
 drivers/media/video/cx25821/cx25821.h                 |    2=20
 drivers/misc/sgi-xp/xpc_uv.c                          |   84 ++++++++--
 drivers/mmc/card/block.c                              |   26 +++
 drivers/mmc/host/mxs-mmc.c                            |    4=20
 drivers/mmc/host/sdhci-esdhc.h                        |    6=20
 drivers/mtd/ubi/vtbl.c                                |    4=20
 drivers/net/can/janz-ican3.c                          |    4=20
 drivers/net/can/mcp251x.c                             |   11 +
 drivers/net/can/ti_hecc.c                             |    2=20
 drivers/net/ethernet/freescale/gianfar.c              |    2=20
 drivers/net/ethernet/ibm/ibmveth.c                    |   26 +--
 drivers/net/ethernet/realtek/r8169.c                  |    1=20
 drivers/net/ethernet/sfc/efx.c                        |    6=20
 drivers/net/ethernet/sfc/efx.h                        |   14 +
 drivers/net/ethernet/sfc/ethtool.c                    |   20 +-
 drivers/net/ethernet/sfc/tx.c                         |   19 ++
 drivers/net/macvtap.c                                 |   35 ++--
 drivers/net/netconsole.c                              |    1=20
 drivers/net/ppp/pptp.c                                |    4=20
 drivers/net/usb/asix.c                                |    4=20
 drivers/net/usb/qmi_wwan.c                            |   95 ++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c  |   26 ++-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    6=20
 drivers/net/wireless/rt2x00/rt2400pci.c               |    9 +
 drivers/net/wireless/rt2x00/rt2400pci.h               |    1=20
 drivers/net/wireless/rt2x00/rt2500pci.c               |    9 +
 drivers/net/wireless/rt2x00/rt2500usb.c               |   11 +
 drivers/net/wireless/rt2x00/rt2500usb.h               |   17 +-
 drivers/net/wireless/rt2x00/rt2800pci.c               |    9 +
 drivers/net/wireless/rt2x00/rt2800usb.c               |   22 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c               |    2=20
 drivers/net/wireless/rt2x00/rt61pci.c                 |    9 +
 drivers/net/wireless/rt2x00/rt61pci.h                 |    1=20
 drivers/net/wireless/rt2x00/rt73usb.c                 |    9 +
 drivers/net/wireless/rt2x00/rt73usb.h                 |    3=20
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h          |    1=20
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c           |   12 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c           |    6=20
 drivers/platform/x86/asus-laptop.c                    |    8 -
 drivers/platform/x86/asus-nb-wmi.c                    |    4=20
 drivers/rtc/rtc-rs5c348.c                             |    7=20
 drivers/rtc/rtc-twl.c                                 |    5=20
 drivers/scsi/bnx2i/bnx2i_hwi.c                        |    3=20
 drivers/scsi/hpsa.c                                   |    3=20
 drivers/scsi/lpfc/Makefile                            |    2=20
 drivers/scsi/mpt2sas/mpt2sas_base.c                   |    7=20
 drivers/scsi/virtio_scsi.c                            |    2=20
 drivers/staging/android/android_alarm.h               |    4=20
 drivers/staging/comedi/drivers/das08.c                |    2=20
 drivers/staging/media/lirc/lirc_sir.c                 |   60 +++++++
 drivers/staging/rtl8712/recv_linux.c                  |    7=20
 drivers/staging/speakup/main.c                        |    2=20
 drivers/staging/vt6656/dpc.c                          |    2=20
 drivers/staging/vt6656/rxtx.c                         |   38 ++--
 drivers/staging/zcache/zcache-main.c                  |    7=20
 drivers/target/target_core_transport.c                |    9 -
 drivers/tty/serial/imx.c                              |   12 +
 drivers/tty/serial/pch_uart.c                         |   59 +++++--
 drivers/usb/class/cdc-wdm.c                           |   12 +
 drivers/usb/core/devices.c                            |    2=20
 drivers/usb/core/hcd.c                                |    6=20
 drivers/usb/core/quirks.c                             |    4=20
 drivers/usb/dwc3/ep0.c                                |    1=20
 drivers/usb/dwc3/gadget.c                             |    7=20
 drivers/usb/host/ehci-q.c                             |   12 +
 drivers/usb/host/ohci-at91.c                          |   13 +
 drivers/usb/host/pci-quirks.c                         |   42 ++++-
 drivers/usb/host/pci-quirks.h                         |    1=20
 drivers/usb/host/xhci-hub.c                           |   42 +++++
 drivers/usb/host/xhci-plat.c                          |    2=20
 drivers/usb/host/xhci.c                               |  123 +++++++++++++=
++
 drivers/usb/host/xhci.h                               |    6=20
 drivers/usb/serial/ftdi_sio.c                         |   22 ++
 drivers/usb/serial/ftdi_sio_ids.h                     |   29 +++
 drivers/usb/serial/option.c                           |    6=20
 drivers/video/console/fbcon.c                         |    9 +
 drivers/watchdog/hpwdt.c                              |    3=20
 drivers/xen/gntdev.c                                  |    5=20
 drivers/xen/grant-table.c                             |    6=20
 fs/cifs/cifs_unicode.c                                |    2=20
 fs/dcache.c                                           |    4=20
 fs/ecryptfs/inode.c                                   |    5=20
 fs/lockd/svc.c                                        |   12 -
 fs/nfs/inode.c                                        |    2=20
 fs/nfs/nfs3proc.c                                     |    2=20
 fs/nfs/nfs4proc.c                                     |    4=20
 fs/nfs/nfs4xdr.c                                      |    3=20
 fs/nfs/super.c                                        |    2=20
 fs/nfsd/nfsctl.c                                      |    8 -
 fs/nfsd/nfsd.h                                        |   11 +
 fs/nfsd/nfssvc.c                                      |   24 +--
 fs/proc/proc_sysctl.c                                 |    5=20
 fs/stat.c                                             |    2=20
 include/asm-generic/mutex-xchg.h                      |   11 +
 include/drm/drm_mode.h                                |    5=20
 include/linux/dcache.h                                |    2=20
 include/linux/init_task.h                             |   12 +
 include/linux/kobject.h                               |    2=20
 include/linux/kthread.h                               |    8 -
 include/linux/ktime.h                                 |    7=20
 include/linux/memory.h                                |    2=20
 include/linux/mmc/card.h                              |    1=20
 include/linux/netdevice.h                             |    4=20
 include/linux/nfs_fs.h                                |    5=20
 include/linux/pci_ids.h                               |    2=20
 include/linux/perf_event.h                            |    2=20
 include/linux/sched.h                                 |    5=20
 include/linux/time.h                                  |   29 +++
 include/net/bluetooth/smp.h                           |    2=20
 include/net/scm.h                                     |    4=20
 include/net/sock.h                                    |    2=20
 include/trace/events/kmem.h                           |    4=20
 include/xen/grant_table.h                             |    3=20
 kernel/async.c                                        |   13 +
 kernel/events/core.c                                  |   62 ++++---
 kernel/kthread.c                                      |   88 ++++++-----
 kernel/sched/core.c                                   |    9 +
 kernel/sched/sched.h                                  |   23 +-
 kernel/time/tick-sched.c                              |    1=20
 kernel/time/timekeeping.c                             |   33 +++-
 kernel/workqueue.c                                    |   34 +---
 lib/digsig.c                                          |    6=20
 mm/bootmem.c                                          |    8 -
 mm/memory_hotplug.c                                   |   16 +-
 mm/page_alloc.c                                       |    2=20
 mm/vmscan.c                                           |    6=20
 net/atm/common.c                                      |    1=20
 net/atm/pvc.c                                         |    1=20
 net/bluetooth/hci_conn.c                              |    4=20
 net/bluetooth/hci_core.c                              |    2=20
 net/bluetooth/hci_sock.c                              |    2=20
 net/bluetooth/l2cap_core.c                            |   11 -
 net/bluetooth/l2cap_sock.c                            |    3=20
 net/bluetooth/mgmt.c                                  |   16 ++
 net/bluetooth/rfcomm/sock.c                           |    2=20
 net/bluetooth/rfcomm/tty.c                            |    2=20
 net/bluetooth/smp.c                                   |   10 -
 net/core/dev.c                                        |   30 +++
 net/core/net_namespace.c                              |    4=20
 net/core/sock.c                                       |    1=20
 net/dccp/ccids/ccid3.c                                |    1=20
 net/ipv4/ipmr.c                                       |   14 +
 net/ipv4/tcp.c                                        |    4=20
 net/ipv4/tcp_cong.c                                   |    3=20
 net/ipv4/tcp_input.c                                  |   15 -
 net/ipv4/tcp_output.c                                 |   21 +-
 net/ipv6/addrconf.c                                   |    4=20
 net/l2tp/l2tp_core.c                                  |    3=20
 net/l2tp/l2tp_core.h                                  |    1=20
 net/llc/af_llc.c                                      |    3=20
 net/mac80211/mlme.c                                   |    4=20
 net/netfilter/ipvs/ip_vs_ctl.c                        |    1=20
 net/netlink/af_netlink.c                              |    6=20
 net/openvswitch/vport-internal_dev.c                  |    8 +
 net/packet/af_packet.c                                |   10 +
 net/rds/recv.c                                        |    3=20
 net/sched/act_gact.c                                  |   14 +
 net/socket.c                                          |    1=20
 net/unix/af_unix.c                                    |    4=20
 net/wireless/reg.c                                    |   12 +
 sound/pci/hda/hda_codec.c                             |    2=20
 sound/pci/hda/patch_realtek.c                         |   22 ++
 sound/pci/hda/patch_sigmatel.c                        |    2=20
 sound/pci/ice1712/prodigy_hifi.c                      |    3=20
 sound/soc/codecs/wm2000.c                             |    2=20
 sound/soc/samsung/dma.c                               |    8 -
 sound/soc/tegra/tegra_alc5632.c                       |    1=20
 235 files changed, 2304 insertions(+), 958 deletions(-)

Aaron Lu (1):
      ACPI / PM: Use KERN_DEBUG when no power resources are found

AceLan Kao (1):
      asus-nb-wmi: add some video toggle keys

Al Viro (1):
      perf_event: Switch to internal refcount, fix race with close()

Alan Cox (3):
      ahci: Add alternate identifier for the 88SE9172
      x86: Fix boot on Twinhead H12Y
      pch_uart: Fix missing break for 16 byte fifo

Alan Stern (2):
      USB: add device quirk for Joss Optical touchboard
      USB: Fix race condition when removing host controllers

Alex Deucher (7):
      drm/radeon/ss: use num_crtc rather than hardcoded 6
      drm/radeon: split ATRM support out from the ATPX handler (v3)
      drm/radeon/atom: rework DIG modesetting on DCE3+
      drm/radeon/atom: powergating fixes for DCE6
      drm/radeon: convert radeon vfct code to use acpi_get_table_with_size
      drm/radeon: don't disable plls that are in use by other crtcs
      drm/radeon: fix dig encoder selection on DCE61

Alexey Khoroshilov (1):
      net/core: Fix potential memory leak in dev_set_alias()

Alexis R. Cortes (1):
      usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware

Amerigo Wang (1):
      netconsole: remove a redundant netconsole_target_put()

Andre Guedes (1):
      Bluetooth: Fix use-after-free bug in SMP

Andreas Herrmann (1):
      hwmon: (fam15h_power) Tweak runavg_range on resume

Andrew Bird (Sphere Systems) (1):
      USB: qmi_wwan: Add ZTE (Vodafone) K3765-Z

Andrzej Kaczmarek (2):
      Bluetooth: mgmt: Fix enabling SSP while powered off
      Bluetooth: mgmt: Fix enabling LE while powered off

Anisse Astier (1):
      Input: i8042 - disable mux on Toshiba C850D

Artem Bityutskiy (1):
      UBI: fix a horrible memory deallocation bug

Atsushi Nemoto (1):
      drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Ben Hutchings (5):
      net: Allow driver to limit number of GSO segments per skb
      sfc: Fix maximum number of TSO segments and minimum TX queue size
      tcp: Apply device TSO segment limit earlier
      ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side =
lock
      sfc: Fix reporting of IPv4 full filters through ethtool

Beno=EEt Locher (1):
      can: mcp251x: avoid repeated frame bug

Bj=F8rn Mork (10):
      USB: option: replace ZTE K5006-Z entry with vendor class rule
      kobject: fix oops with "input0: bad kobj_uevent_env content in show_u=
event()"
      USB: ftdi_sio: do not claim CDC ACM function
      USB: cdc-wdm: fix wdm_find_device* return value
      net: qmi_wwan: Add Vodafone/Huawei K5005 support
      net: qmi_wwan: Add Sierra Wireless device IDs
      net: qmi_wwan: add ZTE MF60
      net: qmi_wwan: add ZTE MF821D
      net: qmi_wwan: add Sierra Wireless devices
      net: qmi_wwan: new devices: UML290 and K5006-Z

Charles Wang (1):
      sched: Add missing call to calc_load_exit_idle()

Christopher Brannon (1):
      Staging: speakup: fix an improperly-declared variable.

Claudiu Manoil (1):
      gianfar: fix default tx vlan offload feature flag

Corentin Chary (1):
      asus-laptop: HRWS/HWRS typo

Dae S. Kim (1):
      Staging: Android alarm: IOCTL command encoding fix

Dan Carpenter (2):
      xhci: Fix a logical vs bitwise AND bug
      vmwgfx: corruption in vmw_event_fence_action_create()

Daniel J Blueman (1):
      libata: Prevent interface errors with Seagate FreeAgent GoFlex

Darren Hart (1):
      pch_uart: Add eg20t_port lock field, avoid recursive spinlocks

Dave Airlie (4):
      vmwgfx: add dumb ioctl support
      fbcon: fix race condition between console lock and cursor timer (v1.1)
      drm/nouveau: fix booting with plymouth + dumb support
      drm/udl: limit modes to the sku pixel limits.

David Brown (1):
      ARM: 7513/1: Make sure dtc is built before running it

David Lamparter (1):
      drm/radeon: implement ACPI VFCT vbios fetch (v3)

Dmitry Kasatkin (1):
      digsig: add hash size comparision on signature verification

Douglas Bagnall (1):
      media: Avoid sysfs oops when an rc_dev's raw device is absent

Dylan Reid (1):
      ASoC: samsung dma - Don't indicate support for pause/resume.

Eddie Wai (1):
      SCSI: bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Eliad Peller (1):
      mac80211: clear bssid on auth/assoc failure

Eric Dumazet (2):
      af_netlink: force credentials passing [CVE-2012-3520]
      staging: r8712u: fix bug in r8712_recv_indicatepkt()

Eric Leblond (1):
      af_packet: don't emit packet on orig fanout group

Ezequiel Garcia (1):
      media: cx25821: Remove bad strcpy to read-only char*

Francesco Ruggeri (2):
      net: ipv4: ipmr_expire_timer causes crash when removing net namespace
      fs/proc: fix potential unregister_sysctl_table hang

Francois Romieu (1):
      r8169: RxConfig hack for the 8168evl.

Gao feng (1):
      pptp: lookup route with the proper net namespace

Gertjan van Wingerde (3):
      rt2x00: Identify ASUS USB-N53 device.
      rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
      rt2x00: Fix rfkill polling prior to interface start.

Greg Kroah-Hartman (2):
      Revert: drm/i915: correctly order the ring init sequence
      Linux 3.4.12

Guenter Roeck (3):
      hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elemen=
ts
      hwmon: (ads7871) Add 'name' sysfs attribute
      hwmon: (ad7314) Add 'name' sysfs attribute

Gustavo Padovan (1):
      Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Hante Meuleman (2):
      brcmfmac: fix big endian bug in i-scan.
      brcmfmac: Fix big endian host configuration data.

Henrik Rydberg (1):
      Bluetooth: Add support for Apple vendor-specific devices

Hiroaki SHIMODA (1):
      net_sched: gact: Fix potential panic in tcf_gact().

Horst Schirmeier (1):
      USB: ftdi_sio: PID for NZR SEM 16+ USB

Ian Abbott (1):
      staging: comedi: das08: Correct AO output for das08jr-16-ao

Ian Chen (1):
      mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corrup=
tion.

Ira W. Snyder (1):
      can: janz-ican3: fix support for older hardware revisions

Jakob Bornecrantz (1):
      drm: Check for invalid cursor flags

James Bottomley (1):
      SCSI: lpfc: fix problems with -Werror

Jani Nikula (2):
      drm/i915: extract connector update from intel_ddc_get_modes() for reu=
se
      drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads

Jarod Wilson (1):
      media: lirc_sir: make device registration work

Jason Wang (4):
      macvtap: zerocopy: fix offset calculation when building skb
      macvtap: zerocopy: fix truesize underestimation
      macvtap: zerocopy: put page when fail to get all requested user pages
      macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb is built succ=
essfully

Jeff Layton (1):
      cifs: fix return value in cifsConvertToUTF16

Jerome Glisse (2):
      drm/radeon: avoid turning off spread spectrum for used pll
      drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740

Jesse Gross (1):
      openvswitch: Reset upper layer protocol info on internal devices.

Jianguo Wu (1):
      mm/ia64: fix a memory block size bug

Joachim Eastwood (1):
      USB: ohci-at91: fix null pointer in ohci_hcd_at91_overcurrent_irq

John Stultz (3):
      time: Improve sanity checking of timekeeping inputs
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict

Jovi Zhang (1):
      MIPS: mm: Add compound tail page _mapcount when mapped

Keng-Yu Lin (1):
      Intel xhci: Only switch the switchable ports

Kevin Hilman (1):
      drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

Konrad Rzeszutek Wilk (1):
      xen/boot: Disable NUMA for PV guests.

Lai Jiangshan (1):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be a=
tomic

Larry Finger (1):
      rtlwifi: rtl8192ce: Log message that B_CUT device may not work

Lauri Hintsala (1):
      mmc: mxs-mmc: fix deadlock in SDIO IRQ case

Li Haifeng (1):
      mm/page_alloc: fix the page address of higher page's buddy calculation

Li Zhong (1):
      Fix a dead loop in async_synchronize_full()

Lin Ming (1):
      ACPI / PM: Fix resource_lock dead lock in acpi_power_on_device

Linus Torvalds (1):
      vfs: make O_PATH file descriptors usable for 'fstat()'

Luis R. Rodriguez (1):
      cfg80211: fix possible circular lock on reg_regdb_search()

Malcolm Priestley (1):
      staging: vt6656: [BUG] - Failed connection, incorrect endian.

Manoj Iyer (2):
      xhci: Recognize USB 3.0 devices as superspeed at powerup
      Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0

Marc Kleine-Budde (1):
      can: ti_hecc: fix oops during rmmod

Mark Brown (1):
      ASoC: wm2000: Correct register size

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

Matthew Leach (1):
      ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores

Mel Gorman (1):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Miklos Szeredi (1):
      vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED =
in d_kill()

Moiz Sonasath (1):
      usb: host: xhci: fix compilation error for non-PCI based stacks

NeilBrown (4):
      md: Don't truncate size at 4TB for RAID0 and Linear
      md: make sure metadata is updated when spares are activated or remove=
d.
      md/raid5: fix calculate of 'degraded' when a replacement becomes acti=
ve.
      md/raid10: fix problem with on-stack allocation of r10bio structure.

Nestor Lopez Casado (1):
      HID: Fix logitech-dj: missing Unifying device issue

Nicholas Bellinger (1):
      target: Fix ->data_length re-assignment bug with SCSI overflow

Nicolas Ferre (3):
      dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
      dmaengine: at_hdmac: check that each sg data length is non-null
      USB: ohci-at91: fix PIO handling in relation with number of ports

Pablo Neira Ayuso (1):
      netlink: fix possible spoofing from non-root processes

Paul Clements (1):
      nbd: clear waiting_queue on shutdown

Pavankumar Kondeti (1):
      EHCI: Update qTD next pointer in QH overlay region during unlink

Peter Zijlstra (1):
      sched: Fix race in task_group()

Pratyush Anand (1):
      usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced

Rafael J. Wysocki (2):
      PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set
      PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()

Robert Richter (1):
      oprofile, s390: Fix uninitialized memory access when writing to oprof=
ilefs

Robin Holt (1):
      drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out=
 of IRQ resources

Roland Stigge (1):
      gpio-lpc32xx: Fix value handling of gpio_direction_output()

Ruchika Kharwar (1):
      usb: host: xhci-plat: use ioremap_nocache

Russell King (2):
      ARM: 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_D=
OMAINS
      ARM: Fix ioremap() of address zero

Rustad, Mark D (1):
      net: Statically initialize init_net.dev_base_head

Sachin Kamat (2):
      DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_re=
q()
      DMA: PL330: Check the pointer returned by kzalloc

Santiago Leon (1):
      ibmveth: Fix alignment of rx queue bug

Satoru Moriya (1):
      mm: avoid swapping out with swappiness=3D=3D0

Sergei Poselenov (1):
      rt2800usb: Added rx packet length validity check

Seth Forshee (1):
      irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU

Seth Jennings (1):
      staging: zcache: fix cleancache race condition with shrinker

Shawn Guo (1):
      mmc: sdhci-esdhc: break out early if clock is 0

Stanislav Kinsbursky (3):
      NFSd: introduce nfsd_destroy() helper
      NFSd: set nfsd_serv to NULL after service destruction
      LockD: pass service to per-net up and down functions

Stefano Stabellini (1):
      xen/m2p: do not reuse kmap_op->dev_bus_addr

Stephen M. Cameron (2):
      cciss: fix handling of protocol error
      SCSI: hpsa: fix handling of protocol error

Stephen Warren (1):
      sound: tegra_alc5632: remove HP detect GPIO inversion

S=F8ren Holm (1):
      asix: Support DLink DUB-E100 H/W Ver C1

Takashi Iwai (3):
      ALSA: hda - Fix missing Master volume for STAC9200/925x
      ALSA: hda - Fix Oops at codec reset/reconfig
      ALSA: hda - Workaround for silent output on VAIO Z with ALC889

Tejun Heo (4):
      workqueue: reimplement work_on_cpu() using system_wq
      cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to =
another CPU
      kthread_worker: reorganize to prepare for flush_kthread_work() reimpl=
ementation
      kthread_worker: reimplement flush_kthread_work() to allow freeing the=
 work item being executed

Timur Tabi (2):
      powerpc/85xx: p1022ds: disable the NAND flash node if video is enabled
      powerpc/85xx: p1022ds: fix DIU/LBC switching with NAND enabled

Tomoya MORINAGA (2):
      pch_uart: Fix rx error interrupt setting issue
      pch_uart: Fix parity setting issue

Toshi Kani (1):
      hpwdt: Fix kdump issue in hpwdt

Trond Myklebust (2):
      NFS: Fix the initialisation of the readdir 'cookieverf' array
      NFS: Fix a problem with the legacy binary mount code

Tvrtko Ursulin (1):
      drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to =
cover later silicon stepping

Tyler Hicks (1):
      eCryptfs: Copy up attributes of the lower target inode after rename

Vinicius Costa Gomes (3):
      Bluetooth: Fix not removing power_off delayed work
      Bluetooth: Change signature of smp_conn_security()
      Bluetooth: Fix sending a HCI Authorization Request over LE links

Wang Sen (1):
      SCSI: scsi: virtio-scsi: Fix address translation failure of HighMem p=
ages used by sg list

Wang Xingchao (1):
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

Weiping Pan (1):
      rds: set correct msg_namelen

Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL

Weston Andros Adamson (1):
      NFS: return error from decode_getfh in decode open

Will Deacon (4):
      ARM: 7496/1: hw_breakpoint: don't rely on dfsr to show watchpoint acc=
ess type
      ARM: 7526/1: traps: send SIGILL if get_user fails on undef handling p=
ath
      mutex: Place lock in contended state after fastpath_lock failure
      ARM: 7467/1: mutex: use generic xchg-based implementation for ARMv6+

Wu Fengguang (1):
      isdnloop: fix and simplify isdnloop_init()

Xinyu Chen (1):
      tty: serial: imx: console write routing is unsafe on SMP

Xu, Anhua (1):
      drm/i915: fix wrong order of parameters in port checking functions

Yinghai Lu (1):
      mm: sparse: fix usemap allocation above node descriptor section

Yuchung Cheng (1):
      tcp: fix cwnd reduction for non-sack recovery

Yuval Mintz (1):
      bnx2x: fix 57840_MF pci id

danborkmann@iogearbox.net (1):
      af_packet: remove BUG statement in tpacket_destruct_skb

qiuxishi (1):
      memory hotplug: fix section info double registration bug

sreekanth.reddy@lsi.com (1):
      SCSI: mpt2sas: Fix for issue - Unable to boot from the drive connecte=
d to HBA

xeb@mail.ru (1):
      l2tp: avoid to use synchronize_rcu in tunnel free function

=C9ric Piel (1):
      USB: ftdi-sio: add support for more Physik Instrumente devices


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQay+pAAoJEDjbvchgkmk+j/wP/2PNexE8iuUlDSi9yOCi8jdv
WsFYkJ6jlQtVuVkVdUKj81fvVacSN4vgmjQFFn9zs5I0jtCA49E1ft2bo5wG+FPU
GAfKzd6a0FXLs+j8gxT/NwBBvlEX95pbWqD0XRGcqxtg0LJ8euiF5BRLWLnuG5tm
I6P6ECR7mIYvA7s6LvyKXNpMQKbuhykBhxqL6SFQaLPav97+O/BJSRSUdIf9nttN
a2TkJkfQnu+Y66/O1c9HCqj4HOovrQ399VSizfu2kImNNDrWiEKtJ5DNm6S6ZeuP
D8foH/aT4Ht4ju/TVGOOC4uhlq4OjoAef7fDP0oYeIU6gZpu65APo+VL9VLSV7Kx
CF4iC2bsfjBlVRspLrRxH/dVEfKsiF1mX1oLEtQJJ6q9fKRM427OJEwApudC1Vl2
OIWmaNSuazt9kixJSfBoR0vOYsELSWS++SH+UVQ7EH12uTv7Tk0NJZZurW+ekx8E
ybNdynm1k1ntr403rWC7jaLz+bpFdeVt+BDEuv1A7ARsMLw9VYmw8Eplt1i7IyH7
+piOg/1XysJoNzkmvf63oHf/t9BvP2jLKjXuYDM4xqmeMVL8ydCNdMcEN56fyi1z
Yrz+OD8rSnaCBFVmlcKUWfI02kumNemGMS1Bw7dopKIcIGmfvSQQJD4F3Ck4yP1m
q3rPIowrUAjUK5aCGFEZ
=H5Dd
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
