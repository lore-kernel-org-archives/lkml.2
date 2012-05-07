Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab2EGQe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:34:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55574 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2EGQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:34:24 -0400
Date: Mon, 7 May 2012 09:34:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.5
Message-ID: <20120507163421.GA26591@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.5 kernel.

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

 Makefile                                    |    2=20
 arch/arm/Kconfig                            |    9=20
 arch/arm/include/asm/tls.h                  |    4=20
 arch/arm/kernel/irq.c                       |    6=20
 arch/arm/mm/abort-ev6.S                     |   17 +
 arch/mips/ath79/dev-wmac.c                  |    2=20
 arch/powerpc/platforms/85xx/common.c        |    6=20
 arch/powerpc/platforms/85xx/mpc85xx_mds.c   |   11 -
 arch/powerpc/platforms/85xx/p1022_ds.c      |   13 -
 arch/x86/boot/Makefile                      |    3=20
 arch/x86/boot/compressed/Makefile           |    1=20
 arch/x86/boot/compressed/eboot.c            |    8=20
 arch/x86/boot/compressed/head_32.S          |   14 +
 arch/x86/boot/compressed/head_64.S          |   22 +-
 arch/x86/boot/compressed/mkpiggy.c          |   11 -
 arch/x86/boot/tools/build.c                 |   42 ++--
 arch/x86/include/asm/x86_init.h             |    1=20
 arch/x86/kernel/apic/apic.c                 |   34 ++-
 arch/x86/kernel/apic/apic_numachip.c        |    7=20
 arch/x86/kernel/cpu/amd.c                   |    7=20
 arch/x86/kernel/cpu/common.c                |    9=20
 arch/x86/kernel/i387.c                      |    1=20
 arch/x86/kernel/microcode_amd.c             |   12 -
 arch/x86/kernel/microcode_core.c            |   10 -
 arch/x86/kernel/x86_init.c                  |    1=20
 arch/x86/xen/smp.c                          |   15 +
 arch/x86/xen/xen-asm.S                      |    2=20
 drivers/ata/libata-eh.c                     |    3=20
 drivers/crypto/talitos.c                    |   20 +-
 drivers/dma/at_hdmac.c                      |    4=20
 drivers/firmware/efivars.c                  |  196 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_execbuffer.c  |    8=20
 drivers/gpu/drm/i915/i915_reg.h             |    1=20
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    8=20
 drivers/gpu/drm/i915/intel_sdvo.c           |   34 +--
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c      |    4=20
 drivers/hwmon/coretemp.c                    |    6=20
 drivers/hwmon/fam15h_power.c                |   42 ++++
 drivers/i2c/busses/i2c-pnx.c                |    3=20
 drivers/input/mouse/synaptics.c             |    3=20
 drivers/md/raid5.c                          |    4=20
 drivers/net/wireless/b43/main.c             |   10 -
 drivers/net/wireless/ipw2x00/ipw2200.c      |   13 +
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    8=20
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   16 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   11 -
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   10 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3=20
 drivers/net/wireless/iwlwifi/iwl-fh.h       |   24 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 -
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   27 ++
 drivers/net/wireless/rtlwifi/pci.c          |    1=20
 drivers/net/wireless/wl1251/main.c          |    1=20
 drivers/net/wireless/wl1251/sdio.c          |    2=20
 drivers/platform/x86/dell-laptop.c          |    1=20
 drivers/scsi/libsas/sas_expander.c          |   26 ++
 drivers/usb/class/cdc-wdm.c                 |    7=20
 drivers/usb/core/hcd-pci.c                  |    9=20
 drivers/usb/gadget/dummy_hcd.c              |    1=20
 drivers/usb/gadget/f_mass_storage.c         |    2=20
 drivers/usb/gadget/file_storage.c           |    2=20
 drivers/usb/gadget/uvc.h                    |    2=20
 drivers/usb/gadget/uvc_v4l2.c               |    2=20
 drivers/usb/host/ehci-pci.c                 |    8=20
 drivers/usb/host/ehci-tegra.c               |    1=20
 fs/autofs4/autofs_i.h                       |   12 +
 fs/autofs4/dev-ioctl.c                      |    3=20
 fs/autofs4/inode.c                          |    4=20
 fs/autofs4/waitq.c                          |   20 --
 fs/exec.c                                   |    3=20
 fs/hfsplus/catalog.c                        |    4=20
 fs/hfsplus/dir.c                            |   11 +
 fs/nfs/nfs4proc.c                           |   23 ++
 fs/nfs/read.c                               |    2=20
 fs/nfs/super.c                              |    8=20
 fs/nfs/write.c                              |    2=20
 fs/pipe.c                                   |   31 ++-
 include/linux/efi.h                         |   13 +
 include/linux/pipe_fs_i.h                   |    1=20
 include/linux/usb/hcd.h                     |    2=20
 kernel/exit.c                               |   19 -
 kernel/power/swap.c                         |   28 ++
 kernel/sched/core.c                         |   75 ++++---
 kernel/signal.c                             |    9=20
 kernel/trace/trace_output.c                 |    5=20
 net/mac80211/tx.c                           |    3=20
 net/wireless/nl80211.c                      |   29 +-
 sound/pci/hda/patch_realtek.c               |    1=20
 sound/soc/codecs/wm8994.c                   |  276 ++++++++++++++++++++++-=
