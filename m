Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2JBSQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:16:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51716 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab2JBSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:16:27 -0400
X-Sasl-enc: hVWKoWW9seBnc/lZwKcfZRQO9+3fHMM3P0mTFe3/YNk5 1349201786
Date: Tue, 2 Oct 2012 11:16:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.5.5
Message-ID: <20121002181625.GA2256@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.5.5 kernel.

All users of the 3.5 kernel series must upgrade.

The updated 3.5.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.5.y
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
 arch/arm/boot/compressed/head.S                       |    5=20
 arch/arm/include/asm/assembler.h                      |    8=20
 arch/arm/include/asm/mutex.h                          |  119 -------------
 arch/arm/include/asm/uaccess.h                        |   40 ++--
 arch/arm/kernel/hw_breakpoint.c                       |   55 ++++--
 arch/arm/kernel/traps.c                               |   11 -
 arch/arm/lib/getuser.S                                |   23 +-
 arch/arm/lib/putuser.S                                |    6=20
 arch/arm/mach-imx/clk-imx25.c                         |    6=20
 arch/arm/mach-imx/clk-imx35.c                         |    6=20
 arch/arm/mach-imx/mach-armadillo5x0.c                 |    3=20
 arch/arm/mach-omap2/timer.c                           |    7=20
 arch/arm/mm/mm.h                                      |    3=20
 arch/arm/mm/mmu.c                                     |    4=20
 arch/mips/mm/gup.c                                    |    2=20
 arch/powerpc/platforms/85xx/p1022_ds.c                |  102 +++++++++--
 arch/s390/oprofile/init.c                             |   10 -
 arch/x86/include/asm/xen/page.h                       |    3=20
 arch/x86/kernel/cpu/common.c                          |    2=20
 arch/x86/kernel/cpu/perf_event_amd_ibs.c              |   12 +
 arch/x86/xen/enlighten.c                              |    4=20
 arch/x86/xen/p2m.c                                    |   27 +-
 arch/x86/xen/setup.c                                  |    4=20
 drivers/acpi/bus.c                                    |   10 +
 drivers/acpi/power.c                                  |   36 ++-
 drivers/ata/ahci.c                                    |    2=20
 drivers/ata/libata-core.c                             |    1=20
 drivers/base/core.c                                   |    4=20
 drivers/base/power/runtime.c                          |   13 -
 drivers/block/cciss_scsi.c                            |    1=20
 drivers/block/nbd.c                                   |    9=20
 drivers/block/xen-blkback/blkback.c                   |    2=20
 drivers/bluetooth/ath3k.c                             |    4=20
 drivers/bluetooth/btusb.c                             |   12 -
 drivers/cpufreq/powernow-k8.c                         |   63 +++---
 drivers/dma/at_hdmac.c                                |   13 +
 drivers/dma/pl330.c                                   |   21 +-
 drivers/gpio/gpio-lpc32xx.c                           |    5=20
 drivers/gpu/drm/drm_crtc.c                            |    2=20
 drivers/gpu/drm/drm_edid.c                            |    3=20
 drivers/gpu/drm/gma500/oaktrail_device.c              |    2=20
 drivers/gpu/drm/i915/i915_gem.c                       |    3=20
 drivers/gpu/drm/i915/i915_irq.c                       |    3=20
 drivers/gpu/drm/i915/intel_crt.c                      |   36 +++
 drivers/gpu/drm/i915/intel_display.c                  |   24 +-
 drivers/gpu/drm/i915/intel_drv.h                      |    2=20
 drivers/gpu/drm/i915/intel_hdmi.c                     |    2=20
 drivers/gpu/drm/i915/intel_modes.c                    |   31 ++-
 drivers/gpu/drm/i915/intel_pm.c                       |   11 -
 drivers/gpu/drm/i915/intel_sdvo.c                     |   23 +-
 drivers/gpu/drm/nouveau/nouveau_display.c             |    2=20
 drivers/gpu/drm/nouveau/nouveau_state.c               |    6=20
 drivers/gpu/drm/nouveau/nv84_fifo.c                   |    9=20
 drivers/gpu/drm/radeon/atombios_crtc.c                |   61 ++++--
 drivers/gpu/drm/radeon/atombios_encoders.c            |  140 ++++++++-----=
