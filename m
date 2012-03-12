Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2CLUeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:34:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2CLUeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:34:04 -0400
Date: Mon, 12 Mar 2012 13:33:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.10
Message-ID: <20120312203359.GA16543@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.10 kernel.

All users of the 3.2 kernel series must upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
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
 arch/arm/include/asm/pmu.h                  |    2=20
 arch/arm/kernel/perf_event.c                |   22 -
 arch/arm/kernel/perf_event_v6.c             |   22 -
 arch/arm/kernel/perf_event_v7.c             |   11=20
 arch/arm/kernel/perf_event_xscale.c         |   20 +
 arch/arm/mach-dove/common.c                 |    3=20
 arch/arm/mach-kirkwood/common.c             |    3=20
 arch/arm/mach-kirkwood/mpp.h                |  320 ++++++++++++++---------=
-----
 arch/arm/mach-lpc32xx/include/mach/irqs.h   |    2=20
 arch/arm/mach-lpc32xx/irq.c                 |   25 +-
 arch/arm/mach-lpc32xx/serial.c              |   20 +
 arch/arm/mach-mv78xx0/common.c              |    3=20
 arch/arm/mach-mv78xx0/mpp.h                 |  226 +++++++++----------
 arch/arm/mach-omap2/board-4430sdp.c         |   22 +
 arch/arm/mach-omap2/board-omap4panda.c      |   22 +
 arch/arm/mach-omap2/omap-iommu.c            |    3=20
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
 arch/s390/kernel/signal.c                   |    1=20
 arch/s390/mm/fault.c                        |    1=20
 arch/s390/mm/mmap.c                         |    2=20
 arch/x86/include/asm/perf_event.h           |    8=20
 arch/x86/kernel/cpu/perf_event.h            |    8=20
 arch/x86/kernel/cpu/perf_event_amd.c        |   37 +++
 arch/x86/kvm/svm.c                          |    5=20
 block/bsg.c                                 |    3=20
 drivers/acpi/sleep.c                        |   16 +
 drivers/crypto/mv_cesa.c                    |    1=20
 drivers/gpu/drm/i915/i915_reg.h             |   15 +
 drivers/gpu/drm/i915/intel_display.c        |   32 ++
 drivers/gpu/drm/radeon/r600_blit_shaders.c  |    8=20
 drivers/hid/hid-ids.h                       |    3=20
 drivers/hid/usbhid/hid-quirks.c             |    1=20
 drivers/hwmon/Kconfig                       |    5=20
 drivers/hwmon/jc42.c                        |   30 ++
 drivers/hwmon/pmbus/pmbus_core.c            |    3=20
 drivers/hwmon/pmbus/zl6100.c                |   10=20
 drivers/i2c/busses/i2c-mxs.c                |   13 -
 drivers/input/mouse/alps.c                  |    7=20
 drivers/iommu/amd_iommu_init.c              |    2=20
 drivers/iommu/omap-iommu.c                  |    3=20
 drivers/md/dm-flakey.c                      |    2=20
 drivers/md/dm-io.c                          |   23 +-
 drivers/md/dm-ioctl.c                       |    2=20
 drivers/md/dm-raid.c                        |   17 -
 drivers/md/dm-thin-metadata.c               |   25 +-
 drivers/mfd/cs5535-mfd.c                    |    6=20
 drivers/mfd/mfd-core.c                      |    2=20
 drivers/mfd/wm8994-core.c                   |   14 +
 drivers/misc/cs5535-mfgpt.c                 |    2=20
 drivers/mmc/host/atmel-mci.c                |   21 -
 drivers/mmc/host/sdhci-esdhc-imx.c          |    5=20
 drivers/net/usb/cdc_ether.c                 |    7=20
 drivers/net/usb/usbnet.c                    |    2=20
 drivers/net/usb/zaurus.c                    |    7=20
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   25 --
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |   19 +
 drivers/net/wireless/ath/ath9k/hw.h         |    1=20
 drivers/net/wireless/ath/carl9170/tx.c      |    9=20
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   10=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |   36 ++-
 drivers/rapidio/devices/tsi721.c            |    5=20
 drivers/regulator/88pm8607.c                |    6=20
 drivers/s390/block/dasd_eckd.c              |    2=20
 drivers/s390/block/dasd_ioctl.c             |    1=20
 drivers/s390/char/fs3270.c                  |    1=20
 drivers/s390/char/vmcp.c                    |    1=20
 drivers/s390/cio/chsc_sch.c                 |    1=20
 drivers/s390/cio/qdio_main.c                |    4=20
 drivers/s390/scsi/zfcp_cfdc.c               |    1=20
 drivers/scsi/osd/osd_uld.c                  |    4=20
 drivers/spi/spi-topcliff-pch.c              |    6=20
 drivers/staging/media/lirc/lirc_serial.c    |  100 ++++----
 drivers/tty/Kconfig                         |    2=20
 drivers/video/omap2/dss/hdmi.c              |    3=20
 drivers/video/omap2/dss/ti_hdmi.h           |    4=20
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c   |   77 +++++-
 drivers/video/via/hw.c                      |    4=20
 drivers/watchdog/hpwdt.c                    |    5=20
 fs/aio.c                                    |    2=20
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
 kernel/kprobes.c                            |   12 -
 mm/huge_memory.c                            |    6=20
 mm/memcontrol.c                             |    5=20
 mm/nommu.c                                  |    2=20
 net/mac80211/rate.c                         |    2=20
 sound/pci/hda/hda_codec.c                   |    8=20
 sound/pci/hda/hda_codec.h                   |    3=20
 sound/pci/hda/patch_conexant.c              |   22 +
 sound/pci/hda/patch_realtek.c               |    2=20
 sound/pci/hda/patch_sigmatel.c              |    2=20
 sound/soc/imx/imx-ssi.c                     |    2=20
 sound/soc/soc-dapm.c                        |   12 -
 116 files changed, 1081 insertions(+), 585 deletions(-)

