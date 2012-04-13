Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2DMQrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:47:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51777 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2DMQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:47:44 -0400
Date: Fri, 13 Apr 2012 09:46:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.28
Message-ID: <20120413164639.GA27939@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.28 kernel.

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

 Makefile                             |    2=20
 arch/m68k/mac/config.c               |    3=20
 arch/x86/include/asm/timer.h         |    8 -
 arch/x86/kernel/amd_iommu_init.c     |   24 +++--
 arch/x86/kernel/apic/io_apic.c       |   40 +-------
 arch/x86/kernel/kgdb.c               |   60 +++++++++++++
 arch/x86/kernel/tsc.c                |    3=20
 arch/x86/net/bpf_jit_comp.c          |    2=20
 arch/x86/pci/acpi.c                  |   10 ++
 drivers/acpi/acpica/tbfadt.c         |    8 -
 drivers/acpi/processor_thermal.c     |   45 ++++++++-
 drivers/gpu/drm/drm_fb_helper.c      |    8 +
 drivers/gpu/drm/i915/i915_drv.c      |    2=20
 drivers/gpu/drm/i915/i915_reg.h      |    1=20
 drivers/gpu/drm/i915/intel_bios.c    |   23 ++++-
 drivers/gpu/drm/i915/intel_display.c |    6 +
 drivers/gpu/drm/i915/intel_lvds.c    |    8 +
 drivers/gpu/drm/radeon/atom.c        |   15 +++
 drivers/gpu/drm/radeon/atom.h        |    1=20
 drivers/mfd/twl6030-irq.c            |   13 ++
 drivers/misc/kgdbts.c                |  160 +++++++++++++++++++++++++-----=
-----
 drivers/mmc/host/atmel-mci.c         |    9 +
 drivers/mtd/devices/block2mtd.c      |    1=20
 drivers/mtd/devices/lart.c           |    1=20
 drivers/mtd/devices/m25p80.c         |    1=20
 drivers/mtd/devices/sst25l.c         |    1=20
 drivers/net/usb/cdc_eem.c            |    1=20
 drivers/net/usb/zaurus.c             |    5 +
 drivers/platform/x86/acer-wmi.c      |    1=20
 drivers/pnp/pnpacpi/core.c           |    7 +
 include/linux/kernel.h               |   13 ++
 include/linux/kgdb.h                 |    7 -
 kernel/cred.c                        |    2=20
 kernel/debug/debug_core.c            |   53 +++++------
 kernel/irq/migration.c               |   10 +-
 kernel/sysctl.c                      |    8 -
 kernel/trace/trace_entries.h         |   16 ++-
 kernel/trace/trace_export.c          |    2=20
 net/bluetooth/hci_conn.c             |    4=20
 net/mac80211/agg-rx.c                |    3=20
 net/rose/rose_dev.c                  |    4=20
 scripts/mod/modpost.c                |   36 +++++++
 scripts/mod/modpost.h                |    1=20
 security/tomoyo/mount.c              |   38 ++++----
 sound/soc/codecs/ak4642.c            |    2=20
 45 files changed, 486 insertions(+), 182 deletions(-)

Alessio Igor Bogani (1):
      modpost: Fix modpost's license checking V3

Alex Deucher (1):
      drm/radeon/kms: fix fans after resume

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
      Linux 3.0.28

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

Kuninori Morimoto (1):
      ASoC: ak4642: fixup: mute needs +1 step

Lee, Chun-Yi (1):
      acer-wmi: No wifi rfkill on Sony machines

Ludovic Desroches (1):
      mmc: atmel-mci: correct data timeout computation

Nishanth Menon (1):
      mfd: Clear twl6030 IRQ status register only once

Oleg Nesterov (1):
      cred: copy_process() should clear child->replacement_session_keyring

Peter Hurley (1):
      Bluetooth: Fix l2cap conn failures for ssp devices

Rabin Vincent (1):
      net: usb: cdc_eem: fix mtu

Salman Qazi (1):
      sched/x86: Fix overflow in cyc2ns_offset

Sean Paul (1):
      drm/i915: Add lock on drm_helper_resume_force_mode

Stanislaw Gruszka (1):
      mac80211: fix possible tid_rx->reorder_timer use after free

Tetsuo Handa (1):
      TOMOYO: Fix mount flags checking order.

Wolfgang Mauerer (1):
      tracing: Fix ftrace stack trace entries

Yinghai Lu (1):
      PNPACPI: Fix device ref leaking in acpi_pnp_match

danborkmann@iogearbox.net (1):
      rose_dev: fix memcpy-bug in rose_set_mac_address

zhuangfeiran@ict.ac.cn (1):
      x86 bpf_jit: fix a bug in emitting the 16-bit immediate operand of AND


--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJPiFhvAAoJEDjbvchgkmk+OScP/i/ACORdj7N0wKVAo1qInN0j
/gJ++qJbA49Uvg9qZxZ4foDcC9PvrK0ouvDs6iBcybR7KzsguCT7n8ppxajWdRTD
calko0wOHOnIokWiUFn7pzUj/wH++3jUa0aenHz2n1a0LaiJnonrkZaDM+GYHkTy
y7S1ggk45emR8smsB9GHdlAXGCVaqvXSBCgXsRQCO2ccpZ2LpVMGX571iZFdCUWL
YQXRoxZB+Exs8HtuEATGBS/eMc7OkKmlcrkPhSKOqcHgGwRSQN8rlGLM7eSFCMxn
BNTn5h18H44bn3lHLlqMAXgqEIv8eO0G4wt2N2Q+/HcDgax3ciVNkKOELaHNNQiq
BMrFA9VdeIoprslmDz3NYOvAU3xtCa3Kmi6wKz1BHQ5cul6YgTU22ksaMyKheWig
xcu5E5IwiDN7epQEdrG8Ti3YhgE6xJZmnpiyU62cUtZ0Gq9VSQ0Q+pX8xbvHfmYt
QV9JOP/MB1zwWlQy4UqMJvVEFtgYVpT+HlMbVdlzgqT3CHOdcHN3ix/ZvDuxioKP
Os6gneT5Bs0IvhBefYID11eFI2JSGFWuIBrjm334MHg+Qp1wO0gs7zBGQOIV6KW8
f7uNF5kxEn2aTtAs0tVYD9uRDq83I0qLRlMQMAYZFAjj6DdTRxfNa8oRtt/fH0e7
CJe9uYSDCX1Qh8TAKg/i
=aEQv
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