--
 drivers/gpu/drm/radeon/radeon.h                       |   16 -
 drivers/gpu/drm/radeon/radeon_atombios.c              |    2=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c          |   56 ------
 drivers/gpu/drm/radeon/radeon_bios.c                  |  138 +++++++++++++=
+-
 drivers/gpu/drm/radeon/radeon_cs.c                    |   30 ++-
 drivers/gpu/drm/radeon/radeon_device.c                |    2=20
 drivers/gpu/drm/radeon/radeon_fence.c                 |    8=20
 drivers/gpu/drm/radeon/radeon_gart.c                  |   24 ++
 drivers/gpu/drm/radeon/radeon_gem.c                   |   13 -
 drivers/gpu/drm/radeon/radeon_object.c                |    6=20
 drivers/gpu/drm/radeon/radeon_ring.c                  |    1=20
 drivers/gpu/drm/udl/udl_connector.c                   |    7=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                   |    5=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                   |   10 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c                 |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c              |   73 ++++++++
 drivers/hid/hid-logitech-dj.c                         |   49 +++++
 drivers/hid/hid-logitech-dj.h                         |    1=20
 drivers/hwmon/ad7314.c                                |    8=20
 drivers/hwmon/ads7871.c                               |    9=20
 drivers/hwmon/fam15h_power.c                          |   15 +
 drivers/hwmon/ina2xx.c                                |   30 ---
 drivers/hwmon/twl4030-madc-hwmon.c                    |    9=20
 drivers/i2c/busses/i2c-powermac.c                     |  157 +++++++++++++=
