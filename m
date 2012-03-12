Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2CLUe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:34:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45613 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab2CLUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:34:57 -0400
Date: Mon, 12 Mar 2012 13:34:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.24
Message-ID: <20120312203451.GA16773@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.24 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/hwmon/jc42                    |   26 +-
 Makefile                                    |    2=20
 arch/alpha/include/asm/futex.h              |    2=20
 arch/arm/Kconfig                            |    2=20
 arch/arm/mach-dove/common.c                 |    3=20
 arch/arm/mach-kirkwood/common.c             |    3=20
 arch/arm/mach-kirkwood/mpp.h                |  320 ++++++++++++++---------=
-----
 arch/arm/mach-lpc32xx/include/mach/irqs.h   |    2=20
 arch/arm/mach-lpc32xx/irq.c                 |   25 +-
 arch/arm/mach-lpc32xx/serial.c              |   20 +
 arch/arm/mach-mv78xx0/common.c              |    3=20
 arch/arm/mach-mv78xx0/mpp.h                 |  226 +++++++++----------
 arch/arm/mach-omap2/board-4430sdp.c         |   31 +-
 arch/arm/mach-omap2/board-omap4panda.c      |   22 +
 arch/arm/mach-orion5x/common.c              |    4=20
 arch/arm/mm/proc-v7.S                       |    4=20
 arch/arm/plat-orion/common.c                |    9=20
 arch/arm/plat-orion/include/plat/common.h   |    3=20
 arch/arm/plat-orion/mpp.c                   |    3=20
 arch/arm/plat-s3c24xx/dma.c                 |    2=20
 arch/avr32/Kconfig                          |    1=20
 arch/s390/Kconfig                           |    3=20
 arch/s390/include/asm/compat.h              |    7=20
 arch/s390/kernel/process.c                  |    1=20
 arch/s390/kernel/ptrace.c                   |    2=20
 arch/s390/kernel/setup.c                    |    2=20
 arch/s390/mm/fault.c                        |    1=20
 arch/s390/mm/mmap.c                         |    2=20
 block/bsg.c                                 |    3=20
 drivers/acpi/sleep.c                        |   16 +
 drivers/crypto/mv_cesa.c                    |    1=20
 drivers/gpu/drm/i915/i915_reg.h             |   15 +
 drivers/gpu/drm/i915/intel_display.c        |   22 +
 drivers/gpu/drm/radeon/r600_blit_shaders.c  |    8=20
 drivers/hid/hid-ids.h                       |    3=20
 drivers/hid/usbhid/hid-quirks.c             |    1=20
 drivers/hwmon/Kconfig                       |    5=20
 drivers/hwmon/jc42.c                        |   30 ++
 drivers/hwmon/pmbus_core.c                  |    3=20
 drivers/i2c/busses/i2c-mxs.c                |   13 -
 drivers/input/mouse/alps.c                  |    7=20
 drivers/md/dm-io.c                          |   23 +-
 drivers/md/dm-raid.c                        |    1=20
 drivers/mfd/cs5535-mfd.c                    |    6=20
 drivers/mfd/mfd-core.c                      |    2=20
 drivers/misc/cs5535-mfgpt.c                 |    2=20
 drivers/mmc/host/sdhci-esdhc-imx.c          |    5=20
 drivers/net/usb/cdc_ether.c                 |    7=20
 drivers/net/usb/usbnet.c                    |    2=20
 drivers/net/usb/zaurus.c                    |    7=20
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   25 --
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |   19 +
 drivers/net/wireless/ath/ath9k/hw.h         |    1=20
 drivers/net/wireless/ath/carl9170/tx.c      |    1=20
 drivers/regulator/88pm8607.c                |    6=20
 drivers/s390/block/dasd_eckd.c              |    2=20
 drivers/s390/block/dasd_ioctl.c             |    1=20
 drivers/s390/char/fs3270.c                  |    2=20
 drivers/s390/char/vmcp.c                    |    1=20
 drivers/s390/cio/chsc_sch.c                 |    1=20
 drivers/s390/scsi/zfcp_cfdc.c               |    1=20
 drivers/scsi/osd/osd_uld.c                  |    4=20
 drivers/staging/lirc/lirc_serial.c          |  100 ++++----
 drivers/video/omap2/dss/hdmi.c              |   86 +++++++
 drivers/watchdog/hpwdt.c                    |    5=20
 fs/autofs4/autofs_i.h                       |    1=20
 fs/autofs4/dev-ioctl.c                      |    1=20
 fs/autofs4/inode.c                          |    2=20
 fs/autofs4/waitq.c                          |   22 +
 fs/binfmt_elf.c                             |    2=20
 fs/cifs/dir.c                               |   20 +
 include/linux/compat.h                      |    4=20
 include/linux/regset.h                      |   10=20
 include/video/omapdss.h                     |    5=20
 kernel/irq/manage.c                         |   44 +++
 kernel/kprobes.c                            |    4=20
 mm/huge_memory.c                            |    6=20
 mm/memcontrol.c                             |    5=20
 mm/nommu.c                                  |    2=20
 net/mac80211/rate.c                         |    2=20
 sound/pci/hda/hda_codec.c                   |    8=20
 sound/pci/hda/hda_codec.h                   |    3=20
 sound/pci/hda/patch_conexant.c              |   22 +
 sound/pci/hda/patch_sigmatel.c              |    2=20
 sound/soc/imx/imx-ssi.c                     |    2=20
 sound/soc/soc-dapm.c                        |   12 -
 86 files changed, 855 insertions(+), 492 deletions(-)

