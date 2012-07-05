Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2GEBNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:13:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51164 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab2GEBN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:13:29 -0400
Message-ID: <1341450797.4852.180.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.22
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Thu, 05 Jul 2012 02:13:17 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-w+5oMjAgXs6yMluSEs36"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w+5oMjAgXs6yMluSEs36
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.22 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/stable_kernel_rules.txt              |    6 ++
 Makefile                                           |    2 +-
 arch/arm/plat-samsung/include/plat/map-s3c.h       |    2 +-
 .../arm/plat-samsung/include/plat/watchdog-reset.h |    2 +-
 arch/x86/include/asm/cpufeature.h                  |    2 +-
 arch/x86/include/asm/pgtable-3level.h              |   54 ++++++++++++++++
 arch/x86/kernel/cpu/scattered.c                    |    2 +-
 drivers/acpi/acpi_pad.c                            |    7 ++-
 drivers/base/power/main.c                          |    6 +-
 drivers/char/hw_random/atmel-rng.c                 |    2 +-
 drivers/edac/i7core_edac.c                         |   15 ++---
 drivers/edac/sb_edac.c                             |   10 ++-
 drivers/gpu/drm/drm_edid.c                         |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    4 ++
 drivers/gpu/drm/i915/i915_irq.c                    |   57 +++++++++-------=
-
 drivers/gpu/drm/i915/i915_suspend.c                |    5 +-
 drivers/gpu/drm/i915/intel_display.c               |   65 ++++++++++++++--=
----
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   14 +----
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    2 +-
 drivers/hwmon/applesmc.c                           |    4 +-
 drivers/hwmon/coretemp.c                           |    2 +-
 drivers/md/dm-thin.c                               |    9 ++-
 drivers/media/dvb/siano/smsusb.c                   |    2 +
 drivers/media/video/gspca/gspca.c                  |    4 +-
 drivers/net/can/c_can/c_can.c                      |    4 +-
 drivers/net/can/flexcan.c                          |    4 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |    3 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    8 ---
 drivers/net/wireless/ath/ath9k/hw.c                |   14 ++++-
 drivers/net/wireless/ath/ath9k/main.c              |   18 +++---
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |    6 ++
 drivers/net/xen-netfront.c                         |    8 +--
 drivers/oprofile/oprofile_perf.c                   |    2 +-
 drivers/staging/iio/adc/ad7606_core.c              |    1 +
 drivers/staging/rtl8712/usb_intf.c                 |    2 +
 drivers/staging/rts_pstor/rtsx_transport.c         |   11 ++--
 drivers/usb/serial/cp210x.c                        |   11 ++++
 drivers/usb/serial/option.c                        |    8 +++
 fs/nilfs2/gcinode.c                                |    2 +
 fs/nilfs2/segment.c                                |    2 +
 include/asm-generic/pgtable.h                      |   32 +++++++++-
 net/batman-adv/routing.c                           |    2 +
 net/batman-adv/translation-table.c                 |    8 +--
 net/wireless/reg.c                                 |    2 +-
 sound/pci/hda/patch_realtek.c                      |    1 +
 tools/hv/hv_kvp_daemon.c                           |   10 ++-
 47 files changed, 298 insertions(+), 143 deletions(-)

Andrea Arcangeli (2):
      mm: pmd_read_atomic: fix 32bit PAE pmd walk vs pmd_populate SMP race =
condition
      thp: avoid atomic64_read in pmd_read_atomic for 32bit PAE

Antonio Quartulli (1):
      batman-adv: fix skb->data assignment

Ben Hutchings (1):
      Linux 3.2.22

Ben Skeggs (1):
      drm/nouveau/fbcon: using nv_two_heads is not a good idea

Chen Gong (1):
      edac: avoid mce decoding crash after edac driver unloaded

Chris Boot (2):
      e1000e: Disable ASPM L1 on 82574
      e1000e: Remove special case for 82573/82574 ASPM L1 disablement

Chris Wilson (3):
      drm/i915: Finish any pending operations on the framebuffer before dis=
abling
      drm/i915: Remove use of the autoreported ringbuffer HEAD position
      drm/i915: Refactor the deferred PM_IIR handling into a single functio=
n

Craig Shelley (1):
      USB: CP210x Add 10 Device IDs

Dan Carpenter (1):
      can: c_can: precedence error in c_can_chip_config()

Daniel Vetter (2):
      drm/edid: don't return stack garbage from supports_rb
      drm/i915: rip out the PM_IIR WARN

David Henningsson (1):
      ALSA: hda - Add Realtek ALC280 codec support

