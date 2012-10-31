Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab2JaRiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:38:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48755 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2JaRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:38:15 -0400
Date: Wed, 31 Oct 2012 10:38:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.5
Message-ID: <20121031173811.GA12970@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.5 kernel.

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

 Documentation/devicetree/bindings/arm/atmel-at91.txt |    2=20
 Makefile                                             |    2=20
 arch/arm/kernel/smp.c                                |   14 +
 arch/arm/mach-at91/at91rm9200_devices.c              |    2=20
 arch/arm/mach-at91/at91sam9260_devices.c             |    2=20
 arch/arm/mach-at91/at91sam9261_devices.c             |    2=20
 arch/arm/mach-at91/at91sam9263_devices.c             |    2=20
 arch/arm/mach-at91/at91sam9rl_devices.c              |    2=20
 arch/arm/mach-at91/board-neocore926.c                |    2=20
 arch/arm/mach-at91/board-sam9261ek.c                 |    2=20
 arch/arm/mach-at91/board-sam9263ek.c                 |    2=20
 arch/arm/mach-at91/generic.h                         |    3=20
 arch/arm/mach-at91/irq.c                             |    9=20
 arch/arm/mach-at91/setup.c                           |    4=20
 arch/arm/mach-exynos/common.c                        |    5=20
 arch/arm/mach-s3c24xx/s3c2416.c                      |    2=20
 arch/arm/mach-s3c24xx/s3c2443.c                      |    4=20
 arch/arm/mach-s5p64x0/common.c                       |    3=20
 arch/arm/mach-s5pc100/common.c                       |    3=20
 arch/arm/mach-s5pv210/common.c                       |    3=20
 arch/arm/plat-samsung/include/plat/spi-core.h        |   30 +++
 arch/x86/include/asm/efi.h                           |    1=20
 arch/x86/kernel/e820.c                               |    3=20
 arch/x86/kernel/setup.c                              |   27 ++
 arch/x86/mm/init.c                                   |   58 +++---
 arch/x86/mm/init_64.c                                |    7=20
 arch/x86/platform/efi/efi.c                          |   43 ++--
 drivers/bcma/main.c                                  |    5=20
 drivers/cpufreq/powernow-k8.c                        |    9=20
 drivers/dma/imx-dma.c                                |    4=20
 drivers/dma/sirf-dma.c                               |    4=20
 drivers/extcon/extcon_class.c                        |    7=20
 drivers/gpu/drm/radeon/evergreen_cs.c                |    1=20
 drivers/hv/channel.c                                 |   24 +-
 drivers/net/ethernet/tile/tilegx.c                   |   35 +--
 drivers/net/usb/cdc_ether.c                          |   41 ++--
 drivers/net/usb/qmi_wwan.c                           |   14 +
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  164 ++++++++------=
---
 drivers/net/wireless/b43/main.c                      |    4=20
 drivers/net/wireless/ipw2x00/ipw2200.c               |    2=20
 drivers/net/wireless/iwlwifi/dvm/devices.c           |   39 ++--
 drivers/rtc/rtc-imxdi.c                              |    2=20
 drivers/staging/android/binder.c                     |   30 ++-
 drivers/staging/comedi/drivers/amplc_dio200.c        |    2=20
 drivers/staging/comedi/drivers/amplc_pc236.c         |    6=20
 drivers/staging/comedi/drivers/amplc_pc263.c         |    3=20
 drivers/staging/comedi/drivers/das08.c               |    2=20
 drivers/staging/comedi/drivers/ni_daq_700.c          |    2=20
 drivers/staging/comedi/drivers/ni_labpc.c            |    2=20
 drivers/staging/zram/zram_drv.c                      |   12 +
 drivers/usb/core/hub.c                               |    7=20
 drivers/usb/host/pci-quirks.c                        |    9=20
 drivers/usb/host/xhci-ring.c                         |   11 +
 drivers/usb/host/xhci.c                              |    4=20
 drivers/usb/serial/ch341.c                           |   23 +-
 drivers/usb/serial/digi_acceleport.c                 |  117 ++++++------
 drivers/usb/serial/ipw.c                             |    7=20
 drivers/usb/serial/keyspan.c                         |  183 +++++++++-----=
