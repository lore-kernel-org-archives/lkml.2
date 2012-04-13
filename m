Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2DMQuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:50:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab2DMQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:50:08 -0400
Date: Fri, 13 Apr 2012 09:49:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.2
Message-ID: <20120413164904.GA28040@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.2 kernel.

All users of the 3.3 kernel series must upgrade.

The updated 3.3.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.3.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/arm/mach-at91/at91sam9263_devices.c           |    3=20
 arch/arm/mach-at91/at91sam9g45_devices.c           |    6=20
 arch/arm/mach-at91/board-sam9263ek.c               |    1=20
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    1=20
 arch/m68k/mac/config.c                             |    3=20
 arch/x86/include/asm/timer.h                       |    8 -
 arch/x86/kernel/apic/io_apic.c                     |   40 +----
 arch/x86/kernel/kgdb.c                             |   60 +++++++
 arch/x86/kernel/tsc.c                              |    3=20
 arch/x86/net/bpf_jit_comp.c                        |    2=20
 drivers/acpi/acpica/tbfadt.c                       |    8 -
 drivers/acpi/processor_thermal.c                   |   45 ++++-
 drivers/base/firmware_class.c                      |   96 ++++++++----
 drivers/base/power/runtime.c                       |    3=20
 drivers/base/regmap/regcache-rbtree.c              |    8 -
 drivers/dma/ioat/dma.c                             |   16 +-
 drivers/dma/ioat/dma.h                             |    6=20
 drivers/dma/ioat/dma_v2.c                          |    8 -
 drivers/dma/ioat/dma_v3.c                          |    8 -
 drivers/gpu/drm/drm_fb_helper.c                    |    8 -
 drivers/gpu/drm/i915/i915_drv.c                    |    2=20
 drivers/gpu/drm/i915/i915_reg.h                    |    1=20
 drivers/gpu/drm/i915/intel_bios.c                  |   23 ++-
 drivers/gpu/drm/i915/intel_display.c               |    6=20
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 +
 drivers/gpu/drm/i915/intel_sprite.c                |    3=20
 drivers/gpu/drm/radeon/atom.c                      |   15 +
 drivers/gpu/drm/radeon/atom.h                      |    1=20
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   12 +
 drivers/media/video/uvc/uvc_video.c                |   50 ++++--
 drivers/mfd/da9052-spi.c                           |    4=20
 drivers/mfd/twl6030-irq.c                          |   13 +
 drivers/misc/kgdbts.c                              |  160 +++++++++++++++-=
-----
 drivers/mmc/core/sdio_bus.c                        |   12 +
 drivers/mmc/host/atmel-mci.c                       |    9 +
 drivers/mmc/host/sdhci-dove.c                      |    1=20
 drivers/mtd/devices/block2mtd.c                    |    1=20
 drivers/mtd/devices/doc2000.c                      |    2=20
 drivers/mtd/devices/doc2001.c                      |    2=20
 drivers/mtd/devices/doc2001plus.c                  |    2=20
 drivers/mtd/devices/docg3.c                        |    2=20
 drivers/mtd/devices/lart.c                         |    1=20
 drivers/mtd/devices/m25p80.c                       |    1=20
 drivers/mtd/devices/sst25l.c                       |    1=20
 drivers/mtd/maps/ixp4xx.c                          |    5=20
 drivers/mtd/maps/lantiq-flash.c                    |    3=20
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    2=20
 drivers/net/ethernet/broadcom/tg3.c                |    4=20
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   12 -
 drivers/net/ethernet/marvell/sky2.c                |    5=20
 drivers/net/ethernet/via/via-rhine.c               |   12 -
 drivers/net/usb/cdc_eem.c                          |    1=20
 drivers/net/usb/zaurus.c                           |    5=20
 drivers/net/wireless/ath/ath9k/calib.c             |    5=20
 drivers/net/wireless/ath/ath9k/main.c              |    8 -
 drivers/net/wireless/iwlegacy/3945-mac.c           |    1=20
 drivers/net/wireless/iwlegacy/4965-mac.c           |    1=20
 drivers/net/wireless/iwlegacy/common.c             |   18 ++
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2=20
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    2=20
 drivers/platform/x86/acer-wmi.c                    |    1=20
 drivers/pnp/pnpacpi/core.c                         |    7=20
 drivers/staging/android/lowmemorykiller.c          |   47 ------
 drivers/target/tcm_fc/tcm_fc.h                     |    1=20
 drivers/target/tcm_fc/tfc_cmd.c                    |   10 +
 drivers/target/tcm_fc/tfc_conf.c                   |   13 +
 drivers/target/tcm_fc/tfc_io.c                     |    2=20
 drivers/usb/host/ohci-at91.c                       |    4=20
 fs/cifs/file.c                                     |   10 +
 fs/locks.c                                         |    3=20
 fs/nfs/nfs4proc.c                                  |    2=20
 include/linux/fs.h                                 |    5=20
 include/linux/kernel.h                             |   13 +
 include/linux/kgdb.h                               |    7=20
 include/linux/kmod.h                               |   27 ++-
 kernel/cred.c                                      |    2=20
 kernel/debug/debug_core.c                          |   53 +++---
 kernel/irq/migration.c                             |   10 -
 kernel/kmod.c                                      |  117 +++++++++++----
 kernel/power/hibernate.c                           |   18 --
 kernel/power/process.c                             |    8 +
 kernel/power/suspend.c                             |    7=20
 kernel/power/user.c                                |   10 -
 kernel/sysctl.c                                    |    8 -
 kernel/trace/trace.c                               |    4=20
 kernel/trace/trace_entries.h                       |   16 +-
 kernel/trace/trace_export.c                        |    2=20
 net/mac80211/agg-rx.c                              |    3=20
 net/rose/rose_dev.c                                |    4=20
 scripts/mod/modpost.c                              |    9 -
 scripts/mod/modpost.h                              |    1=20
 security/tomoyo/mount.c                            |   38 ++--
 sound/pci/hda/patch_realtek.c                      |   11 -
 sound/soc/codecs/ak4642.c                          |    2=20
 sound/soc/codecs/wm8994.c                          |    2=20
 sound/soc/tegra/tegra_i2s.c                        |    2=20
 97 files changed, 817 insertions(+), 415 deletions(-)