Akio Idehara (1):
      Input: ALPS - fix touchpad detection when buttons are pressed

Alan Stern (1):
      HID: usbhid: Add NOGET quirk for the AIREN Slim+ keyboard

Alban Browaeys (1):
      drm/i915: Prevent a machine hang by checking crtc->active before load=
ing lut

Andrea Arcangeli (1):
      mm: thp: fix BUG on mm->nr_ptes

Andrew Lunn (2):
      ARM: orion: Fix USB phy for orion5x.
      ARM: orion: Fix Orion5x GPIO regression from MPP cleanup

Andrew Morton (1):
      alpha: fix 32/64-bit bug in futex support

Anton Vorontsov (1):
      mm: memcg: Correct unregistring of events attached to the same eventfd

Ben Hutchings (4):
      media: staging: lirc_serial: Fix init/exit order
      media: staging: lirc_serial: Free resources on failure paths of lirc_=
serial_probe()
      media: staging: lirc_serial: Fix deadlock on resume failure
      media: staging: lirc_serial: Do not assume error codes returned by re=
quest_irq()

Boaz Harrosh (1):
      osd_uld: Bump MAX_OSD_DEVICES from 64 to 1,048,576

Christian Gmeiner (1):
      mfd: Fix cs5535 section mismatch

Danny Kukawka (1):
      cs5535-mfgpt: don't call __init function from __devinit

David Howells (2):
      S390: KEYS: Enable the compat keyctl wrapper on s390x
      NOMMU: Don't need to clear vm_mm when deleting a VMA

Eugeni Dodonov (3):
      drm/i915: gen7: implement rczunit workaround
      drm/i915: gen7: Implement an L3 caching workaround.
      drm/i915: gen7: work around a system hang on IVB

Fabio Baltieri (1):
      avr32: select generic atomic64_t support

Felix Fietkau (1):
      ath9k_hw: prevent writes to const data on AR9160

Greg Kroah-Hartman (1):
      Linux 3.0.24

Guenter Roeck (2):
      hwmon: (pmbus_core) Fix maximum number of POUT alarm attributes
      hwmon: (jc42) Add support for AT30TS00, TS3000GB2, TSE2002GB2, and MC=
P9804

Gusakov Andrey (1):
      ARM: S3C24XX: DMA resume regression fix

H. Peter Anvin (2):
      regset: Prevent null pointer reference on readonly regsets
      regset: Return -EFAULT, not -EIO, on host-side memory fault

Heiko Carstens (1):
      compat: fix compile breakage on s390

Ian Kent (1):
      autofs: work around unhappy compat problem on x86-64

Jan Beulich (1):
      kprobes: adjust "fix a memory leak in function pre_handler_kretprobe(=
)"

Javier Martin (1):
      ASoC: i.MX SSI: Fix DSP_A format.

Jean Delvare (2):
      mfd: Fix ACPI conflict check
      hwmon: (jc42) Add support for ST Microelectronics STTS2002 and STTS30=
00

Jeff Layton (1):
      cifs: fix dentry refcount leak when opening a FIFO on lookup

Jett.Zhou (1):
      regulator: fix the ldo configure according to 88pm860x spec

