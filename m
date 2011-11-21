Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1KUXRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:17:50 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42615 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab1KUXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:17:48 -0500
X-Sasl-enc: 1nWoCS5SgI+fk6Z6R2bMpkFN7YzkLzvRCoZMM+Xlfr9/ 1321917467
Date: Mon, 21 Nov 2011 15:15:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.10
Message-ID: <20111121231554.GA5130@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.10 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 arch/powerpc/include/asm/sections.h       |    2=20
 arch/powerpc/include/asm/synch.h          |    1=20
 arch/powerpc/kernel/kvm.c                 |    1=20
 arch/powerpc/kernel/setup_32.c            |    2=20
 arch/powerpc/kernel/setup_64.c            |    1=20
 arch/powerpc/lib/feature-fixups.c         |   23 +++++
 arch/powerpc/platforms/ps3/interrupt.c    |   23 +++++
 arch/powerpc/platforms/ps3/platform.h     |    1=20
 arch/powerpc/platforms/ps3/smp.c          |    2=20
 arch/sh/include/asm/page.h                |    5 +
 arch/x86/platform/mrst/mrst.c             |   24 +++---
 arch/x86/xen/enlighten.c                  |    3=20
 block/blk-map.c                           |    7 +
 drivers/gpu/drm/i915/i915_debugfs.c       |    2=20
 drivers/gpu/drm/i915/i915_gem.c           |    2=20
 drivers/gpu/drm/i915/intel_display.c      |    4 -
 drivers/gpu/drm/nouveau/nouveau_channel.c |    1=20
 drivers/gpu/drm/nouveau/nouveau_fence.c   |    2=20
 drivers/gpu/drm/radeon/atombios_dp.c      |    2=20
 drivers/leds/led-class.c                  |    5 -
 drivers/md/raid5.c                        |   32 +++++---
 drivers/mfd/twl-core.c                    |    2=20
 drivers/net/wireless/b43/main.c           |    7 +
 drivers/virtio/virtio_pci.c               |   11 +-
 drivers/xen/gntalloc.c                    |    4 -
 fs/hfs/trans.c                            |    2=20
 include/drm/drm_pciids.h                  |    2=20
 mm/backing-dev.c                          |    8 ++
 security/keys/user_defined.c              |    3=20
 sound/pci/hda/hda_codec.c                 |   60 +++++++++------
 sound/soc/codecs/wm8994.c                 |    2=20
 sound/usb/mixer.c                         |  120 +++++++++++++++++--------=
-----
 33 files changed, 244 insertions(+), 124 deletions(-)

Alex Deucher (2):
      drm/radeon/kms: make an aux failure debug only
      drm/radeon: add some missing FireMV pci ids

Anton Blanchard (1):
      powerpc: Copy down exception vectors after feature fixups

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
      Linux 3.0.10

Jesse Barnes (1):
      drm/i915: enable ring freq scaling, RC6 and graphics turbo on Ivy Bri=
dge v3

Johan Hovold (1):
      Revert "leds: save the delay values after a successful call to blink_=
set()"

Kirill A. Shutemov (1):
      sfi: table irq 0xFF means 'no interrupt'

Marcin Slusarz (1):
      drm/nouveau: initialize chan->fence.lock before use

Mark Brown (1):
      ASoC: Don't use wm8994->control_data in wm8994_readable_register()

Michael S. Tsirkin (1):
      virtio-pci: fix use after free

Mika Westerberg (1):
      x86, mrst: use a temporary variable for SFI irq

NeilBrown (1):
      md/raid5: abort any pending parity operations when array fails.

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


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOytuqAAoJEDjbvchgkmk+9UEP/1ImTW88NCZdCLXQbSFU600A
ZwuW6cVjzIk+2YcyThVz8l2z3NHdcf6zwrxaRkBvv1fiMMIiWa0mr7JLi7HrGyIt
loheaQYrZ+nun5BocK/sDsJoaDZJRbBDtoEpFsWxz65rPXWQ2MpMZ+BjHfz/kfPK
TSTq62gm1viUmcwSToJbeMMJD6CyrS3/b7w12mVnL5/SWfjOvhmP84g2ZEyTiEV7
8FrSX4nrfH9ZVu6SFUsvCek3tIns2cG6oI9I1QQyV9iTajHhiTNTEk2UiRqa0Avr
rPf3uXmczerHdGmmFWsPMM7iLgOcGXqq7gUFvP69FvhJIEojNFY6gnCtJgs9axHq
gKYQ1kjZo2h+nmOZ0Qtps1vCsCV81pGxA8wNr1HI0rcU8kFlPsVssSl7rF7Qaefl
q/LGOhIMtyw7e6H4kRL6E1NF19yYea+XxJ5sO4+e/KXFTQdnmkUg3AlRITPQIxeG
lD5oM/3SjQMcXvYbCMLsqja8C5TrBU9Sqad5dUzhLW1aEHZ36Zxv/LBKPbBSJdq3
EYgXvWsPLoI9Ar7Xy9RLl/lPevvzpHqWeReDz+xYO7+yevl9i2l821+GV7rm/I0q
r7RJqVil/GvHXN5eO8jxTyu0ZLNDUZ0KIpczerfvSvbW0EjFjEsbs/munPu4VPE0
fg9/e2wIJJuYkURje38s
=zcon
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