-----
 sound/soc/soc-dapm.c                        |    2=20
 tools/include/tools/be_byteshift.h          |   70 +++++++
 tools/include/tools/le_byteshift.h          |   70 +++++++
 93 files changed, 1176 insertions(+), 355 deletions(-)

Alan Stern (2):
      USB: EHCI: fix crash during suspend on ASUS computers
      USB: gadget: storage gadgets send wrong error code for unknown comman=
ds

Alex Deucher (1):
      drm/radeon/kms: need to set up ss on DP bridges as well

Andre Przywara (1):
      hwmon: fam15h_power: fix bogus values with current BIOSes

Andreas Herrmann (3):
      x86, microcode: Fix sysfs warning during module unload on unsupported=
 CPUs
      x86, microcode: Ensure that module is only loaded on supported AMD CP=
Us
      x86/platform: Remove incorrect error message in x86_default_fixup_cpu=
_id()

Benjamin Herrenschmidt (1):
      Input: synaptics - fix regression with "image sensor" trackpads

Bojan Smojver (1):
      PM / Hibernate: fix the number of pages used for hibernate/thaw buffe=
ring

Bryan O'Donoghue (1):
      x86, apic: APIC code touches invalid MSR on P5 class machines

Dan Carpenter (1):
      x86, efi: Fix pointer math issue in handle_ramdisks()

Dan Williams (1):
      SCSI: libsas: fix false positive 'device attached' conditions

Daniel Vetter (1):
      drm/i915: handle input/output sdvo timings separately in mode_set

Dave Airlie (1):
      nouveau: initialise has_optimus variable.

David Henningsson (1):
      ALSA: HDA: Add external mic quirk for Asus Zenbook UX31E

David Vrabel (1):
      xen: correctly check for pending events when restoring irq flags

Felipe Balbi (1):
      usb: gadget: dummy: do not call pullup() on udc_stop()

Felix Fietkau (1):
      mac80211: fix AP mode EAP tx for VLAN stations

Fred Isaman (2):
      NFS: put open context on error in nfs_pagein_multi
      NFS: put open context on error in nfs_flush_multi

Gabor Juhos (1):
      MIPS: ath79: fix AR933X WMAC reset code

Grazvydas Ignotas (2):
      wl1251: fix crash on remove due to premature kfree
      wl1251: fix crash on remove due to leftover work item

Greg Kroah-Hartman (2):
      hfsplus: Fix potential buffer overflows
      Linux 3.3.5

Guenter Roeck (2):
      hwmon: (fam15h_power) Fix pci_device_id array
      hwmon: (coretemp) Increase CPU core limit

H. Peter Anvin (1):
      x86, boot: Correct CFLAGS for hostprogs

Horia Geanta (1):
      crypto: talitos - properly lock access to global talitos registers

Jan Kara (1):
      nfs: Enclose hostname in brackets when needed in nfs_do_root_mount

Johannes Berg (2):
      nl80211: ensure interface is up in various APIs
      iwlwifi: fix hardware queue programming

Kenneth Graunke (1):
      drm/i915: Set the Stencil Cache eviction policy to non-LRA mode.

Kirill A. Shutemov (1):
      hwmon: (coretemp) fix oops on cpu unplug

Konrad Rzeszutek Wilk (1):
      xen/smp: Fix crash when booting with ACPI hotplug CPUs.

Larry Finger (1):
      rtlwifi: Fix oops on unload

Laurent Pinchart (1):
      usb gadget: uvc: uvc_request_data::length field must be signed

Lin Ming (1):
      libata: skip old error history when counting probe trials

Linus Torvalds (3):
      Revert "autofs: work around unhappy compat problem on x86-64"
      pipes: add a "packetized pipe" mode for writing
      autofs: make the autofsv5 packet file descriptor use a packetized pipe