+---
 drivers/input/serio/i8042-x86ia64io.h                 |    6=20
 drivers/input/tablet/wacom_sys.c                      |   10 -
 drivers/input/tablet/wacom_wac.c                      |   27 ++
 drivers/input/tablet/wacom_wac.h                      |    9=20
 drivers/iommu/intel_irq_remapping.c                   |   18 +
 drivers/isdn/hardware/mISDN/avmfritz.c                |    3=20
 drivers/isdn/hardware/mISDN/mISDNipac.c               |    3=20
 drivers/isdn/hardware/mISDN/mISDNisar.c               |    3=20
 drivers/isdn/hardware/mISDN/netjet.c                  |    3=20
 drivers/isdn/hardware/mISDN/w6692.c                   |    3=20
 drivers/isdn/isdnloop/isdnloop.c                      |   12 -
 drivers/isdn/mISDN/hwchannel.c                        |    9=20
 drivers/md/md.c                                       |   15 +
 drivers/md/raid10.c                                   |   38 ++--
 drivers/md/raid10.h                                   |    2=20
 drivers/md/raid5.c                                    |    4=20
 drivers/media/rc/rc-main.c                            |    5=20
 drivers/misc/sgi-xp/xpc_uv.c                          |   84 +++++++--
 drivers/mmc/card/block.c                              |   26 ++
 drivers/mmc/host/atmel-mci.c                          |    6=20
 drivers/mmc/host/mxs-mmc.c                            |   14 -
 drivers/mmc/host/sdhci-esdhc.h                        |    6=20
 drivers/net/can/janz-ican3.c                          |    4=20
 drivers/net/can/mcp251x.c                             |   11 +
 drivers/net/can/ti_hecc.c                             |    2=20
 drivers/net/ethernet/cirrus/cs89x0.c                  |   10 -
 drivers/net/ethernet/freescale/gianfar.c              |    2=20
 drivers/net/ethernet/freescale/gianfar_ethtool.c      |    1=20
 drivers/net/ethernet/freescale/gianfar_ptp.c          |    4=20
 drivers/net/ethernet/ibm/ibmveth.c                    |   26 --
 drivers/net/ethernet/sfc/efx.c                        |    6=20
 drivers/net/ethernet/sfc/efx.h                        |   14 +
 drivers/net/ethernet/sfc/ethtool.c                    |   20 +-
 drivers/net/ethernet/sfc/tx.c                         |   19 ++
 drivers/net/netconsole.c                              |    1=20
 drivers/net/ppp/pptp.c                                |    4=20
 drivers/net/usb/asix.c                                |    4=20
 drivers/net/usb/qmi_wwan.c                            |   58 ++++++
 drivers/net/usb/usbnet.c                              |   16 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c  |   26 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    6=20
 drivers/net/wireless/iwlwifi/iwl-debugfs.c            |    3=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h     |    2=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c      |    2=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c         |   31 +--
 drivers/net/wireless/rt2x00/rt2400pci.c               |    9=20
 drivers/net/wireless/rt2x00/rt2400pci.h               |    1=20
 drivers/net/wireless/rt2x00/rt2500pci.c               |    9=20
 drivers/net/wireless/rt2x00/rt2500usb.c               |   11 +
 drivers/net/wireless/rt2x00/rt2500usb.h               |   17 -
 drivers/net/wireless/rt2x00/rt2800pci.c               |    9=20
 drivers/net/wireless/rt2x00/rt2800usb.c               |   22 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c               |    2=20
 drivers/net/wireless/rt2x00/rt61pci.c                 |    9=20
 drivers/net/wireless/rt2x00/rt61pci.h                 |    1=20
 drivers/net/wireless/rt2x00/rt73usb.c                 |    9=20
 drivers/net/wireless/rt2x00/rt73usb.h                 |    3=20
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h          |    1=20
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c           |   12 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c           |    6=20
 drivers/platform/x86/asus-laptop.c                    |    8=20
 drivers/platform/x86/asus-nb-wmi.c                    |    4=20
 drivers/rtc/rtc-rs5c348.c                             |    7=20
 drivers/rtc/rtc-twl.c                                 |    5=20
 drivers/scsi/bnx2i/bnx2i_hwi.c                        |    3=20
 drivers/scsi/hpsa.c                                   |    3=20
 drivers/scsi/lpfc/Makefile                            |    2=20
 drivers/scsi/mpt2sas/mpt2sas_base.c                   |    7=20
 drivers/scsi/virtio_scsi.c                            |    2=20
 drivers/staging/android/android_alarm.h               |    4=20
 drivers/staging/comedi/drivers/amplc_pci224.c         |    7=20
 drivers/staging/comedi/drivers/das08.c                |    4=20
 drivers/staging/media/lirc/lirc_sir.c                 |   60 ++++++
 drivers/staging/rtl8712/recv_linux.c                  |    7=20
 drivers/staging/speakup/main.c                        |    2=20
 drivers/staging/vt6656/dpc.c                          |    2=20
 drivers/staging/vt6656/rxtx.c                         |   38 ++--
 drivers/staging/zcache/zcache-main.c                  |    7=20
 drivers/target/target_core_transport.c                |   58 ++----
 drivers/tty/serial/imx.c                              |   30 +--
 drivers/tty/serial/pch_uart.c                         |   59 ++++--
 drivers/usb/chipidea/udc.c                            |   58 ++++--
 drivers/usb/class/cdc-wdm.c                           |   12 -
 drivers/usb/core/devices.c                            |    2=20
 drivers/usb/core/hcd.c                                |    6=20
 drivers/usb/core/quirks.c                             |    4=20
 drivers/usb/dwc3/core.c                               |    9=20
 drivers/usb/dwc3/ep0.c                                |    1=20
 drivers/usb/dwc3/gadget.c                             |    7=20
 drivers/usb/gadget/at91_udc.c                         |    6=20
 drivers/usb/gadget/dummy_hcd.c                        |   41 ++++
 drivers/usb/host/ehci-omap.c                          |  164 -------------=
