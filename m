Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1KUXTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:19:01 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40643 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805Ab1KUXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:18:42 -0500
X-Sasl-enc: pgTLnafmYbjnOYXiG+tT8oyB6NolXSCEFICYG6leAapV 1321917478
Date: Mon, 21 Nov 2011 15:16:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.1.2
Message-ID: <20111121231644.GC5130@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.1.2 kernel.

All users of the 3.1 kernel series must upgrade.

The updated 3.1.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.1.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/sound/alsa/HD-Audio-Models.txt     |    1=20
 Makefile                                         |    2=20
 arch/arm/mach-at91/at91cap9_devices.c            |    2=20
 arch/arm/mach-at91/at91sam9g45_devices.c         |    2=20
 arch/arm/mach-at91/at91sam9rl_devices.c          |    2=20
 arch/powerpc/include/asm/sections.h              |    2=20
 arch/powerpc/include/asm/synch.h                 |    1=20
 arch/powerpc/kernel/kvm.c                        |    1=20
 arch/powerpc/kernel/setup_32.c                   |    2=20
 arch/powerpc/kernel/setup_64.c                   |    1=20
 arch/powerpc/kvm/book3s_hv.c                     |    1=20
 arch/powerpc/lib/feature-fixups.c                |   23 ++++
 arch/powerpc/platforms/ps3/interrupt.c           |   23 ++++
 arch/powerpc/platforms/ps3/platform.h            |    1=20
 arch/powerpc/platforms/ps3/smp.c                 |    2=20
 arch/sh/include/asm/page.h                       |    5=20
 arch/x86/xen/enlighten.c                         |    3=20
 block/blk-map.c                                  |    7 -
 drivers/gpu/drm/i915/i915_gem.c                  |    2=20
 drivers/gpu/drm/nouveau/nouveau_channel.c        |    1=20
 drivers/gpu/drm/nouveau/nouveau_fence.c          |    2=20
 drivers/gpu/drm/radeon/atombios_dp.c             |    2=20
 drivers/leds/led-class.c                         |    5=20
 drivers/mfd/twl-core.c                           |    2=20
 drivers/net/wireless/b43/main.c                  |    7 +
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 +
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 +
 drivers/staging/brcm80211/brcmsmac/main.c        |    8 +
 drivers/virtio/virtio_pci.c                      |   11 +-
 drivers/xen/gntalloc.c                           |    4=20
 fs/hfs/trans.c                                   |    2=20
 include/drm/drm_pciids.h                         |    2=20
 mm/backing-dev.c                                 |    8 +
 security/keys/user_defined.c                     |    3=20
 sound/pci/hda/hda_codec.c                        |   60 +++++++----
 sound/pci/hda/patch_sigmatel.c                   |   11 ++
 sound/soc/codecs/wm8994.c                        |    2=20
 sound/usb/mixer.c                                |  120 +++++++++++++-----=
-----
 38 files changed, 244 insertions(+), 104 deletions(-)

Alex Deucher (2):
      drm/radeon/kms: make an aux failure debug only
      drm/radeon: add some missing FireMV pci ids

Anton Blanchard (1):
      powerpc: Copy down exception vectors after feature fixups

Arend van Spriel (1):
      staging: brcm80211: fill in proper rx rate in mac80211 rx status

Ben Hutchings (1):
      block: Always check length of all iov entries in blk_rq_map_user_iov()

Dan Carpenter (3):
      hfs: add sanity check for file name length
      xen-gntalloc: integer overflow in gntalloc_ioctl_alloc()
      xen-gntalloc: signedness bug in add_grefs()

David Howells (1):
      KEYS: Fix a NULL pointer deref in the user-defined key type

Eric Anholt (1):
      drm/i915: Fix object refcount leak on mmappable size limit error path.

Geoff Levand (1):
      powerpc/ps3: Fix lost SMP IPIs

Greg Kroah-Hartman (1):
      Linux 3.1.2

Jochen Friedrich (1):
      ARM: at91: Fix USBA gadget registration

Johan Hovold (1):
      Revert "leds: save the delay values after a successful call to blink_=
set()"

Julian Wollrath (1):
      ALSA: hda - fix internal mic on Dell Vostro 3500 laptop

Marcin Slusarz (1):
      drm/nouveau: initialize chan->fence.lock before use

Mark Brown (1):
      ASoC: Don't use wm8994->control_data in wm8994_readable_register()

Michael Neuling (1):
      powerpc: Add hvcall.h include to book3s_hv.c

Michael S. Tsirkin (1):
      virtio-pci: fix use after free

Nobuhiro Iwamatsu (1):
      sh: Fix cached/uncaced address calculation in 29bit mode

Rabin Vincent (1):
      backing-dev: ensure wakeup_timer is deleted

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: refuse to load unsupported firmware

Takashi Iwai (3):
      ALSA: hda - Don't add elements of other codecs to vmaster slave
      ALSA: usb-audio - Check the dB-range validity in the later read, too
      ALSA: usb-audio - Fix the missing volume quirks at delayed init

Thomas Weber (1):
      mfd: Fix twl4030 dependencies for audio codec

Zhenzhong Duan (1):
      xen:pvhvm: enable PVHVM VCPU placement when using more than 32 CPUs.


--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOytvbAAoJEDjbvchgkmk+C6IP/1liRU+9PfbkUzZ3w4iacNP3
3IiiTVWL7KlsmGM5vIEQWXDylP+o1wmhWeyT2vwbT9ZGbvSggBJwzOxvUhCk38uC
jsc2RH9HEED+6qQ1qJ3dVekvJRX3yrhg/vHMpt6qNeCOIGLa7nKYckkjMV8jqPUb
dI9+p3CwlntyV6Ut1ZrJ2I4ncFiFihnB24AYZqMltviS7sVvfdlY/SWbvPNdSeBf
VCR7u/SmeEDqFoabd+ICtBJEUw95UMkC1Z4tWV9wbVxPDr6wERqz5VvjxROwy/r4
TugpRF3KGjHHMMmADUvXjafe4eRKQSmvYZ8UV1bh1VoQDyRXFY0vICpRMa3LhJH0
Xbq5WgE77NqdQEmW1uDF9MAiUpwbQK3tfn1+H2jyvyMeoDU9CrJtRO3c+LYX8Emg
E87Db7kvXRtQG3RYUsutd5i6wxqsTn+aaIGxHauiEU2UiamYPDyUpqY/wokA0tuA
X6l6TmF1MBz2uStQi/Q1ptASnDyeWstOOydEeEk9U6WOFaURHUgtxeE986npSacr
rHupkvTEqs2Cdbw0S/lO8ZO5uV6vDRlS4AJzcmKR+dBSklMcB8QhrHm1ZejYihJc
ybsiF+3zbXP3cSDo98/SKRbXjh737EQvxGyTlxHGzCl8wt4JRujA9DYM0Btnjht2
+/EswnkOukzh0zOjFQqd
=DWyj
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
