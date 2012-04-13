Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2DMQtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:49:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47051 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2DMQtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:49:05 -0400
Date: Fri, 13 Apr 2012 09:48:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.15
Message-ID: <20120413164801.GA27991@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.15 kernel.

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

 Makefile                                           |    2=20
 arch/arm/mach-tegra/Kconfig                        |    5=20
 arch/m68k/mac/config.c                             |    3=20
 arch/x86/include/asm/timer.h                       |    8 -
 arch/x86/kernel/apic/io_apic.c                     |   40 +----
 arch/x86/kernel/kgdb.c                             |   60 +++++++
 arch/x86/kernel/tsc.c                              |    3=20
 arch/x86/net/bpf_jit_comp.c                        |    2=20
 arch/x86/pci/acpi.c                                |   10 +
 drivers/acpi/acpica/tbfadt.c                       |    8 -
 drivers/acpi/processor_thermal.c                   |   45 ++++-
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
 drivers/gpu/drm/radeon/atom.c                      |   15 +
 drivers/gpu/drm/radeon/atom.h                      |    1=20
 drivers/iommu/amd_iommu_init.c                     |   24 ++-
 drivers/mfd/twl6030-irq.c                          |   13 +
 drivers/misc/kgdbts.c                              |  160 +++++++++++++++-=
-----
 drivers/mmc/host/atmel-mci.c                       |    9 +
 drivers/mmc/host/sdhci-dove.c                      |    1=20
 drivers/mtd/devices/block2mtd.c                    |    1=20
 drivers/mtd/devices/lart.c                         |    1=20
 drivers/mtd/devices/m25p80.c                       |    1=20
 drivers/mtd/devices/sst25l.c                       |    1=20
 drivers/mtd/maps/ixp4xx.c                          |    5=20
 drivers/mtd/maps/lantiq-flash.c                    |    3=20
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |    2=20
 drivers/net/ethernet/broadcom/tg3.c                |    4=20
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   13 -
 drivers/net/ethernet/marvell/sky2.c                |    5=20
 drivers/net/ethernet/realtek/r8169.c               |    5=20
 drivers/net/usb/cdc_eem.c                          |    1=20
 drivers/net/usb/zaurus.c                           |    5=20
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2=20
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    2=20
 drivers/platform/x86/acer-wmi.c                    |    1=20
 drivers/pnp/pnpacpi/core.c                         |    7=20
 drivers/target/target_core_transport.c             |    6=20
 drivers/target/tcm_fc/tcm_fc.h                     |    1=20
 drivers/target/tcm_fc/tfc_cmd.c                    |   10 +
 drivers/target/tcm_fc/tfc_conf.c                   |   13 +
 drivers/target/tcm_fc/tfc_io.c                     |    2=20
 fs/cifs/file.c                                     |   10 +
 fs/locks.c                                         |    3=20
 fs/nfs/nfs4proc.c                                  |    2=20
 include/linux/fs.h                                 |    5=20
 include/linux/kernel.h                             |   13 +
 include/linux/kgdb.h                               |    7=20
 kernel/cred.c                                      |    2=20
 kernel/debug/debug_core.c                          |   53 +++---
 kernel/irq/migration.c                             |   10 -
 kernel/sysctl.c                                    |    8 -
 kernel/trace/trace.c                               |    4=20
 kernel/trace/trace_entries.h                       |   16 +-
 kernel/trace/trace_export.c                        |    2=20
 net/bluetooth/hci_conn.c                           |    4=20
 net/mac80211/agg-rx.c                              |    3=20
 net/rose/rose_dev.c                                |    4=20
 scripts/mod/modpost.c                              |    9 -
 scripts/mod/modpost.h                              |    1=20
 security/tomoyo/mount.c                            |   38 ++--
 sound/soc/codecs/ak4642.c                          |    2=20
 sound/soc/codecs/wm8994.c                          |    2=20
 71 files changed, 549 insertions(+), 235 deletions(-)

Alex Deucher (1):
      drm/radeon/kms: fix fans after resume

Alf H=F8gemark (1):
      mmc: sdhci-dove: Fix compile error by including module.h

Andi Kleen (1):
      ACPI: Do cpufreq clamping for throttling per package v2

Anisse Astier (1):
      drm/i915: no-lvds quirk on MSI DC500

Artem Bityutskiy (3):
      mtd: sst25l: initialize writebufsize
      mtd: block2mtd: initialize writebufsize
      mtd: lart: initialize writebufsize