Mark Brown (2):
      ASoC: dapm: Ensure power gets managed for line widgets
      ASoC: wm8994: Improve sequencing of AIF channel enables

Martin Nyhus (1):
      dell-laptop: Terminate quirks list properly

Matt Fleming (5):
      tools/include: Add byteshift headers for endian access
      x86, mkpiggy: Don't open code put_unaligned_le32()
      x86, boot: Restrict CFLAGS for hostprogs
      x86, efi: Fix endian issues and unaligned accesses
      x86, efi: Add dedicated EFI stub entry point

Matthew Garrett (3):
      efi: Add new variable attributes
      efi: Validate UEFI boot variables
      efivars: Improve variable validation

Meenakshi Venkataraman (1):
      iwlwifi: use correct released ucode version

Nicolas Ferre (1):
      dmaengine: at_hdmac: remove clear-on-read in atc_dostart()

Oleg Nesterov (3):
      i387: ptrace breaks the lazy-fpu-restore logic
      exit_signal: simplify the "we have changed execution domain" logic
      exit_signal: fix the "parent has changed security domain" logic

Oliver Neukum (1):
      USB: cdc-wdm: fix race leading leading to memory corruption

Peter Zijlstra (1):
      sched: Fix nohz load accounting -- again!

Roland Stigge (1):
      i2c: pnx: Disable clk in suspend

Seth Forshee (1):
      b43: only reload config after successful initialization

Stanislav Yakovlev (1):
      ipw2200: Fix race condition in the command completion acknowledge

Stanislaw Gruszka (1):
      iwlwifi: do not nulify ctx->vif on reset

Stephen Warren (1):
      USB: ehci-tegra: remove redundant gpio_set_value

Steven Rostedt (1):
      tracing: Fix stacktrace of latency tracers (irqsoff and friends)

Thomas Jackson (1):
      SCSI: libsas: fix sas_find_bcast_phy() in the presence of 'vacant' ph=
ys

Timur Tabi (1):
      powerpc/85xx: don't call of_platform_bus_probe() twice

Trond Myklebust (2):
      NFSv4: Ensure that the LOCK code sets exception->inode
      NFSv4: Ensure that we check lock exclusive/shared type against open m=
odes

Wey-Yi Guy (1):
      iwlwifi: use 6000G2B for 6030 device series

Will Deacon (3):
      ARM: 7396/1: errata: only handle ARM erratum #326103 on affected cores
      ARM: 7403/1: tls: remove covert channel via TPIDRURW
      ARM: 7406/1: hotplug: copy the affinity mask when forcefully migratin=
g IRQs

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()

he, bo (1):
      sched: Fix OOPS when build_sched_domains() percpu allocation fails

majianpeng (1):
      md/raid5: Fix a bug about judging if the operation is syncing or repl=
acing


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPp/mNAAoJEDjbvchgkmk+awcQALXJIHl1vy2oSJULhN8YRR3M
uwabe2HrAwbU6IaiiaSfMPq7fZY3O5Y1/U55V+I08nMn6UYlVrXj1xBvuKoqXllM
nsTfkIKBhFnRTtqg37d4y+HjgnNDptabx/F2yheSlRp+OPOGTgR1bUhXdbnlExuV
TMvuRalwK+SqxAsaUebQNFKWPpO+qJY1LF3gX9ISSrN7VZayvOJ/5aBQzxwFLAKk
Uje3xYICYqJ8GR6usjucUIKLz/+/nj3yy6I7+ypixVA756QZOli+ZvG5IWDJfagy
heAIv3kg8UszflH9ww385hbKiA6XIBNWmviWq1aoClR5Y7VhYNPnim+gJdl2aEIb
nXbTurIfsYdam4Ma0iGwLT656ejyTaH/03M5hz64MqJKE7b6mm4q9hRK+LJFfU8u
b5ohZeM9hgmjsB17WdP3p8MuRraCq1i9CIhkEtQaJWeeTeK8lRXq/dWT2GM0f2wb
iavcarcYSSkiMKTdndFelDB5TGUOf2EhZdqfWNTVJnseYEik70r+3RnEC8Cj/jSw
2cWxe5pbzx0jvTA3MrcP9kmzzp+ycj2BR7BDaY6nVxdk305hHC7l9KzH+rzid77F
CG4aUYFfbfojIUDkOgeW8u0fbcKFYpxQW34oUUZ78ZaBPXdGz1SYFXVigPs6QkZ/
nFUpzF/bejQChxO7kdv3
=yRgB
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