Alan Stern (1):
      PM / Runtime: don't forget to wake up waitqueue on failure

Alex Deucher (1):
      drm/radeon/kms: fix fans after resume

Alf H=F8gemark (1):
      mmc: sdhci-dove: Fix compile error by including module.h

Andi Kleen (1):
      ACPI: Do cpufreq clamping for throttling per package v2

Andreas Mohr (1):
      via-rhine: fix wait-bit inversion.

Anisse Astier (1):
      drm/i915: no-lvds quirk on MSI DC500

Artem Bityutskiy (7):
      mtd: sst25l: initialize writebufsize
      mtd: doc2001plus: initialize writebufsize
      mtd: doc2000: initialize writebufsize
      mtd: doc2001: initialize writebufsize
      mtd: docg3: initialize writebufsize
      mtd: block2mtd: initialize writebufsize
      mtd: lart: initialize writebufsize

Axel Lin (1):
      mfd: Fix section mismatch warning for da9052-spi

Brian Norris (1):
      mtd: m25p80: set writebufsize

Chris Rankin (1):
      media: dvb_frontend: regression fix: userspace ABI broken for xine

Chris Wilson (2):
      drm: Validate requested virtual size against allocated fb size
      drm/i915: Sanitize BIOS debugging bits from PIPECONF

Dan Williams (1):
      ioat: fix size of 'completion' for Xen

Daniel Schwierzeck (1):
      mtd: mips: lantiq: reintroduce support for cmdline partitions

Daniel Vetter (1):
      drm/i915: quirk away broken OpRegion VBT

David Rientjes (1):
      android, lowmemorykiller: remove task handoff notifier

Feiran Zhuang (1):
      x86 bpf_jit: fix a bug in emitting the 16-bit immediate operand of AND

Frank Rowand (1):
      modpost: Fix modpost license checking of vmlinux.o

Geert Uytterhoeven (1):
      m68k/mac: Add missing platform check before registering platform devi=
ces

Greg Kroah-Hartman (2):
      Revert "x86/ioapic: Add register level checks to detect bogus io-apic=
 entries"
      Linux 3.3.2

Guan Xin (1):
      USB: Add Motorola Rokr E6 Id to the USBNet driver "zaurus"

Jan Beulich (1):
      modpost: fix ALL_INIT_DATA_SECTIONS

Jason Wessel (5):
      kgdb,debug_core: pass the breakpoint struct instead of address and me=
mory
      kgdbts: Fix kernel oops with CONFIG_DEBUG_RODATA
      kgdbts: (1 of 2) fix single step awareness to work correctly with SMP
      kgdbts: (2 of 2) fix single step awareness to work correctly with SMP
      x86,kgdb: Fix DEBUG_RODATA limitation using text_poke()

Jesse Barnes (1):
      drm/i915: treat src w & h as fixed point in sprite handling code

Jiang Liu (1):
      genirq: Adjust irq thread affinity on IRQ_SET_MASK_OK_NOCOPY return v=
alue

Julian Anastasov (1):
      ACPICA: Fix regression in FADT revision checks

Kees Cook (1):
      sysctl: fix write access to dmesg_restrict/kptr_restrict

Kenth Eriksson (1):
      Fix non TBI PHY access; a bad merge undid bug fix in a previous commi=
t.

Kuninori Morimoto (1):
      ASoC: ak4642: fixup: mute needs +1 step

Larry Finger (1):
      rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: Fix low-gain setting when s=
canning

Laurent Pinchart (1):
      uvcvideo: Fix race-related crash in uvc_video_clock_update()

Lee, Chun-Yi (1):
      acer-wmi: No wifi rfkill on Sony machines