Brian Norris (1):
      mtd: m25p80: set writebufsize

Chris Wilson (2):
      drm: Validate requested virtual size against allocated fb size
      drm/i915: Sanitize BIOS debugging bits from PIPECONF

Dan Williams (1):
      ioat: fix size of 'completion' for Xen

Daniel Schwierzeck (1):
      mtd: mips: lantiq: reintroduce support for cmdline partitions

Daniel Vetter (1):
      drm/i915: quirk away broken OpRegion VBT

Frank Rowand (1):
      modpost: Fix modpost license checking of vmlinux.o

Geert Uytterhoeven (1):
      m68k/mac: Add missing platform check before registering platform devi=
ces

Greg Kroah-Hartman (2):
      Revert "x86/ioapic: Add register level checks to detect bogus io-apic=
 entries"
      Linux 3.2.15

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

Jiang Liu (1):
      genirq: Adjust irq thread affinity on IRQ_SET_MASK_OK_NOCOPY return v=
alue

Joerg Roedel (1):
      iommu/amd: Make sure IOMMU interrupts are re-enabled on resume

Jonathan Nieder (2):
      x86/PCI: use host bridge _CRS info on MSI MS-7253
      x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version

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

Martin Svec (1):
      target: Fix unsupported WRITE_SAME sense payload

Matt Carlson (1):
      tg3: Fix 5717 serdes powerdown problem

Nishanth Menon (1):
      mfd: Clear twl6030 IRQ status register only once

Oleg Nesterov (1):
      cred: copy_process() should clear child->replacement_session_keyring

Pavel Shilovsky (1):
      CIFS: Fix VFS lock usage for oplocked files

Peter Hurley (1):
      Bluetooth: Fix l2cap conn failures for ssp devices

Rabin Vincent (1):
      net: usb: cdc_eem: fix mtu

Sachin Prabhu (1):
      Fix length of buffer copied in __nfs4_get_acl_uncached

Salman Qazi (1):
      sched/x86: Fix overflow in cyc2ns_offset

Sean Paul (1):
      drm/i915: Add lock on drm_helper_resume_force_mode

Stanislaw Gruszka (1):
      mac80211: fix possible tid_rx->reorder_timer use after free

Stephen Warren (1):
      ARM: tegra: remove Tegra30 errata from MACH_TEGRA_DT

Steven Rostedt (1):
      tracing: Fix ent_size in trace output

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

fran=E7ois romieu (1):
      r8169: runtime resume before shutdown.

zhuangfeiran@ict.ac.cn (1):
      x86 bpf_jit: fix a bug in emitting the 16-bit immediate operand of AND


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJPiFjBAAoJEDjbvchgkmk+iH4P+gNlma5du/VgmdtvEuNuJvVj
0zpWCm4oX4zWDKO6nLXGBiMZDLpOoyvE6MB5BTVvyt9H87oTtJx7d7YfaW95rd9c
EYudhEDWk7SHGdnvPbrhPiq3OwUOMD7uoljKo4PknqsM6zJi6aX5miZkplmkaj7N
98PgHXchpzzg0EYNER/j0tGGbTuCyotC6oiBaJbiP67nnbkrxPJXIkD8O24/xPIg
aHekZ7ducLKQ8rSL+4gHA/E5vUWKQC4K7LpTN3hA3vEc6WJqzOs5AItra/eVTHU+
nZU+5coES4auWvjdegOHN03kX7UkKW9EUa5m3QN5uWLodsd8boW0jHvywGVDhoDQ
t5dgnrWXkFuKVF/tmi+yVQIrhAKzHFWyLqR9DuPsaOR4pejrqFaco/b4jzoZf7Ud
PYVHol58ALWe4WNV3xfdkkqerA7Rz5nHVmQCFsgXN+f+Ykyu/hJ/Mzp0P+HC/+T9
bB9ZrkQUhNg96E6TCGLuTKRcqSSde9yI1LZTVx9IxIm7Utgb+0FnXjpwRK7qFI7R
A0r/RwvUWQy2FqRuH7AVYYE0W370BzvORkQ+U55dZ7tWVUpeCWTYqfO2COhaN9cJ
cgUYFjoRPOEJmubKtOdt8TL99OpUvg/Qj0LE4kEQaeXfCxvMRnz0sAS8S76lscD2
XIzN+FWDrgalup1xmY9+
=yfZf
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