-----
 drivers/usb/host/ehci-q.c                             |   12 +
 drivers/usb/host/ohci-at91.c                          |   13 +
 drivers/usb/host/pci-quirks.c                         |   42 +++-
 drivers/usb/host/pci-quirks.h                         |    1=20
 drivers/usb/host/xhci-hub.c                           |   42 ++++
 drivers/usb/host/xhci-plat.c                          |    2=20
 drivers/usb/host/xhci.c                               |  123 +++++++++++++
 drivers/usb/host/xhci.h                               |    6=20
 drivers/usb/serial/ftdi_sio.c                         |   22 ++
 drivers/usb/serial/ftdi_sio_ids.h                     |   29 ++-
 drivers/usb/serial/option.c                           |    6=20
 drivers/video/console/fbcon.c                         |    9=20
 drivers/watchdog/hpwdt.c                              |    3=20
 drivers/xen/gntdev.c                                  |    5=20
 drivers/xen/grant-table.c                             |    6=20
 fs/cifs/cifs_unicode.c                                |    2=20
 fs/dcache.c                                           |    4=20
 fs/ecryptfs/inode.c                                   |    5=20
 fs/nfs/dir.c                                          |    4=20
 fs/nfs/inode.c                                        |    2=20
 fs/nfs/nfs3proc.c                                     |    2=20
 fs/nfs/nfs4proc.c                                     |    4=20
 fs/nfs/nfs4xdr.c                                      |    3=20
 fs/nfs/super.c                                        |    2=20
 fs/nfsd/nfsctl.c                                      |    8=20
 fs/nfsd/nfsd.h                                        |   11 +
 fs/nfsd/nfssvc.c                                      |   24 --
 fs/proc/proc_sysctl.c                                 |    5=20
 fs/stat.c                                             |    2=20
 include/asm-generic/mutex-xchg.h                      |   11 -
 include/drm/drm_mode.h                                |    5=20
 include/linux/dcache.h                                |    2=20
 include/linux/init_task.h                             |   12 +
 include/linux/kobject.h                               |    2=20
 include/linux/kthread.h                               |    8=20
 include/linux/ktime.h                                 |    7=20
 include/linux/mISDNhw.h                               |    2=20
 include/linux/memory.h                                |    2=20
 include/linux/mmc/card.h                              |    1=20
 include/linux/netdevice.h                             |    4=20
 include/linux/nfs_fs.h                                |    5=20
 include/linux/pci_ids.h                               |    2=20
 include/linux/perf_event.h                            |    4=20
 include/linux/sched.h                                 |    5=20
 include/linux/security.h                              |    1=20
 include/linux/time.h                                  |   29 ++-
 include/net/bluetooth/smp.h                           |    2=20
 include/net/codel.h                                   |    8=20
 include/net/scm.h                                     |    4=20
 include/net/sock.h                                    |    2=20
 include/trace/events/kmem.h                           |    4=20
 include/xen/grant_table.h                             |    3=20
 kernel/async.c                                        |   13 -
 kernel/events/core.c                                  |   62 +++---
 kernel/kthread.c                                      |   88 +++++----
 kernel/sched/core.c                                   |    9=20
 kernel/sched/sched.h                                  |   23 +-
 kernel/time/tick-sched.c                              |    1=20
 kernel/time/timekeeping.c                             |   32 +++
 kernel/workqueue.c                                    |   34 +--
 lib/digsig.c                                          |    6=20
 mm/memory_hotplug.c                                   |   16 +
 mm/page_alloc.c                                       |    2=20
 net/atm/common.c                                      |    1=20
 net/atm/pvc.c                                         |    1=20
 net/bluetooth/hci_conn.c                              |    4=20
 net/bluetooth/hci_core.c                              |    2=20
 net/bluetooth/hci_sock.c                              |    2=20
 net/bluetooth/l2cap_core.c                            |   11 -
 net/bluetooth/l2cap_sock.c                            |    3=20
 net/bluetooth/mgmt.c                                  |   16 +
 net/bluetooth/rfcomm/sock.c                           |    2=20
 net/bluetooth/rfcomm/tty.c                            |    2=20
 net/bluetooth/smp.c                                   |   10 -
 net/core/dev.c                                        |   27 ++
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
 net/l2tp/l2tp_ip6.c                                   |    1=20
 net/llc/af_llc.c                                      |    3=20
 net/mac80211/mlme.c                                   |    4=20
 net/netfilter/ipvs/ip_vs_ctl.c                        |    1=20
 net/netlink/af_netlink.c                              |    6=20
 net/openvswitch/vport-internal_dev.c                  |    8=20
 net/packet/af_packet.c                                |   10 -
 net/rds/recv.c                                        |    3=20
 net/sched/act_gact.c                                  |   14 +
 net/socket.c                                          |    1=20
 net/unix/af_unix.c                                    |    4=20
 net/wireless/reg.c                                    |   12 -
 sound/aoa/codecs/onyx.c                               |   75 --------
 sound/aoa/codecs/tas.c                                |   80 --------
 sound/pci/hda/hda_codec.c                             |    2=20
 sound/pci/hda/patch_realtek.c                         |   22 ++
 sound/pci/hda/patch_sigmatel.c                        |    2=20
 sound/pci/ice1712/prodigy_hifi.c                      |    3=20
 sound/soc/codecs/wm2000.c                             |    2=20
 sound/soc/samsung/dma.c                               |    8=20
 sound/soc/tegra/tegra_alc5632.c                       |    1=20
 sound/usb/endpoint.c                                  |    8=20
 sound/usb/pcm.c                                       |    6=20
 283 files changed, 2763 insertions(+), 1499 deletions(-)

