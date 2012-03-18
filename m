Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2CRLyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 07:54:43 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:38108 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2CRLyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 07:54:41 -0400
X-Greylist: delayed 2042 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2012 07:54:41 EDT
Date: Sun, 18 Mar 2012 12:20:13 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikola Ciprich <nik@nik-comp.lan>
Subject: Re: Linux 2.6.32.59
Message-ID: <20120318112013.GA2287@nik-comp.lan>
References: <20120317130953.GA16926@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20120317130953.GA16926@1wt.eu>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7030530 records (last update: 20120318)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Willy,

thanks for the patches. There's small typo in the paths though:
> The patch and changelog will appear soon at the following locations:
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/patch-2.=
6.32.59.bz2
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/patch-2.=
6.32.59.xz
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/patch-2.=
6.32.59.gz
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.32/ChangeLo=
g-2.6.32.59
Should be:
   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/
   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.=
6.32.59.bz2
   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.=
6.32.59.xz
   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.=
6.32.59.gz
   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/ChangeLo=
g-2.6.32.59

cheers!
nik


>=20
> The updated 2.6.32.y git tree can be found at:
>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git =
linux-2.6.32.y
>   http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git =
linux-2.6.32.y
>=20
> The tree can be browsed on the gitweb interface:
>   http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=
=3Dshortlog;h=3Drefs/heads/linux-2.6.32.y
>=20
>=20
>   Testing status (build/boot, OK/FAIL, otherwise not tested) :
>=20
>          ARCH  |         CONFIGURATION
>        --------+-----------------------------------
>                |  allmodconfig     other-config
>         x86_64 |    build:OK            -
>           i386 |    build:OK         boot:OK
>=20
> Thanks to all reviewers, and to Greg for the final packaging.
> Willy
>=20
> ---------
>  Makefile                      |    2 +-
>  arch/ia64/Kconfig             |   17 -----------------
>  arch/s390/Kconfig             |    3 +++
>  arch/s390/kernel/setup.c      |    1 +
>  block/bsg.c                   |    3 ++-
>  drivers/block/xen-blkfront.c  |    4 ++--
>  drivers/net/usb/usbnet.c      |    2 ++
>  drivers/watchdog/hpwdt.c      |    5 +++--
>  fs/binfmt_elf.c               |    2 +-
>  fs/cifs/dir.c                 |   20 ++++++++++++++++++--
>  fs/ecryptfs/crypto.c          |   21 +++++++++++++++++++++
>  fs/ecryptfs/ecryptfs_kernel.h |    2 ++
>  fs/ecryptfs/file.c            |    3 ++-
>  fs/ecryptfs/inode.c           |   18 +++---------------
>  include/linux/backing-dev.h   |    1 +
>  include/linux/regset.h        |   10 ++++++++--
>  mm/backing-dev.c              |   15 ++++++++++-----
>  mm/page-writeback.c           |    1 +
>  18 files changed, 81 insertions(+), 49 deletions(-)
>=20
> Summary of changes from 2.6.32.58 to 2.6.32.59
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Ben Hutchings (1):
>       IA64: Remove COMPAT_IA32 support
>=20
> David Howells (1):
>       KEYS: Enable the compat keyctl wrapper on s390x
>=20
> David Vrabel (1):
>       blkfront: Fix backtrace in del_gendisk
>=20
> H. Peter Anvin (2):
>       regset: Prevent null pointer reference on readonly regsets
>       regset: Return -EFAULT, not -EIO, on host-side memory fault
>=20
> Heiko Carstens (1):
>       compat: Re-add missing asm/compat.h include to fix compile breakage=
 on s390
>=20
> Jeff Layton (1):
>       cifs: fix dentry refcount leak when opening a FIFO on lookup
>=20
> Jens Axboe (1):
>       writeback: fixups for !dirty_writeback_centisecs
>=20
> Maxim Uvarov (1):
>       watchdog: hpwdt: clean up set_memory_x call for 32 bit
>=20
> Sebastian Siewior (1):
>       net/usbnet: avoid recursive locking in usbnet_stop()
>=20
> Stanislaw Gruszka (1):
>       bsg: fix sysfs link remove warning
>=20
> Tyler Hicks (1):
>       eCryptfs: Handle failed metadata read in lookup
>=20
> Willy Tarreau (1):
>       Linux 2.6.32.59
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9lxO0ACgkQ3xdJJrLygV6+BgCfU+cV86j5jh3T5nHtpq6s7DjJ
H/AAn0LOHK0bvjwIzDcYdPYcdi+D+Bg/
=3cnI
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
