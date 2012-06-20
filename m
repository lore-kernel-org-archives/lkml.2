Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2FTBAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:00:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44536 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097Ab2FTBAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:00:43 -0400
Message-ID: <1340154035.6871.87.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.21
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 20 Jun 2012 02:00:35 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aBXB65louq2ks0djlQ9R"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aBXB65louq2ks0djlQ9R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.21 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                      |    2 +-
 arch/arm/mach-imx/hotplug.c                   |   42 +++++++++-
 arch/arm/mach-imx/mach-mx21ads.c              |    2 +-
 arch/arm/mach-mx5/crm_regs.h                  |    2 +-
 arch/powerpc/kernel/module_32.c               |   11 ++-
 arch/x86/crypto/aesni-intel_asm.S             |    6 +-
 arch/x86/include/asm/uv/uv_bau.h              |    1 -
 arch/x86/kernel/cpu/amd.c                     |   18 +++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c          |   55 ++++++++++---
 arch/x86/platform/uv/tlb_uv.c                 |    1 -
 arch/x86/xen/enlighten.c                      |    8 ++
 drivers/char/agp/intel-agp.c                  |    1 +
 drivers/char/agp/intel-agp.h                  |    1 +
 drivers/char/hw_random/atmel-rng.c            |    7 ++
 drivers/gpu/drm/i915/i915_drv.c               |    6 +-
 drivers/gpu/drm/i915/i915_drv.h               |    3 +
 drivers/gpu/drm/i915/i915_reg.h               |    8 ++
 drivers/gpu/drm/i915/intel_display.c          |   69 ++++++++++++----
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   20 ++++-
 drivers/gpu/drm/nouveau/nouveau_connector.c   |   55 +++++++++++++
 drivers/gpu/drm/radeon/evergreen.c            |    3 +
 drivers/gpu/drm/radeon/evergreend.h           |    1 +
 drivers/gpu/drm/radeon/r600.c                 |    1 +
 drivers/gpu/drm/radeon/r600d.h                |    1 +
 drivers/gpu/drm/radeon/rv770.c                |    5 +-
 drivers/gpu/drm/radeon/rv770d.h               |    3 +
 drivers/hwmon/fam15h_power.c                  |    8 +-
 drivers/net/can/c_can/c_can.c                 |   16 ++--
 drivers/net/can/c_can/c_can.h                 |    1 +
 drivers/net/usb/sierra_net.c                  |   14 +++-
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   22 +++++-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 +
 drivers/net/wireless/iwlwifi/iwl-prph.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 ++
 drivers/net/wireless/rt2x00/rt2x00.h          |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |    1 -
 drivers/net/wireless/rt2x00/rt2x00queue.c     |   13 ++-
 drivers/pci/pci.c                             |    5 ++
 drivers/pci/quirks.c                          |   26 ++++++
 drivers/scsi/mpt2sas/mpt2sas_base.c           |    2 +-
 drivers/target/target_core_alua.c             |    8 +-
 drivers/usb/class/cdc-acm.c                   |    8 ++
 drivers/usb/class/cdc-wdm.c                   |   16 ++++
 drivers/usb/core/hcd-pci.c                    |    9 ---
 drivers/usb/core/message.c                    |    3 +-
 drivers/usb/host/ehci-hcd.c                   |    3 +
 drivers/usb/host/ehci-pci.c                   |    8 --
 drivers/usb/host/xhci-mem.c                   |   74 ++++++-----------
 drivers/usb/host/xhci.c                       |    8 +-
 drivers/usb/musb/musb_gadget.c                |    1 +
 drivers/usb/serial/cp210x.c                   |    1 +
 drivers/usb/serial/ftdi_sio.c                 |    1 +
 drivers/usb/serial/ftdi_sio_ids.h             |    1 +
 drivers/usb/serial/mct_u232.c                 |   13 +--
 drivers/usb/serial/option.c                   |   92 ++++++++++-----------=