Aaron Lu (1):
      ACPI / PM: Use KERN_DEBUG when no power resources are found

AceLan Kao (1):
      asus-nb-wmi: add some video toggle keys

Al Viro (1):
      perf_event: Switch to internal refcount, fix race with close()

Alan Cox (4):
      ahci: Add alternate identifier for the 88SE9172
      gma500: Fix regression on Oaktrail devices
      dj: memory scribble in logi_dj
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

Andreas Schwab (1):
      sound/aoa: Adapt to new i2c probing scheme

Andrzej Kaczmarek (2):
      Bluetooth: mgmt: Fix enabling SSP while powered off
      Bluetooth: mgmt: Fix enabling LE while powered off

Anisse Astier (1):
      Input: i8042 - disable mux on Toshiba C850D

Atsushi Nemoto (1):
      drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Ben Hutchings (5):
      net: Allow driver to limit number of GSO segments per skb
      sfc: Fix maximum number of TSO segments and minimum TX queue size
      tcp: Apply device TSO segment limit earlier
      ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side =
lock
      sfc: Fix reporting of IPv4 full filters through ethtool

Ben Skeggs (1):
      drm/nvc0/copy: check PUNITS to determine which copy engines are disab=
led

Benjamin Herrenschmidt (1):
      i2c/powermac: Improve detection of devices from device-tree

Beno=EEt Locher (1):
      can: mcp251x: avoid repeated frame bug

Bj=F8rn Mork (8):
      USB: option: replace ZTE K5006-Z entry with vendor class rule
      kobject: fix oops with "input0: bad kobj_uevent_env content in show_u=
event()"
      net: usbnet: fix softirq storm on suspend
      USB: ftdi_sio: do not claim CDC ACM function
      USB: cdc-wdm: fix wdm_find_device* return value
      net: qmi_wwan: add ZTE MF821D
      net: qmi_wwan: add Sierra Wireless devices
      net: qmi_wwan: new devices: UML290 and K5006-Z

Charles Wang (1):
      sched: Add missing call to calc_load_exit_idle()

Chris Wilson (1):
      drm/i915: Reduce a pin-leak BUG into a WARN

Christian K=F6nig (2):
      drm/radeon: init lockup timeout on ring init
      drm/radeon: make 64bit fences more robust v3

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

Daniel Mack (1):
      ALSA: snd-usb: fix next_packet_size calls for pause case