-----
 drivers/usb/serial/keyspan.h                         |    8=20
 drivers/usb/serial/mct_u232.c                        |   59 +++---
 drivers/usb/serial/metro-usb.c                       |   65 +-----
 drivers/usb/serial/mos7720.c                         |   62 +++---
 drivers/usb/serial/mos7840.c                         |   30 ---
 drivers/usb/serial/omninet.c                         |   36 +--
 drivers/usb/serial/opticon.c                         |   11 -
 drivers/usb/serial/option.c                          |   23 ++
 drivers/usb/serial/qcserial.c                        |   33 +--
 drivers/usb/serial/quatech2.c                        |  135 ++++++--------
 drivers/usb/serial/sierra.c                          |  133 +++++++------
 drivers/usb/serial/usb-wwan.h                        |    2=20
 drivers/usb/serial/usb_wwan.c                        |  130 +++++--------
 drivers/usb/serial/whiteheat.c                       |   60 ++----
 drivers/usb/storage/unusual_devs.h                   |    6=20
 drivers/vhost/net.c                                  |    3=20
 fs/compat_ioctl.c                                    |    2=20
 fs/exec.c                                            |    3=20
 fs/lockd/mon.c                                       |   57 +++--
 fs/namei.c                                           |    4=20
 fs/nfs/blocklayout/blocklayout.c                     |   93 +++++++--
 fs/sysfs/dir.c                                       |   16 -
 include/drm/drm_pciids.h                             |    3=20
 include/linux/efi.h                                  |    5=20
 include/linux/memblock.h                             |    1=20
 include/net/cfg80211.h                               |    1=20
 init/main.c                                          |    3=20
 lib/genalloc.c                                       |    2=20
 mm/memblock.c                                        |   24 ++
 mm/rmap.c                                            |   20 +-
 net/bluetooth/smp.c                                  |    6=20
 net/mac80211/iface.c                                 |    2=20
 net/mac80211/mlme.c                                  |   35 ++-
 net/mac80211/sta_info.c                              |    4=20
 net/mac80211/util.c                                  |    4=20
 net/mac80211/wpa.c                                   |    3=20
 net/sunrpc/xprtsock.c                                |   41 +---
 net/wireless/mlme.c                                  |   12 -
 sound/pci/hda/patch_realtek.c                        |   20 +-
 usr/gen_init_cpio.c                                  |   43 ++--
 98 files changed, 1254 insertions(+), 960 deletions(-)

Alex Deucher (2):
      drm/radeon: add some new SI PCI ids
      drm/radeon: add error output if VM CS fails on cayman

Andreas Herrmann (1):
      cpufreq / powernow-k8: Remove usage of smp_processor_id() in preempti=
ble code

Anisse Astier (2):
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS vers=
ions
      ehci: Add yet-another Lucid nohandoff pci quirk

Arve Hj=F8nnev=E5g (2):
      Staging: android: binder: Fix memory leak on thread/process exit
      Staging: android: binder: Allow using highmem for binder buffers

Barry Song (2):
      dmaengine: sirf: fix a typo in dma_prep_interleaved
      dmaengine: sirf: fix a typo in moving running dma_desc to active queue

Bo Shen (1):
      ARM: at91/i2c: change id to let i2c-gpio work

Chris Metcalf (1):
      tilegx: fix some issues in the SW TSO support

Dan Williams (1):
      qmi_wwan/cdc_ether: move Novatel 551 and E362 to qmi_wwan

Dave Young (1):
      Revert "x86/mm: Fix the size calculation of mapping tables"

Felix Fietkau (2):
      mac80211: use ieee80211_free_txskb in a few more places
      Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Fred Brooks (1):
      staging: comedi: ni_daq_700: fix dio subdevice regression

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Greg Kroah-Hartman (1):
      Linux 3.6.5

Heiko Stuebner (1):
      ARM: SAMSUNG: Add naming of s3c64xx-spi devices

Ian Abbott (6):
      staging: comedi: das08: fix possible NULL deref during detach
      staging: comedi: ni_labpc: fix possible NULL deref during detach
      staging: comedi: amplc_dio200: fix possible NULL deref during detach
      staging: comedi: amplc_pc263: fix possible NULL deref during detach
      staging: comedi: amplc_pc236: fix invalid register access during deta=
ch
      staging: comedi: amplc_pc236: fix possible NULL deref during detach

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection

Jacob Shin (1):
      x86, mm: Find_early_table_space based on ranges that are actually bei=
ng mapped

Jan Beulich (1):
      x86-64: Fix page table accounting

Jan Kara (1):
      mm: fix XFS oops due to dirty pages without buffers on s390

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Johan Hedberg (1):
      Bluetooth: SMP: Fix setting unknown auth_req bits

Johan Hovold (28):
      USB: usb-wwan: fix multiple memory leaks in error paths
      USB: ch341: fix port-data memory leak
      USB: digi_acceleport: fix port-data memory leak
      USB: ipw: fix interface-data memory leak in error path
      USB: mct_u232: fix port-data memory leak
      USB: mct_u232: fix broken close
      USB: option: fix interface-data memory leak in error path
      USB: keyspan: fix NULL-pointer dereferences and memory leaks
      USB: omninet: fix port-data memory leak
      USB: qcserial: fix interface-data memory leak in error path
      USB: whiteheat: fix memory leak in error path
      USB: whiteheat: fix port-data memory leak
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: metro-usb: fix port-data memory leak
      USB: metro-usb: fix io after disconnect
      USB: mos7720: fix port-data memory leak
      USB: quatech2: fix memory leak in error path
      USB: quatech2: fix port-data memory leaks
      USB: quatech2: fix close and disconnect urb handling
      USB: quatech2: fix io after disconnect
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: sierra: fix port-data memory leak
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling

Johannes Berg (2):
      mac80211: connect with HT20 if HT40 is not permitted
      iwlwifi: fix 6000 series channel switch command

Josh Triplett (1):
      efi: Defer freeing boot services memory until after ACPI init

Josh Wu (1):
      ARM: at91/tc: fix typo in the DT document

K. Y. Srinivasan (1):
      Drivers: hv: Cleanup error handling in vmbus_open()

Kees Cook (2):
      gen_init_cpio: avoid stack overflow when expanding
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Larry Finger (1):
      b43: Fix oops on unload when firmware not found

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Linus Torvalds (1):
      VFS: don't do protected {sym,hard}links by default

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Nicolas Ferre (2):
      ARM: at91: fix external interrupts in non-DT case
      ARM: at91: fix external interrupt specification in board code

Nitin Gupta (1):
      staging: zram: Fix handling of incompressible pages

Octavian Purdila (1):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear=
 work

Oleg Nesterov (1):
      freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Oliver Neukum (2):
      xhci: fix integer overflow
      xhci: endianness xhci_calculate_intel_u2_timeout

Olof Johansson (1):
      x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Peng Tao (2):
      pnfsblock: fix non-aligned DIO read
      pnfsblock: fix non-aligned DIO write

Peter Huewe (2):
      extcon: Unregister compat class at module unload to fix oops
      extcon: unregister compat link on cleanup

Piotr Haber (1):
      bcma: fix unregistration of cores

Sarah Sharp (1):
      xhci: Fix potential NULL ptr deref in command cancellation.

Stanislav Yakovlev (1):
      net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_=
tx()

Stanislaw Gruszka (2):
      mac80211: check if key has TKIP type before updating IV
      cfg80211/mac80211: avoid state mishmash on deauth

Stef=E1n Freyr (1):
      ALSA: hda - add dock support for Thinkpad T430

Takashi Iwai (1):
      ALSA: hda - Fix silent headphone output from Toshiba P200

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Trond Myklebust (6):
      SUNRPC: Get rid of the xs_error_report socket callback
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      LOCKD: fix races in nsm_client_get
      SUNRPC: Prevent races in xs_abort_connection()
      LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero

Wei Yongjun (1):
      dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()

Will Deacon (1):
      ARM: 7559/1: smp: switch away from the idmap before updating init_mm.=
mm_count

Yinghai Lu (3):
      x86, mm: Trim memory in memblock to be page aligned
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c
      x86, mm: Use memblock memory loop instead of e820_RAM


--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkWIDAAoJEDjbvchgkmk+dwAQAL7MtFW/ubMJSIxWzcBEYcDj
8y7wSR+G7ebxNvxVCUmnpsi35jRVIFr3QVdweWyebRnfor6/zS26tvip/6PnfVNS
d8Q5CvmxyvXj1Wz3bBZr+PyQ2TqLa9VduOz69TFI1bMjILkhIFIj4o1adFl9V+fY
OYcM0FD+NE3ByB9uyODAhw3YcZ2pE3JWh/gMBii4/LCjxJdFbox6tVzNWiB2b8/I
xvTsWWTFPD/HtCJRSU0JLTaL0fT8C1hcJJjPDdLrZQgOgUCJ1pgA4NuyChfAjR/c
A7zURicqDkRgqNekkHSZ4M0+GyxTYoQV9pQjKksBFF6WWCu6lxACCOe5OG34mwv1
uoUnYdQIcoR+gNMimwGh/SibzEvoqcjf9GOFizjsv/BA1Yh8yXY5m7eYWgSMXYCw
orKBI7qdCdn64X0EMmRQGfwTMGzWPKi+nvr4Zl1k16bWdk/26ickhMhaE1Flmtbv
NcbZIVHFn8ih4NsdI7Oky9lU/9rFdJ3Uw76isnA5b138K5bSF1RFXY4xxjbrIWyq
G+BeSayWVBQ488PjjK2ZpqdWz5Z7O8Dv+1pzm8OPcHWy6qGHwqzc+0JkVK9PCX+F
Edkev9Y4sE3DiolemHgg0yjn5go2KzAoAOUua7g/BgcXIVkKacCIkfEGtwcczviD
3qUwW/QyfRHmneXgZZ/A
=+wM1
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
