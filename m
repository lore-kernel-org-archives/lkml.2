Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab2FQSat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:30:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38807 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388Ab2FQSaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:30:46 -0400
Date: Sun, 17 Jun 2012 11:30:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.4.3
Message-ID: <20120617183042.GA9125@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.3 kernel.

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

 Makefile                                      |    2=20
 arch/powerpc/kernel/module_32.c               |   11 +-
 arch/powerpc/kernel/time.c                    |   14 ++-
 arch/x86/crypto/aesni-intel_asm.S             |    6 -
 arch/x86/include/asm/uv/uv_bau.h              |    1=20
 arch/x86/kernel/cpu/mcheck/mce_amd.c          |   56 ++++++++++---
 arch/x86/platform/uv/tlb_uv.c                 |    1=20
 drivers/acpi/video.c                          |    5 -
 drivers/ata/ata_piix.c                        |   36 ++++++++
 drivers/ata/libata-core.c                     |    6 +
 drivers/bcma/driver_chipcommon_pmu.c          |    4=20
 drivers/bcma/sprom.c                          |    4=20
 drivers/char/agp/intel-agp.c                  |    1=20
 drivers/char/agp/intel-agp.h                  |    1=20
 drivers/char/hw_random/atmel-rng.c            |    7 +
 drivers/gpu/drm/gma500/psb_drv.c              |    2=20
 drivers/gpu/drm/i915/intel_ringbuffer.c       |    5 +
 drivers/gpu/drm/nouveau/nouveau_connector.c   |    8 +
 drivers/gpu/drm/radeon/evergreen_cs.c         |   49 +++++++++++-
 drivers/gpu/drm/radeon/radeon_drv.c           |    3=20
 drivers/gpu/drm/ttm/ttm_bo.c                  |   13 ---
 drivers/net/can/c_can/c_can.c                 |   16 ++-
 drivers/net/can/c_can/c_can.h                 |    1=20
 drivers/net/usb/sierra_net.c                  |   14 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c    |    2=20
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    3=20
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    1=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 +
 drivers/net/wireless/rt2x00/rt2800usb.c       |   25 ++++--
 drivers/net/wireless/rt2x00/rt2x00.h          |    3=20
 drivers/net/wireless/rt2x00/rt2x00mac.c       |    1=20
 drivers/net/wireless/rt2x00/rt2x00queue.c     |   13 +--
 fs/btrfs/inode.c                              |    5 -
 fs/ext4/balloc.c                              |    8 -
 fs/fuse/dir.c                                 |    1=20
 fs/fuse/fuse_i.h                              |    3=20
 fs/fuse/inode.c                               |   17 +++-
 include/linux/libata.h                        |    1=20
 include/linux/moduleparam.h                   |   10 +-
 init/main.c                                   |    2=20
 kernel/sched/core.c                           |    9 --
 kernel/time/timekeeping.c                     |    2=20
 lib/btree.c                                   |    4=20
 net/mac80211/iface.c                          |   12 ++
 net/mac80211/offchannel.c                     |   16 +++
 net/mac80211/sta_info.c                       |    4=20
 net/mac80211/util.c                           |    2=20
 net/wireless/util.c                           |   19 ++++
 sound/pci/hda/patch_realtek.c                 |    9 ++
 sound/soc/codecs/wm8994.c                     |  105 ++++++++++++++++-----=
-----
 50 files changed, 407 insertions(+), 141 deletions(-)

Alan Cox (2):
      gma500: don't register the ACPI video bus
      acpi_video: fix leaking PCI references

Andy Whitcroft (2):
      libata: add a host flag to ignore detected ATA devices
      ata_piix: defer disks to the Hyper-V drivers by default

AnilKumar Ch (3):
      can: c_can: fix "BUG! echo_skb is occupied!" during transmit
      can: c_can: fix an interrupt thrash issue with c_can driver
      can: c_can: fix race condition in c_can_open()

Arik Nemtsov (1):
      mac80211: fix non RCU-safe sta_list manipulation

Ben Skeggs (1):
      drm/nouveau/disp: fix dithering not being enabled on some eDP macbooks

Bj=F8rn Mork (1):
      net: sierra_net: device IDs for Aircard 320U++

Borislav Petkov (1):
      x86, MCE, AMD: Make APIC LVT thresholding interrupt optional