Daniel Vetter (3):
      drm/i915: use hsw rps tuning values everywhere on gen6+
      drm/i915: set the right gen3 flip_done mode also at resume
      drm/i915: enable lvds pin pairs before dpll on gen2

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

Dirk Behme (1):
      tty: serial: imx: don't reinit clock in imx_setup_ufcr()

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

Emmanuel Grumbach (1):
      iwlwifi: don't double free the interrupt in failure path

Eric Dumazet (3):
      codel: refine one condition to avoid a nul rec_inv_sqrt
      af_netlink: force credentials passing [CVE-2012-3520]
      staging: r8712u: fix bug in r8712_recv_indicatepkt()

Eric Leblond (1):
      af_packet: don't emit packet on orig fanout group

Fabio Estevam (3):
      ARM: clk-imx25: Fix SSI clock registration
      ARM: clk-imx35: Fix SSI clock registration
      ARM: imx: armadillo5x0: Fix illegal register access

Francesco Ruggeri (2):
      net: ipv4: ipmr_expire_timer causes crash when removing net namespace
      fs/proc: fix potential unregister_sysctl_table hang

Gao feng (1):
      pptp: lookup route with the proper net namespace

Gertjan van Wingerde (3):
      rt2x00: Identify ASUS USB-N53 device.
      rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
      rt2x00: Fix rfkill polling prior to interface start.

Greg Kroah-Hartman (1):
      Linux 3.5.5

Guenter Roeck (4):
      hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elemen=
ts
      hwmon: (ina2xx) Fix word size register read and write operations
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

Ian Abbott (3):
      staging: comedi: amplc_pci224: Fix PCI ref count
      staging: comedi: das08: Correct AO output for das08jr-16-ao
      staging: comedi: das08: Correct AI encoding for das08jr-16-ao

Ian Chen (1):
      mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corrup=
tion.

Igor Grinberg (1):
      ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER

Ira W. Snyder (1):
      can: janz-ican3: fix support for older hardware revisions

Jaccon Bastiaansen (1):
      cs89x0 : packet reception not working

Jakob Bornecrantz (1):
      drm: Check for invalid cursor flags

James Bottomley (1):
      SCSI: lpfc: fix problems with -Werror

Jani Nikula (3):
      drm/i915: extract connector update from intel_ddc_get_modes() for reu=
se
      drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
      drm/i915: only enable sdvo hotplug irq if needed

Jarod Wilson (1):
      media: lirc_sir: make device registration work

Jeff Layton (1):
      cifs: fix return value in cifsConvertToUTF16

Jerome Glisse (3):
      drm/radeon: avoid turning off spread spectrum for used pll
      drm/radeon: fence virtual address and free it once idle v4
      drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740

Jesse Gross (1):
      openvswitch: Reset upper layer protocol info on internal devices.

Jianguo Wu (1):
      mm/ia64: fix a memory block size bug

Joachim Eastwood (1):
      USB: ohci-at91: fix null pointer in ohci_hcd_at91_overcurrent_irq

Johannes Berg (2):
      iwlwifi: protect SRAM debugfs
      iwlwifi: fix flow handler debug code

John Stultz (3):
      time: Improve sanity checking of timekeeping inputs
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict

Jovi Zhang (1):
      MIPS: mm: Add compound tail page _mapcount when mapped

Karsten Keil (1):
      mISDN: Fix wrong usage of flush_work_sync while holding locks

Keng-Yu Lin (1):
      Intel xhci: Only switch the switchable ports

Keshava Munegowda (1):
      OMAP: USB : Fix the EHCI enumeration and core retention issue

Kevin Hilman (1):
      drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

Kishon Vijay Abraham I (1):
      usb: dwc3: core: fix incorrect usage of resource pointer

Konrad Rzeszutek Wilk (2):
      xen/boot: Disable BIOS SMP MP table search.
      xen/boot: Disable NUMA for PV guests.

Lai Jiangshan (1):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be a=
tomic

