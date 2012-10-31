Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab2JaRf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:35:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50563 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965559Ab2JaRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:35:51 -0400
Date: Wed, 31 Oct 2012 10:35:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.17
Message-ID: <20121031173548.GA12844@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.17 kernel.

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

 Documentation/devicetree/bindings/arm/atmel-at91.txt |    2=20
 Makefile                                             |    2=20
 arch/arm/kernel/smp.c                                |   14 +
 arch/arm/mach-at91/at91rm9200_devices.c              |    2=20
 arch/arm/mach-at91/at91sam9260_devices.c             |    2=20
 arch/arm/mach-at91/at91sam9261_devices.c             |    2=20
 arch/arm/mach-at91/at91sam9263_devices.c             |    2=20
 arch/arm/mach-at91/at91sam9rl_devices.c              |    2=20
 arch/arm/mach-at91/setup.c                           |    2=20
 arch/arm/mach-exynos/common.c                        |    5=20
 arch/arm/mach-s3c24xx/s3c2416.c                      |    2=20
 arch/arm/mach-s3c24xx/s3c2443.c                      |    4=20
 arch/arm/mach-s5p64x0/common.c                       |    3=20
 arch/arm/mach-s5pc100/common.c                       |    3=20
 arch/arm/mach-s5pv210/common.c                       |    3=20
 arch/arm/plat-samsung/include/plat/spi-core.h        |   30 +++
 arch/x86/include/asm/efi.h                           |    1=20
 arch/x86/kernel/e820.c                               |    3=20
 arch/x86/kernel/setup.c                              |   27 ++-
 arch/x86/mm/init.c                                   |   69 ++++---
 arch/x86/platform/efi/efi.c                          |   43 ++--
 drivers/bcma/main.c                                  |    5=20
 drivers/cpufreq/powernow-k8.c                        |    9 -
 drivers/dma/imx-dma.c                                |    4=20
 drivers/dma/sirf-dma.c                               |    4=20
 drivers/gpu/drm/i915/intel_lvds.c                    |    8=20
 drivers/gpu/drm/radeon/evergreen_cs.c                |    1=20
 drivers/hv/channel.c                                 |   24 +-
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  164 +++++++++-----=
-----
 drivers/rtc/rtc-imxdi.c                              |    2=20
 drivers/staging/android/binder.c                     |   30 +++
 drivers/staging/comedi/drivers/amplc_pc236.c         |    2=20
 drivers/usb/core/hub.c                               |    7=20
 drivers/usb/host/pci-quirks.c                        |    9 -
 drivers/usb/host/xhci-ring.c                         |   11 +
 drivers/usb/serial/mos7840.c                         |   30 ---
 drivers/usb/serial/opticon.c                         |   11 +
 drivers/usb/serial/sierra.c                          |   26 ++-
 drivers/usb/serial/whiteheat.c                       |    1=20
 drivers/usb/storage/unusual_devs.h                   |    6=20
 drivers/vhost/net.c                                  |    3=20
 fs/compat_ioctl.c                                    |    2=20
 fs/exec.c                                            |    3=20
 fs/sysfs/dir.c                                       |   16 -
 include/drm/drm_pciids.h                             |    3=20
 include/linux/efi.h                                  |    5=20
 include/linux/memblock.h                             |    1=20
 init/main.c                                          |    3=20
 lib/genalloc.c                                       |    2=20
 mm/memblock.c                                        |   24 ++
 mm/rmap.c                                            |   20 +-
 net/bluetooth/smp.c                                  |    6=20
 net/mac80211/wpa.c                                   |    3=20
 net/sunrpc/xprtsock.c                                |   41 +---
 sound/pci/hda/patch_realtek.c                        |    1=20
 usr/gen_init_cpio.c                                  |   43 ++--
 56 files changed, 468 insertions(+), 285 deletions(-)

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

Felix Fietkau (1):
      Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Greg Kroah-Hartman (1):
      Linux 3.4.17

Heiko Stuebner (1):
      ARM: SAMSUNG: Add naming of s3c64xx-spi devices

Ian Abbott (1):
      staging: comedi: amplc_pc236: fix invalid register access during deta=
ch

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection

Jacob Shin (1):
      x86, mm: Find_early_table_space based on ranges that are actually bei=
ng mapped

Jan Kara (1):
      mm: fix XFS oops due to dirty pages without buffers on s390

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Johan Hedberg (1):
      Bluetooth: SMP: Fix setting unknown auth_req bits

Johan Hovold (9):
      USB: whiteheat: fix memory leak in error path
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling

Josh Triplett (1):
      efi: Defer freeing boot services memory until after ACPI init

Josh Wu (1):
      ARM: at91/tc: fix typo in the DT document

K. Y. Srinivasan (1):
      Drivers: hv: Cleanup error handling in vmbus_open()

Kees Cook (2):
      gen_init_cpio: avoid stack overflow when expanding
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Octavian Purdila (1):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear=
 work

Oleg Nesterov (1):
      freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Olof Johansson (1):
      x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Piotr Haber (1):
      bcma: fix unregistration of cores

Sarah Sharp (1):
      xhci: Fix potential NULL ptr deref in command cancellation.

Sjoerd Simons (1):
      drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13

Stanislaw Gruszka (1):
      mac80211: check if key has TKIP type before updating IV

Stef=E1n Freyr (1):
      ALSA: hda - add dock support for Thinkpad T430

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Trond Myklebust (4):
      SUNRPC: Get rid of the xs_error_report socket callback
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      SUNRPC: Prevent races in xs_abort_connection()

Wei Yongjun (1):
      dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()

Will Deacon (1):
      ARM: 7559/1: smp: switch away from the idmap before updating init_mm.=
mm_count

Yinghai Lu (3):
      x86, mm: Trim memory in memblock to be page aligned
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c
      x86, mm: Use memblock memory loop instead of e820_RAM


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkWFzAAoJEDjbvchgkmk+gd0P/iDeTba6iCkwR+SYVSHLTtMe
FXN63qOtQwlkS0I5MgRxyYpqMG2uSmz9W58U4PMaN1srvvsfhr/MkoYFGOaHGQcx
0WOcZndsG44ayjfMeF4xvt/hOycwoAV7Zi9nO9mZndTaUNIKwoeu1lQCZojQNvTk
36UzAgl0E1ylSLR1SdOElIXjm43PlmUiNcVA/yx0FGd6A8WddJoQgyscBkDoYDqe
PSJAKMAeEqPDIhh+O0FlSIR3LK2WuoEoPT8tgIjsZ/KokE7fgKLTbYmPg9AQelTn
TVSVNrodwEowwjjRNnCgSg44XvNLmKeOv0IW3nVblV5TLXZoNqYR2oovF6PdANfN
WyoQISTNxb5mXENHucoY0PuTgRR1YbtGgKDhMFqMd3u/arhgvGOcenMJJFlIOevA
gLeFrHifIZl5ciZ81wrSQeNxKZXypBiVF69Pa94/fY5ARTOSHkyFI+Hwyo+c0dJk
fyAXQM/sY7wOx/6nPGMFvvObJbmoSQFCMLzQcTd1Js5IAkf1yDlbPi9SFuxLX9yZ
5kKcL5d4MStCmodBI5+6vlCCX/3TKCd/FEPJ8NcdAwjKL+GrZGYqefvIHavcKs3T
mUR/xsizNdR8ShQ30snY5AVoI0CKyej0oWLm9DUUxSxojYRqKExQSw6qhe75hlHn
6QzggtHkTMgcXbzE0k2c
=+Su6
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