Lino Sanfilippo (1):
      sky2: dont overwrite settings for PHY Quick link

Ludovic Desroches (1):
      mmc: atmel-mci: correct data timeout computation

Marc Kleine-Budde (1):
      mtd: ixp4xx: oops in ixp4xx_flash_probe

Mark Brown (1):
      ASoC: wm8994: Update WM8994 DCS calibration

Mark Rustad (2):
      tcm_fc: Add abort flag for gracefully handling exchange timeout
      tcm_fc: Do not free tpg structure during wq allocation failure

Matt Carlson (1):
      tg3: Fix 5717 serdes powerdown problem

Nicolas Ferre (2):
      USB: ohci-at91: fix vbus_pin_active_low handling
      ARM: at91/USB host: specify and handle properly vbus_pin_active_low

Nishanth Menon (1):
      mfd: Clear twl6030 IRQ status register only once

Oleg Nesterov (1):
      cred: copy_process() should clear child->replacement_session_keyring

Pavel Shilovsky (1):
      CIFS: Fix VFS lock usage for oplocked files

Rabin Vincent (1):
      net: usb: cdc_eem: fix mtu

Rafael J. Wysocki (7):
      firmware_class: Rework usermodehelper check
      firmware_class: Split _request_firmware() into three functions, v2
      firmware_class: Do not warn that system is not ready from async loads
      PM / Hibernate: Disable usermode helpers right before freezing tasks
      PM / Sleep: Move disabling of usermode helpers to the freezer
      PM / Sleep: Mitigate race between the freezer and request_firmware()
      mmc: sdio: Use empty system suspend/resume callbacks at the bus level

Rajkumar Manoharan (1):
      ath9k: fix max noise floor threshold

Sachin Prabhu (1):
      Fix length of buffer copied in __nfs4_get_acl_uncached

Salman Qazi (1):
      sched/x86: Fix overflow in cyc2ns_offset

Sean Paul (1):
      drm/i915: Add lock on drm_helper_resume_force_mode

Simon Arlott (1):
      media: dvb-core: fix DVBFE_ALGO_HW retune bug

Stanislaw Gruszka (2):
      mac80211: fix possible tid_rx->reorder_timer use after free
      iwlegacy: do not nulify il->vif on reset

Stephen Warren (2):
      regmap: prevent division by zero in rbtree_show
      ASoC: tegra: fix i2s compilation when !CONFIG_DEBUG_FS

Steven Rostedt (1):
      tracing: Fix ent_size in trace output

Sujith Manoharan (1):
      Revert "ath9k: fix going to full-sleep on PS idle"

Takashi Iwai (1):
      ALSA: hda/realtek - Fix ADC assignment with a shared HP/Mic pin

Tetsuo Handa (1):
      TOMOYO: Fix mount flags checking order.

Wolfgang Mauerer (1):
      tracing: Fix ftrace stack trace entries

Wolfram Sang (1):
      mtd: nand: gpmi: use correct member for checking NAND_BBT_USE_FLASH

Yinghai Lu (1):
      PNPACPI: Fix device ref leaking in acpi_pnp_match

danborkmann@iogearbox.net (1):
      rose_dev: fix memcpy-bug in rose_set_mac_address


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJPiFkAAAoJEDjbvchgkmk+AtcP/jnAYeK5yLN4VaCp7VtJJVoK
AW2Xad9e8K+0b/Nl6pBL8Ks/nlhmsIE5DVK+lgbZHxv1C/DkW/gXhAxtSrJsZXBO
SEZpolqwf8y9cqGPuKQjO4y10f67spnuNysxlhahI+UKyNtC8hhz8nJCNBNUyn2h
DkqUyLDebjMLS+Fd50NFgQ65ckTiZkx+aybW4GIw5+SPy2/mTAah/V1gX3GkywX0
TkBUJjpbWSZa28qs3MwGe5A3l/RXLkMMBhhI6z7lV2Ls2gQjTnS0ITkYI3Uv9urv
ONYnqWgeX5xHrRQFy8NmnUUsIq88RXJnMAVc9oem2d/yS6+OkOAS6y8adWxhA8oV
KZPd1RGqVO/1bZg6xcS3sR/6iyKnX96LzbZdsct4r46lZ4gRbS4o2A7rwQ0n+Djd
XXlnsvogJ7T0NG5XjKBo/NTTNFsi+YBYgjrW5G1lHTNMM1sZVHjjfnxg1Q8UE8yc
DB2qP3yuSdaCdPkAVjb5YfCfex1uK59cFuAmYLGhEXpbwIuTphB4bswCc7DV+Yun
APn8wcmEe+5Zz2xZFjG1IUqe0jBwv7M+QRh9qXRh2KJyXIzjSdceH5XaM3lH2EqF
F7qOBAqqgs7vHaargM4ZMz2XFgjOXnntJcTyzpYTxLBp9si7S98pmw9LEsqC/yzI
kIroB8+dd0DjNC/R3Z/I
=EEr2
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