Larry Finger (1):
      rtlwifi: rtl8192ce: Log message that B_CUT device may not work

Lauri Hintsala (2):
      mmc: mxs-mmc: fix deadlock in SDIO IRQ case
      mmc: mxs-mmc: fix deadlock caused by recursion loop

Li Haifeng (1):
      mm/page_alloc: fix the page address of higher page's buddy calculation

Li Zhong (1):
      Fix a dead loop in async_synchronize_full()

Lin Ming (1):
      ACPI / PM: Fix resource_lock dead lock in acpi_power_on_device

Linus Torvalds (1):
      vfs: make O_PATH file descriptors usable for 'fstat()'

Ludovic Desroches (1):
      mmc: atmel-mci: not busy flag has also to be used for read operations

Luis R. Rodriguez (1):
      cfg80211: fix possible circular lock on reg_regdb_search()

Malcolm Priestley (1):
      staging: vt6656: [BUG] - Failed connection, incorrect endian.

Manoj Iyer (2):
      xhci: Recognize USB 3.0 devices as superspeed at powerup
      Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0

Marc Kleine-Budde (3):
      can: ti_hecc: fix oops during rmmod
      usb: chipidea: udc: fix error path in udc_start()
      usb: chipidea: cleanup dma_pool if udc_start() fails

Mark Brown (1):
      ASoC: wm2000: Correct register size

Mark Salter (1):
      c/r: prctl: fix build error for no-MMU case

Markus Trippelsdorf (1):
      dyndbg: fix for SOH in logging messages

Mathias Krause (13):
      atm: fix info leak in getsockopt(SO_ATMPVC)
      atm: fix info leak via getsockname()
      Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
      Bluetooth: HCI - Fix info leak via getsockname()
      Bluetooth: RFCOMM - Fix info leak in getsockopt(BT_SECURITY)
      Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
      Bluetooth: RFCOMM - Fix info leak via getsockname()
      Bluetooth: L2CAP - Fix info leak via getsockname()
      l2tp: fix info leak via getsockname()
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

Maxim Levitsky (1):
      drm/nv86/fifo: suspend fix

Mel Gorman (1):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Michael Grzeschik (3):
      usb: chipidea: udc: add pullup fuction, needed by the uvc gadget
      usb: chipidea: udc: fix setup of endpoint maxpacket size
      usb: chipidea: udc: don't stall endpoint if request list is empty in =
isr_tr_complete_low

Miklos Szeredi (1):
      vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED =
in d_kill()

Moiz Sonasath (1):
      usb: host: xhci: fix compilation error for non-PCI based stacks

NeilBrown (5):
      md: Don't truncate size at 4TB for RAID0 and Linear
      md/raid10: fix problem with on-stack allocation of r10bio structure.
      md: make sure metadata is updated when spares are activated or remove=
d.
      md/raid5: fix calculate of 'degraded' when a replacement becomes acti=
ve.
      md/raid10: fix "enough" function for detecting if array is failed.

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

Paolo Bonzini (1):
      target: simplify code around transport_get_sense_data

Paul Clements (1):
      nbd: clear waiting_queue on shutdown

Paul Menzel (1):
      drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S

Pavankumar Kondeti (1):
      EHCI: Update qTD next pointer in QH overlay region during unlink

Peng Chen (1):
      Bluetooth: add support for atheros 0489:e057

Peter Zijlstra (1):
      sched: Fix race in task_group()

Ping Cheng (2):
      Input: wacom - add support to Cintiq 22HD
      Input: wacom - rearrange type enum

Pratyush Anand (1):
      usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced

Rafael J. Wysocki (4):
      ACPI / PM: Infer parent power state from child if unknown, v2
      PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set
      PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()
      PM / Runtime: Check device PM QoS setting before "no callbacks" check

Richard Cochran (1):
      gianfar: fix phc index build failure

Robert Richter (2):
      oprofile, s390: Fix uninitialized memory access when writing to oprof=
ilefs
      perf/x86/ibs: Check syscall attribute flags

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