Jonathan E Brassow (1):
      dm raid: fix flush support

Keng-Yu Lin (1):
      ACPI / PM: Do not save/restore NVS on Asus K54C/K54HR

Kenneth Graunke (1):
      drm/i915: gen7: Disable the RHWO optimization as it can cause GPU han=
gs.

Linus Torvalds (1):
      Fix autofs compile without CONFIG_COMPAT

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon/kms: set SX_MISC in the r6xx blit code (v2)

Mark Brown (1):
      ASoC: dapm: Check for bias level when powering down

Maxim Uvarov (1):
      watchdog: hpwdt: clean up set_memory_x call for 32 bit

Milan Broz (1):
      dm io: fix discard support

Mohammed Shafi Shajakhan (1):
      mac80211: zero initialize count field in ieee80211_tx_rate

Nicolas Cavallari (1):
      carl9170: Fix memory accounting when sta is in power-save mode.

Phil Sutter (1):
      crypto: mv_cesa - fix final callback not ignoring input data

Roland Stigge (5):
      ARM: LPC32xx: serial.c: HW bug workaround
      ARM: LPC32xx: serial.c: Fixed loop limit
      ARM: LPC32xx: irq.c: Clear latched event
      ARM: LPC32xx: Fix interrupt controller init
      ARM: LPC32xx: Fix irq on GPI_28

Sascha Hauer (1):
      mmc: sdhci-esdhc-imx: fix for mmc cards on i.MX5

Scott Talbert (1):
      Move Logitech Harmony 900 from cdc_ether to zaurus

Sebastian Siewior (1):
      net/usbnet: avoid recursive locking in usbnet_stop()

Stanislaw Gruszka (1):
      bsg: fix sysfs link remove warning

Takashi Iwai (2):
      ALSA: hda - Add a fake mute feature
      ALSA: hda - Always set HP pin in unsol handler for STAC/IDT codecs

Thomas Gleixner (1):
      genirq: Clear action->thread_mask if IRQ_ONESHOT is not set

Tomi Valkeinen (7):
      OMAP: DSS2: HDMI: use default dividers
      OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
      OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
      OMAPDSS: remove wrong HDMI HPD muxing
      OMAP: 4430SDP/Panda: setup HDMI GPIO muxes
      OMAP: 4430SDP/Panda: add HDMI HPD gpio
      OMAPDSS: HDMI: PHY burnout fix

Will Deacon (1):
      ARM: 7345/1: errata: update workaround for A9 erratum #743622

Wolfram Sang (1):
      i2c: mxs: only flag completion when queue is completely done


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPXl3rAAoJEDjbvchgkmk+m9sQAL5OsV9RhU3M9mqRZ+xtzuhu
t1JehC7jTAWh65arXosz8hEk00jpQ8ueCbJooJ6eNMmRFhfxXlXcqT50I5PSc7ah
x6XPFoa5v6j+rHn/EtzKMfI52XPMqoYIQc8QLEp0vqdTZyuFioQAeY9OVM8isEKZ
0HtsXxzWnO/zohJ9uDfSq+ACQwvw09NqcuiiKZA2BO8iNt0934G4XP/cDYY8Thn0
K3kcGyi2J4+LVcKs2oNbT15QBJNRGhr5CDldgk2ZNWprM+/rEm2ttEEAi18XbjNb
+bZBX5+sdNcSdF1lk2JgLBEUCfBieJtvWiFX1wkeU+3/ZdLvf/ZGMetK8h5BbPcU
HB1sjMgUKBwcjNnbCEynI27bg5qD2Fo5DZhXihtITnmnLHOYatKUHBlDXwbqppYs
8ep5+NvHVSbY1Ijv81EPPN61uPyMB0DZdObnRxE4TUL9dXFBpgm9wYN7AUNE9+W2
x2lJa0nbzCRN+l4qfpIupMpRDHS4rq7fIAkn3vGNI29XR9Ap7jbd2qFEGQ93YEpA
CNqozPNGSGAbV2tk8Gi6DNYcEBH4h056ILYc5HdRD9zVTwEcgqwX/I4S2PZSbQfZ
Rdk6J9O13ovrcIz1+JeySB7yYHld7eebUTwcgMWWyM6WseWU0SL5OREPdg/CCcnA
7e2G5DtgrzEvOWnK3JpI
=vq7a
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