Akio Idehara (1):
      Input: ALPS - fix touchpad detection when buttons are pressed

Alan Stern (1):
      HID: usbhid: Add NOGET quirk for the AIREN Slim+ keyboard

Alban Browaeys (1):
      drm/i915: Prevent a machine hang by checking crtc->active before load=
ing lut

Alexandre Bounine (1):
      rapidio/tsi721: fix queue wrapping bug in inbound doorbell handler

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

Christian Lamparter (1):
      carl9170: fix frame delivery if sta is in powersave mode

Danny Kukawka (2):
      cs5535-mfgpt: don't call __init function from __devinit
      spi-topcliff-pch: rename pch_spi_pcidev to pch_spi_pcidev_driver

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

Florian Tobias Schandinat (2):
      viafb: select HW scaling on VX900 for IGA2
      viafb: fix IGA1 modesetting on VX900

Greg Kroah-Hartman (1):
      Linux 3.2.10

Guenter Roeck (3):
      hwmon: (pmbus_core) Fix maximum number of POUT alarm attributes
      hwmon: (jc42) Add support for AT30TS00, TS3000GB2, TSE2002GB2, and MC=
P9804
      hwmon: (zl6100) Maintain delay parameter in driver instance data

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
      x86/amd: iommu_set_device_table() must not be __init

Javier Martin (1):
      ASoC: i.MX SSI: Fix DSP_A format.

Jean Delvare (2):
      mfd: Fix ACPI conflict check
      hwmon: (jc42) Add support for ST Microelectronics STTS2002 and STTS30=
00

Jeff Layton (1):
      cifs: fix dentry refcount leak when opening a FIFO on lookup

Jeff Moyer (1):
      aio: wake up waiters when freeing unused kiocbs

Jesper Juhl (1):
      dm ioctl: do not leak argv if target message only contains whitespace

Jett.Zhou (1):
      regulator: fix the ldo configure according to 88pm860x spec

Joe Thornber (2):
      dm thin metadata: unlock superblock in init_pmd error path
      dm thin metadata: decrement counter after removing mapped block

Joerg Roedel (1):
      perf/x86/kvm: Fix Host-Only/Guest-Only counting with SVM disabled

Johannes Berg (1):
      iwlwifi: fix key removal

Jonathan E Brassow (2):
      dm raid: set MD_CHANGE_DEVS when rebuilding
      dm raid: fix flush support

Keng-Yu Lin (1):
      ACPI / PM: Do not save/restore NVS on Asus K54C/K54HR

Kenneth Graunke (1):
      drm/i915: gen7: Disable the RHWO optimization as it can cause GPU han=
gs.

Larry Finger (1):
      rtl8192cu: Add new device IDs

Linus Torvalds (1):
      Fix autofs compile without CONFIG_COMPAT

Ludovic Desroches (1):
      mmc: atmel-mci: don't use dma features when using DMA with no chan av=