Sachin Kamat (2):
      DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_re=
q()
      DMA: PL330: Check the pointer returned by kzalloc

Santiago Leon (1):
      ibmveth: Fix alignment of rx queue bug

Sebastian Andrzej Siewior (4):
      usb: gadget: dummy_hcd: fixup error probe path
      usb: gadget: dummy_hcd: add support for USB_DT_BOS on rh
      usb: gadget: at91udc: don't overwrite driver data
      usb: gadget: at91udc: Don't check for ep->ep.desc

Sergei Poselenov (1):
      rt2800usb: Added rx packet length validity check

Seth Forshee (1):
      irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU

Seth Jennings (1):
      staging: zcache: fix cleancache race condition with shrinker

Shawn Guo (1):
      mmc: sdhci-esdhc: break out early if clock is 0

Stanislav Kinsbursky (2):
      NFSd: introduce nfsd_destroy() helper
      NFSd: set nfsd_serv to NULL after service destruction

Stefano Stabellini (1):
      xen/m2p: do not reuse kmap_op->dev_bus_addr

Stephen M. Cameron (2):
      cciss: fix handling of protocol error
      SCSI: hpsa: fix handling of protocol error

Stephen Warren (1):
      sound: tegra_alc5632: remove HP detect GPIO inversion

Suresh Siddha (1):
      x86, avx: don't use avx instructions with "noxsave" boot param

S=F8ren Holm (1):
      asix: Support DLink DUB-E100 H/W Ver C1

Takashi Iwai (4):
      ALSA: hda - Fix missing Master volume for STAC9200/925x
      ALSA: usb-audio: Fix bogus error messages for delay accounting
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

Trond Myklebust (3):
      NFS: Fix the initialisation of the readdir 'cookieverf' array
      NFS: Fix a problem with the legacy binary mount code
      NFS: Fix Oopses in nfs_lookup_revalidate and nfs4_lookup_revalidate

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

Will Deacon (5):
      ARM: 7496/1: hw_breakpoint: don't rely on dfsr to show watchpoint acc=
ess type
      ARM: 7501/1: decompressor: reset ttbcr for VMSA ARMv7 cores
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

Yevgeniy Melnichuk (1):
      Bluetooth: Add support for Sony Vaio T-Series

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


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQay94AAoJEDjbvchgkmk+yeEP/3qpTK8jrObz3DGEyJa2fTmd
3Pk+ocpGjthERRaJWofZmwWAnHRr+NExisPrUVOq0RJxCDZKbuOSj1BCgw8GIlly
6ppUicJBxkbgXz5Xme/xEGr5t0hvmMxVTYizVqi8Q41oGyVcI1QuhfmaB+Wo1ls2
6HafogDOwvXsDdlGMGnyybSZ/Pe8iI8K8dc9a2dxmPt0DsFJhskOSXxjzQ2Xiyt7
VWf9iff4oA6fQu8Du224v8zkNQeJjmsbqER41JTYtAafDOgH8ohJx8VrXJRZVDys
K2Seil8kamnkttbusJtKzejcJCIgUk74ifAH3ukjz7fBd3dV62UkKoDyZ7yYyJy1
0o32wHAFqesPpvmEFoB3aCc2PwCjpChcHxJXaKDlWJqe04LZHjcSH/4y9VLKj4C4
tCRLo1qz0B9OJ3Xe8mUKDxT8LWb+GoI1PyIY/Rfb7c8cxU5K+OuS5mwQPAL2SxJb
LZw/Sun8fv7wVjsOVHOyv90f16pljjHxn58T3EecJVvkvziIXpDIovOoURhBewzQ
PtnXxKyjqzXjA6fEPb7CwT0+KTqeCV3JhcpFRUd+GAne1rTHJ/QPQBbRZJ46UAYl
Clvlut6mZz0lXTGv1qwJv+6i5q3wJZMSj/D759YD/0CR0g2i2TKRJ68DMHi6ny17
E82SP2QN4n6ABeT0Uxf5
=zTXW
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
