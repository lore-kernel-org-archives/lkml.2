Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2CDSJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:09:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42876 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab2CDSJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:09:28 -0500
X-Sasl-enc: sMhZXPBM8WYihMw7x/t9F1BOL0y9Jasa6+gw0mUVENe1 1330884567
Date: Sun, 4 Mar 2012 10:09:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.58
Message-ID: <20120304180911.GA7336@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.58 kernel.

All users of the 2.6.32 kernel series must upgrade.

************************************************************************
Note:
	This is the last 2.6.32 kernel I will be releasing.  The 2.6.32
	kernel is now in "extended-longterm" maintenance, with no set
	release schedule from now on.  I STRONGLY encourage any users of
	the 2.6.32 kernel series to move to the 3.0 series at this point
	in time.
************************************************************************

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/arm/include/asm/assembler.h        |    5 +
 arch/arm/mm/cache-v7.S                  |    6 +
 arch/s390/include/asm/compat.h          |    7 --
 arch/s390/kernel/process.c              |    1=20
 arch/s390/kernel/ptrace.c               |    2=20
 arch/s390/kernel/setup.c                |    2=20
 arch/s390/mm/mmap.c                     |    2=20
 crypto/sha512_generic.c                 |   83 +++++++++++--------------
 drivers/base/firmware_class.c           |   12 +++
 drivers/cdrom/cdrom.c                   |    8 --
 drivers/gpu/drm/i915/intel_lvds.c       |    8 ++
 drivers/gpu/drm/radeon/r100.c           |    4 -
 drivers/gpu/drm/radeon/rs600.c          |    4 -
 drivers/hwmon/f75375s.c                 |    4 -
 drivers/media/video/hdpvr/hdpvr-video.c |    3=20
 drivers/s390/block/dasd_eckd.c          |    1=20
 drivers/s390/block/dasd_ioctl.c         |    1=20
 drivers/s390/char/fs3270.c              |    1=20
 drivers/s390/char/vmcp.c                |    1=20
 drivers/s390/cio/chsc_sch.c             |    1=20
 drivers/s390/scsi/zfcp_cfdc.c           |    1=20
 drivers/scsi/3w-9xxx.c                  |   11 ++-
 drivers/usb/host/pci-quirks.c           |   11 +++
 drivers/usb/host/xhci-mem.c             |   32 +++++++--
 drivers/usb/serial/cp210x.c             |    2=20
 fs/autofs4/autofs_i.h                   |    1=20
 fs/autofs4/dev-ioctl.c                  |    1=20
 fs/autofs4/inode.c                      |    2=20
 fs/autofs4/waitq.c                      |   22 +++++-
 fs/ecryptfs/file.c                      |    2=20
 fs/ecryptfs/inode.c                     |  103 +++++++++++++++++++++------=
-----
 fs/ecryptfs/main.c                      |   38 ++++++++++-
 include/linux/bitops.h                  |   20 ++++++
 include/linux/compat.h                  |    4 +
 include/linux/kernel.h                  |   15 ++--
 include/linux/kmod.h                    |    9 ++
 include/linux/proportions.h             |    4 +
 kernel/kmod.c                           |   33 +++++++++-
 kernel/relay.c                          |   10 ++-
 net/mac80211/rx.c                       |    2=20
 41 files changed, 338 insertions(+), 143 deletions(-)

Adam Radford (1):
      SCSI: 3w-9xxx fix bug in sgl loading

Al Viro (1):
      Ban ecryptfs over ecryptfs

Alex Deucher (1):
      drm/radeon/kms: fix MSI re-arm on rv370+

Alexey Dobriyan (1):
      crypto: sha512 - use standard ror64()

Andy Whitcroft (1):
      ecryptfs: read on a directory should return EISDIR if not supported

Bruno Thomsen (1):
      USB: Added Kamstrup VID/PIDs to cp210x serial driver.

Dan Carpenter (2):
      relay: prevent integer overflow in relay_open()
      cdrom: use copy_to_user() without the underscores