-
 drivers/usb/serial/qcserial.c                 |    6 ++
 drivers/usb/serial/sierra.c                   |    4 +
 drivers/usb/serial/usb-serial.c               |    6 +-
 fs/fuse/dir.c                                 |    1 +
 fs/fuse/fuse_i.h                              |    3 +
 fs/fuse/inode.c                               |   17 +++-
 fs/nfs/nfs4proc.c                             |    1 +
 include/linux/pci.h                           |    2 +
 include/linux/swapops.h                       |    8 +-
 include/linux/usb/hcd.h                       |    2 -
 kernel/sched.c                                |    9 +--
 mm/swapfile.c                                 |   12 +--
 net/mac80211/iface.c                          |   12 +++
 net/mac80211/offchannel.c                     |   16 ++++
 net/sunrpc/svc.c                              |    3 +-
 net/wireless/util.c                           |   19 ++++-
 sound/pci/hda/hda_codec.h                     |    1 +
 sound/pci/hda/hda_local.h                     |    2 +
 sound/pci/hda/patch_realtek.c                 |   52 ++++++++++--
 sound/soc/codecs/wm8994.c                     |  105 ++++++++++++++++-----=
----
 76 files changed, 707 insertions(+), 274 deletions(-)

Alan Cox (1):
      USB: mct_u232: Fix incorrect TIOCMSET return

Alan Stern (1):
      USB: add NO_D3_DURING_SLEEP flag and revert 151b61284776be2

Alex Deucher (1):
      drm/radeon: add some additional 6xx/7xx/EG register init

Andiry Xu (1):
      xHCI: Increase the timeout for controller save/restore state operatio=
n

Andre Przywara (2):
      hwmon: (fam15h_power) Increase output resolution
      xen/setup: filter APERFMPERF cpuid feature out

Andreas Herrmann (1):
      x86/amd: Re-enable CPU topology extensions in case BIOS has disabled =
it

Andrew Bird (1):
      USB: option: Updated Huawei K4605 has better id

AnilKumar Ch (3):
      can: c_can: fix "BUG! echo_skb is occupied!" during transmit
      can: c_can: fix an interrupt thrash issue with c_can driver
      can: c_can: fix race condition in c_can_open()

Ben Hutchings (1):
      Linux 3.2.21

Ben Skeggs (3):
      drm/nouveau: determine a value for display_info.bpc if edid doesn't
      drm/nouveau: default to 8bpc for non-LVDS panels if EDID isn't useful
      drm/nouveau/disp: fix dithering not being enabled on some eDP macbook=
s

Bj=C3=B8rn Mork (4):
      net: sierra_net: device IDs for Aircard 320U++
      usb: cdc-wdm: Add device-id for Huawei 3G/LTE modems
      USB: qcserial: Add Sierra Wireless device IDs
      USB: serial: Enforce USB driver and USB serial driver match

Borislav Petkov (1):
      x86, MCE, AMD: Make APIC LVT thresholding interrupt optional

Chris Wilson (2):
      drm/i915: Mark the ringbuffers as being in the GTT domain
      drm/i915: Unpin the flip target if we fail to queue the flip

Cliff Wickman (1):
      x86/uv: Fix UV2 BAU legacy mode

Daniel Mack (1):
      USB: fix gathering of interface associations

Daniel Vetter (2):
      drm/i915: hold forcewake around ring hw init
      drm/i915: fix up ivb plane 3 pageflips

David Henningsson (1):
      ALSA: HDA: Pin fixup for Zotac Z68 motherboard

Dimitri Sivanich (1):
      sched: Fix the relax_domain_level boot parameter

Emmanuel Grumbach (2):
      iwlwifi: don't mess up the SCD when removing a key
      iwlwifi: disable the buggy chain extension feature in HW

Eugeni Dodonov (1):
      char/agp: add another Ironlake host bridge

Evan McNabb (1):
      USB: ftdi-sio: Add support for RT Systems USB-RTS01 serial adapter

Geoff Levand (1):
      usb: PS3 EHCI QH read work-around

Grazvydas Ignotas (1):
      usb: musb_gadget: fix crash caused by dangling pointer

Hugh Dickins (1):
      swap: fix shmem swapping when more than 8 areas

Jaccon Bastiaansen (1):
      ARM i.MX imx21ads: Fix overlapping static i/o mappings

Jaroslav Kysela (1):
      ALSA: hda - add support for Uniwill ECS M31EI notebook

Johan Hovold (2):
      USB: option: fix port-data abuse
      USB: option: fix memory leak