Chris Wilson (2):
      drm/i915: Reset last_retired_head when resetting ring
      drm/i915: Mark the ringbuffers as being in the GTT domain

Cliff Wickman (1):
      x86/uv: Fix UV2 BAU legacy mode

David Henningsson (1):
      ALSA: HDA: Pin fixup for Zotac Z68 motherboard

Dimitri Sivanich (1):
      sched: Fix the relax_domain_level boot parameter

Emmanuel Grumbach (2):
      iwlwifi: don't mess up the SCD when removing a key
      iwlwifi: disable the buggy chain extension feature in HW

Eugeni Dodonov (1):
      char/agp: add another Ironlake host bridge

Greg Kroah-Hartman (1):
      Linux 3.4.3

Jerome Glisse (1):
      drm/radeon: fix tiling and command stream checking on evergreen v3

Johannes Berg (4):
      iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP
      iwlwifi: unregister LEDs if mac80211 registration fails
      mac80211: clean up remain-on-channel on interface stop
      cfg80211: fix interface combinations check

John Stultz (1):
      timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond

Josef Bacik (1):
      Btrfs: fall back to non-inline if we don't have enough space

Mark Brown (2):
      ASoC: wm8994: Ensure all AIFnCLK events are run from the _late varian=
ts
      ASoC: wm8994: Apply volume updates with clocks enabled

Mathias Krause (1):
      crypto: aesni-intel - fix unaligned cbc decrypt for x86-32

Meenakshi Venkataraman (1):
      mac80211: fix error in station state transitions during reconfig

Paul Mackerras (1):
      powerpc/time: Sanity check of decrementer expiration is necessary

Pavel Shilovsky (1):
      fuse: fix stat call on 32 bit platforms

Peter Korsgaard (1):
      hwrng: atmel-rng - fix race condition leading to repeated bits

Roland Dreier (1):
      btree: fix tree corruption in btree_get_prev()

Rusty Russell (1):
      module_param: stop double-calling parameters.

Seth Forshee (1):
      bcma: add ext PA workaround for BCM4331 and BCM43431

Stanislaw Gruszka (1):
      rt2x00: use atomic variable for seqno

Steffen Rumler (1):
      powerpc: Fix kernel panic during kernel module load

Theodore Ts'o (1):
      ext4: fix the free blocks calculation for ext3 file systems w/ uninit=
_bg

Thomas Hellstrom (1):
      drm/ttm: Fix buffer object metadata accounting regression v2

Xose Vazquez Perez (2):
      wireless: rt2x00: rt2800usb add more devices ids
      wireless: rt2x00: rt2800usb more devices were identified


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJP3iJSAAoJEDjbvchgkmk+ZNgQALooG3PH74b+nS1mDSkwNFG5
WnaGMGKp1H9NU3OtdSjectDTkLwgCCXdFllWzbny3T6LvjXvUzOUMo4vZcAHqG9F
z2IraNHgCxlz3Rr5xx9LhvbNv9uiDuIuBeC7EX+6tGVLsQbmfdsHlsM59onSZmUr
IgVY6AomNLQc6iAKTQ4mWHcri/ThPpOZVVm6//ztRppPZMmi7iT71yR99bsRgb0D
lZ4VzC1sFc+v1u8vUlskt8CrNCPpQpd/rfPsFQI5obvFJlqis0PpZBRs+lHO5SHD
E690pGvU2o5B46BiaJx7pCH/yWMUlR9iSuRO2MHYBlz61qGGKt4c41Bdag6WKQjr
6LJ+HmdUbJFKBHYR3ew5o2o9UL6bxX6bEJc9yz4Yy/7LgcrjR+mzeRkq9qMOxAp3
cR/fs4y3Kel6o+v/4ldANURP2lv5R/oiRb/nQvDIdK9Gr0DSvp1s9U5i/8TZF0iW
a+mLJ6f/rGY4rgR0k+dm/b1ucvq4yW0MVyxGQHIC/CAGSVgS64p7dZhble7e39bK
pqgc6pTLYywZ7mmttq9717IZHbQpTpVCL9oUU3lpR2qL4nWEhu+4o0JBpO/AYu3w
FDixbcfM6b6GmXAeS+U/IU1Gqv3O9Kn1nd/U0xTnAnyHNlbx4j306NtmsJQ4WbPP
qMuMV60E+cbp5J00Wsgt
=VSRx
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
