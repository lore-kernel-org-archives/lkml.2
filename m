Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2KEKLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:11:03 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65262 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2KEKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:10:56 -0500
Date: Mon, 5 Nov 2012 11:09:29 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.18
Message-ID: <20121105100929.GA24472@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.18 kernel.

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

 Makefile                                      |    2 -
 arch/arm/mach-exynos/common.c                 |    5 ----
 arch/arm/mach-s3c24xx/s3c2416.c               |    2 -
 arch/arm/mach-s3c24xx/s3c2443.c               |    4 ---
 arch/arm/mach-s5p64x0/common.c                |    3 --
 arch/arm/mach-s5pc100/common.c                |    3 --
 arch/arm/mach-s5pv210/common.c                |    3 --
 arch/arm/plat-samsung/include/plat/spi-core.h |   30 ---------------------=
-----
 drivers/block/floppy.c                        |    1=20
 drivers/gpio/gpio-timberdale.c                |    4 +--
 drivers/gpio/gpiolib.c                        |   10 ++++++--
 drivers/gpu/drm/nouveau/nouveau_drv.c         |   20 +++++++++--------
 drivers/gpu/drm/nouveau/nouveau_state.c       |    4 ++-
 drivers/gpu/drm/nouveau/nv04_dac.c            |    8 +++---
 drivers/gpu/drm/nouveau/nv04_dfp.c            |    6 ++---
 drivers/gpu/drm/nouveau/nv04_tv.c             |    4 +--
 drivers/hid/hid-microsoft.c                   |   18 +++++++++++----
 drivers/md/raid1.c                            |    2 -
 drivers/net/wireless/b43/main.c               |    2 +
 drivers/target/target_core_transport.c        |    1=20
 fs/ext4/ialloc.c                              |   19 +++++++---------
 21 files changed, 59 insertions(+), 92 deletions(-)

Ben Skeggs (3):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
      drm/nouveau: fix suspend/resume when in headless mode
      drm/nouveau: headless mode by default if pci class !=3D vga display

Dan Carpenter (1):
      gpio-timberdale: fix a potential wrapping issue

Eric Sandeen (1):
      ext4: fix unjournaled inode bitmap modification

Greg Kroah-Hartman (2):
      Revert: ARM: SAMSUNG: Add naming of s3c64xx-spi devices
      Linux 3.4.18

Herton Ronaldo Krzesinski (1):
      floppy: do put_disk on current dr if blk_init_queue fails

Jiri Slaby (1):
      HID: microsoft: fix invalid rdesc for 3k kbd

Larry Finger (1):
      b43: Fix oops on unload when firmware not found

Mathias Nyman (1):
      gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

NeilBrown (1):
      md/raid1: Fix assembling of arrays containing Replacements.

Nicholas Bellinger (1):
      target: Fix double-free of se_cmd in target_complete_tmr_failure


--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl5BZAAoJEDjbvchgkmk+eCUQAKFTWFSbhLpk3UFohGvHsbIF
Vdd9Q9KEbLskP12z3Ihun6hF5uIFxHYMHRWj9i5UZvyTG+LZ8r2NV/B7wX8q0ucs
5MxMmdKYKhTx5qffiWFpcKU5/zgqG/bYaiqA9RANcWuRCXE6PDJ5Gm6nJwV1nny2
TBGnUSZ3HcEdy2S1IoLhcr7Zwdyqu9y7zZrLjPA7uGrEMfTfnMmy9WeW6dSIE9d9
IjGfBOtXd4D9ot6gaL7i3tjM9k05uTncbyNBDcMS1MlcVo0dLjO0Q1NAE/5UrQir
H8LmTj+7QUMrurOYrE+KJeOEvje+IoJFpG6cQV5W9t0LyOVqyrzxeM+uOuCddNch
beqN6LuCqsM3Niz/NclO396thtAiK3GCed4Op31YWuJWJgKB+51lvAA/W3tBU4BN
hRk3/6gAzR1jIMqai66Ps0KsvmWYbnnrTmAzNxhcE8Tje5j7esLs4Kd3c/qkGaA3
4ReZUG0Rc6wPllI/9aC0JGebqZUgNctJGk9J/L+kZUJASHKd/kIIdZxqXl7zUlGJ
i2AdXe6WfZU6nTZ09T6vyPWKI4Knpf4y5H+i9htyMPBnnogqAT7LHVbQIzIbPR01
S4FclbdMTnWl6U43xMO7QKrB57XShkqUlQExaPpgEPCnuE3QV7UFDmATUv1P7Ki7
WYgyw0IGeKoC9erliWQM
=TIkO
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