ailable

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon/kms: set SX_MISC in the r6xx blit code (v2)

Mark Brown (2):
      mfd: Test for jack detection when deciding if wm8994 should suspend
      ASoC: dapm: Check for bias level when powering down

Maxim Uvarov (1):
      watchdog: hpwdt: clean up set_memory_x call for 32 bit

Mike Snitzer (2):
      dm flakey: fix crash on read when corrupt_bio_byte not set
      dm thin metadata: remove incorrect close_device on creation error pat=
hs

Milan Broz (1):
      dm io: fix discard support

Mohammed Shafi Shajakhan (1):
      mac80211: zero initialize count field in ieee80211_tx_rate

Nicolas Cavallari (1):
      carl9170: Fix memory accounting when sta is in power-save mode.

Ohad Ben-Cohen (2):
      ARM: OMAP: make iommu subsys_initcall to fix builtin omap3isp
      ARM: OMAP: fix iommu, not mailbox

Phil Sutter (1):
      crypto: mv_cesa - fix final callback not ignoring input data

Prashanth Nageshappa (1):
      kprobes: return proper error code from register_kprobe()

Rob Clark (1):
      OMAPDSS: HDMI: hot plug detect fix

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

Steffen Maier (1):
      S390: qdio: fix handler function arguments for zfcp data router

Stephen Rothwell (1):
      tty/powerpc: early udbg consoles can't be modules

Takashi Iwai (3):
      ALSA: hda/realtek - Fix resume of multiple input sources
      ALSA: hda - Add a fake mute feature
      ALSA: hda - Always set HP pin in unsol handler for STAC/IDT codecs

Thomas Gleixner (1):
      genirq: Clear action->thread_mask if IRQ_ONESHOT is not set

Tomi Valkeinen (6):
      OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
      OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
      OMAPDSS: remove wrong HDMI HPD muxing
      OMAP: 4430SDP/Panda: setup HDMI GPIO muxes
      OMAP: 4430SDP/Panda: add HDMI HPD gpio
      OMAPDSS: HDMI: PHY burnout fix

Will Deacon (5):
      ARM: 7345/1: errata: update workaround for A9 erratum #743622
      ARM: 7354/1: perf: limit sample_period to half max_period in non-samp=
ling mode
      ARM: 7355/1: perf: clear overflow flag when disabling counter on ARMv=
7 PMU
      ARM: 7356/1: perf: check that we have an event in the PMU IRQ handlers
      ARM: 7357/1: perf: fix overflow handling for xscale2 PMUs

Wolfram Sang (1):
      i2c: mxs: only flag completion when queue is completely done

Wu Fengguang (1):
      drm/i915: fix ELD writing for SandyBridge


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPXl23AAoJEDjbvchgkmk+uGcP/3fB4gLG5REmvbLK/AxuDCAN
hi2lr3R2m2OakWQW3+/Qkufa5qjSInspc4eWdWXJJki7TSxvrxAsL4kGiFvhcqhi
im1/a0s/RfG5A3CoF2SySQeVBFafkfVLLATTz5GzTVBYzTOM6o/DXpNZr/qhhlY7
W+trlVwIgzi49okMii6PYj/E3Q/IEmNvSi1N3imuzJf1AKd7Wiz2/1AX6HMmEq4E
LUJz0t4nizwIdlu8qYD5XLhpDz+gUmPb14ZwtbtkZ9KG+AoKlw0I0m6f/qbYKaf1
j9/2swTaVPcZY40jNvl0MVktnFxRIUuKTDsDvkFHNpGFElGvqEeE33cqOD64bISu
pnxOWf0pUs3Jw4iQcbHu3/6AsPQa55WAiFmcYLuK+kJuQwXRYR8un1ilmc0Xsy8q
rfjwVqo5kVMOUJkgKbml00DMDVvRPR1x/MDCCnUT7owq0adhHY/Dx5m5ou2ppdRr
tpZV4sr1wirdyT/ggX+qYFvqqeBn+v63a1s0tAqCioULwtSDSdnwBjgPugq/Cr6p
38UsLd2MsVr0dsS2rnBN8oeEaYWo97rf56Ja9QjbwCD5/7Ez+KFjAw9i0KYUpOru
7NtXcPFqORT36kFaILzaGGcsIzSsNN8dV/T3XYvhlwjKV2+yWMXJdZoQfUML5hcP
CWX7QY3G2o/oHDl2IlvK
=HRX8
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