Johannes Berg (4):
      mac80211: clean up remain-on-channel on interface stop
      iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP
      iwlwifi: unregister LEDs if mac80211 registration fails
      cfg80211: fix interface combinations check

Mark Brown (2):
      ASoC: wm8994: Ensure all AIFnCLK events are run from the _late varian=
ts
      ASoC: wm8994: Apply volume updates with clocks enabled

Mathias Krause (1):
      crypto: aesni-intel - fix unaligned cbc decrypt for x86-32

Meenakshi Venkataraman (1):
      iwlwifi: use correct supported firmware for 6035 and 6000g2

Mikko Tuumanen (1):
      USB: serial: cp210x: add Optris MS Pro usb id

Otto Meta (1):
      usb: cdc-acm: fix devices not unthrottled on open

Pavel Shilovsky (1):
      fuse: fix stat call on 32 bit platforms

Peter Korsgaard (1):
      hwrng: atmel-rng - fix race condition leading to repeated bits

Ricardo Martins (1):
      USB: fix PS3 EHCI systems

Roland Dreier (1):
      target: Return error to initiator if SET TARGET PORT GROUPS emulation=
 fails

Sascha Hauer (1):
      ARM i.MX53: Fix PLL4 base address

Shawn Guo (1):
      ARM: imx6: exit coherency when shutting down a cpu

Stanislaw Gruszka (1):
      rt2x00: use atomic variable for seqno

Steffen Rumler (1):
      powerpc: Fix kernel panic during kernel module load

Takashi Iwai (5):
      ALSA: hda - Add codec->no_jack_detect flag
      ALSA: hda - Suppress auto-mute feature on some machines with ALC861
      ALSA: hda - Add another jack-detection suppression for ASUS ALC892
      xhci: Fix invalid loop check in xhci_free_tt_info()
      xhci: Don't free endpoints in xhci_mem_cleanup()

Tom Cassidy (1):
      USB: serial: sierra: Add support for Sierra Wireless AirCard 320U mod=
em

Trond Myklebust (2):
      NFSv4.1: Fix a request leak on the back channel
      NFSv4: Fix unnecessary delegation returns in nfs4_do_open

nagalakshmi.nandigama@lsi.com (1):
      mpt2sas: Fix unsafe using smp_processor_id() in preemptible

=E8=AF=B4=E4=B8=8D=E5=BE=97 (1):
      USB: option: add more YUGA device ids


--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-aBXB65louq2ks0djlQ9R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+Egs+e/yOyVhhEJAQotlQ//TwMC2LwkKcyOkyaG+loi+S2/+w/Wj2+u
cUqMNemxibtEqL1Ctn/M6uzBvj2y4t9A2oDLfJnOC9JS4BtI4aRUJVk2LE/jrpHK
/h4+LQ78CtUrXimjpTx7btzpnCHNH/oozcanCvWvT0iME902YXZEcVs+sAqBeJxu
DfRYmxu79jGRl0rKIoV6kJu2+OXumsTJQuxDNk5RoMkEO1E/cwL84HpJJ0iIduIF
fVgiKolol26wgWOJX91nUgKU73qpGUSHsobLtYu4baerWXwJOdfbz/eP8r5LWZLU
TRT0V10XWGcdshQOhsSQdyvjRyBBiJ6bwGb4xSvlyZ/cgadeY9Z+wFCOib1Yvqc5
bHDYUZtln6SBo5c2uzzt6F8Z5zIjEc/6FcJ4biDUJXmcCh55dWzuQJTVjThelZkv
CdvrzZZMYpUI+7DeFI8Dg5eqoE07cCeaBeG2uP1AsQiHrH1QZAwTtavDcIkUnbsx
l++P9FN9Tw4IsY3XsVT4RuSFLXb2tXJDT3aL47yp7TZBTsIzexF5WG6cHAXi3I7N
xmt0j7c0JS9THOzCKPPW4rC6DDx3su0FEbKy9CM6AOXnYmnJhqih3xdD6WFVOK+Y
Lk0WfhduFHXFfsHaKQHdeR4d68mhdV2lxOAPjOpUDPj7zYoIS5gAkKkxg18Q+8Av
ovaW87n3u9Y=
=zh+p
-----END PGP SIGNATURE-----

--=-aBXB65louq2ks0djlQ9R--