Daniel Vetter (1):
      drm/i915: no lvds quirk for AOpen MP45

Eliad Peller (1):
      mac80211: timeout a single frame in the rx reorder buffer

Greg Kroah-Hartman (1):
      Linux 2.6.32.58

Heiko Carstens (1):
      compat: fix compile breakage on s390

Herbert Xu (2):
      crypto: sha512 - Use binary and instead of modulus
      crypto: sha512 - Avoid stack bloat on i386

Ian Kent (1):
      autofs: work around unhappy compat problem on x86-64

Janne Grunau (1):
      hdpvr: fix race conditon during start of streaming

John Johansen (1):
      Add mount option to check uid of device being mounted =3D expect uid,=
 CVE-2011-1833

Linus Torvalds (2):
      Fix autofs compile without CONFIG_COMPAT
      firmware loader: allow builtin firmware load even if usermodehelper i=
s disabled

Nikolaus Schulz (2):
      hwmon: (f75375s) Fix bit shifting in f75375_write16
      hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375

OGAWA Hirofumi (1):
      printk_ratelimited(): fix uninitialized spinlock

Rabin Vincent (1):
      ARM: 7325/1: fix v7 boot with lockdep enabled

Rafael J. Wysocki (1):
      PM: Print a warning if firmware is requested when tasks are frozen

Sarah Sharp (2):
      USB: Fix handoff when BIOS disables host PCI device.
      xhci: Fix encoding for HS bulk/control NAK rate.

Srivatsa S. Bhat (1):
      PM / Sleep: Fix freezer failures due to racy usermodehelper_is_disabl=
ed()

Stephen Boyd (1):
      ARM: 7321/1: cache-v7: Disable preemption when reading CCSIDR

Tetsuo Handa (1):
      PM / Sleep: Fix read_unlock_usermodehelper() call.

Tyler Hicks (4):
      eCryptfs: Remove mmap from directory operations
      eCryptfs: Use notify_change for truncating lower inodes
      eCryptfs: Remove extra d_delete in ecryptfs_rmdir
      eCryptfs: Clear i_nlink in rmdir

Wu Fengguang (1):
      lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel

Yong Zhang (1):
      kernel.h: fix wrong usage of __ratelimit()


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPU6/HAAoJEDjbvchgkmk+KR0P/j4PCSxlYf6O1FTwPOvzNbSM
D1gFaoq2OBh6qbZRQ6QkBPSmcnphBiOcmw9veBOJKOxvMmlvEDIi6CYqNQMl+qNC
BS6/6aVHvMcsh/4bBLMKfcgl+lGQHipqlmULBhA6K7fBHKgzytcffSnCjjiFeOQO
6PXsRoMEercaLgo2yR8A4VENImpOPtEmrAwKSGxFxabXkyNb7H2x2pNcH1WUKmt1
MY/09/6q+n/nejWRmdnSU31PvXb1lfPLcCKNiiKrVQKQASlEQEDVTFhICxZ34Dlc
XF/QP9D0WRj498eQjkBAeiyZM7Lmn7bNpOaUztqYPjct4IyaAhZ71G3gBC+PwRTW
RKdHoOvJM0HwJTXPMNfi1M9oPoVbXBvp/6GdzcXbkYORfOyrQY/JOpfUALZfzj84
BKrPXb2yiyf9u4aqfomyPuaQmT6p0rFN/W6K8vY36Rf6T5TeAnfu1STHA+Gcz2Y1
qlEWmcZAUwFwPuO30bplqO3GFYZIHc380HziRCELIsYcaVkVGlsDebVzKfoO67z3
Ye91NJSPkxylI7EA0JdLDuCyuowDHDNnpWdZaub9ULg4B/+n1rlec1kJI4iaVJlh
1qEpjr/YRDfV7WQBF6E0/IRSvEWYrOwl5lxb4lzKZXIkE0ImFUJznEAhlIQWJAfX
qj1x9b3PlWOvgx/OCX6V
=Xv80
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