Dmitry Shmygov (1):
      USB: option: add id for Cellient MEN-200

Eliad Peller (1):
      cfg80211: fix potential deadlock in regulatory

Eric Anholt (1):
      drm/i915: Do the fallback non-IRQ wait in ring throttle, too.

Felix Fietkau (1):
      ath9k: fix a tx rate duration calculation bug

Forest Bond (1):
      USB: option: Add USB ID for Novatel Ovation MC551

H. Peter Anvin (1):
      x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM

Hans de Goede (1):
      gspca-core: Fix buffers staying in queued state after a stream_off

Henrik Rydberg (1):
      hwmon: (applesmc) Limit key length in warning messages

Hui Wang (1):
      can: flexcan: use be32_to_cpup to handle the value of dt entry

Ian Campbell (1):
      xen/netfront: teardown the device before unregistering it.

Johannes Berg (1):
      iwlwifi: remove log_event debugfs file debugging is disabled

Jonghwan Choi (1):
      ARM: SAMSUNG: Should check for IS_ERR(clk) instead of NULL

Jose Miguel Goncalves (1):
      ARM: SAMSUNG: Fix for S3C2412 EBI memory mapping

Lars-Peter Clausen (1):
      staging:iio:ad7606: Re-add missing scale attribute

Lubomir Schmidt (1):
      staging: r8712u: Add new USB IDs

Mandeep Singh Baines (1):
      PM / Sleep: Prevent waiting forever on asynchronous suspend after abo=
rt

Marek Lindner (1):
      batman-adv: only drop packets of known wifi clients

Mel Gorman (1):
      stable: Allow merging of backports for serious user-visible performan=
ce issues

Michael Krufky (1):
      smsusb: add autodetection support for USB ID 2040:f5a0

Mike Snitzer (1):
      dm thin: reinstate missing mempool_free in cell_release_singleton

Mohammed Shafi Shajakhan (3):
      ath9k: Fix a WARNING on suspend/resume with IBSS
      ath9k: Fix softlockup in AR9485
      ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc

Olaf Hering (1):
      Tools: hv: verify origin of netlink connector message

Peter Korsgaard (1):
      hwrng: atmel-rng - fix data valid check

Ryusuke Konishi (1):
      nilfs2: ensure proper cache clearing for gc-inodes

Stuart Hayes (1):
      acpi_pad: fix power_saving thread deadlock

Takashi Iwai (1):
      drm/i915: Fix eDP blank screen after S3 resume on HP desktops

Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static arr=
ay

wwang (1):
      staging:rts_pstor:Fix possible panic by NULL pointer dereference


--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-w+5oMjAgXs6yMluSEs36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/TqLee/yOyVhhEJAQqcXQ/+No0gvOALw4eIkccfpqkYVl3pvSqBUZza
ZTX9JQqS5hwx47cXvu4Isl2XleorH8JxyB4+f7PoigGkN3OjHlg8lIXjaHJ5AAEs
gpbXyGzIRjE1+2251yETkR7SnAuV5k24cj9V8W13B+2fnFb8UF6gP+L9P/mMBixL
ydDAsG5WXJdtRFJmNMofcQsLsMXypL+EMpLeg9Hp8+kGv37GhiA22uNvRKxZiv59
azatq7ISR3UUwFn2y3JVbZ3tjmYl0ZqRO3gL/BoHmR6M+OFZmSmyyhqbTjAM4UuE
3vyilxQFQTPtYBIDzxyC+V9iXhfPtCSaBkmcJUwVLDghimSq4ICbKHt1/sSF5JIu
eq0LvZjmLE97TT8ROZNlBZp+/I7UN8bY0EGzTZDMmcku26JDgFy5LQRvopS4ZgdU
VO8/8Q2OJSL/95lifKFUH1g3PoPXq61jpHs2/KULhIO9zQQZO4QQ3aRsQf8FPQIb
WzM0nD2h7a0vJ2sQFbRklfCreCdIhR9p6QKxDa4w7Rjl5bbt540Fa/tVmFxOtZ7w
SaHN3iV937nkktAv5bAAfd5Lspw1F0vNsLlZiMZZyZT677ar0/Rb7Qixv88EFC5N
jF+MFoxNUb6lcJkCIJTzyFgfOcAwXhesejIb2rBUwlqPsrZ3F7y8pnuvN+Q5CN3b
v1j/UMaK2D0=
=PbPq
-----END PGP SIGNATURE-----

--=-w+5oMjAgXs6yMluSEs36--
