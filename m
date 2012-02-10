Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab2BJKWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:22:54 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:34553 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927Ab2BJKWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:22:53 -0500
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Feb 2012 05:22:52 EST
Date: Fri, 10 Feb 2012 11:08:09 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        geert@linux-m68k.org
Subject: Re: Linux 3.3-rc3
Message-ID: <20120210100809.GB28736@pcnci.linuxbox.cz>
References: <CA+55aFyDE+chjpt9N5yNG=+A_LL5qhZjPYfOjFGuZcXUPGEoOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <CA+55aFyDE+chjpt9N5yNG=+A_LL5qhZjPYfOjFGuZcXUPGEoOQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 6611345 records (last update: 20120210)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 08, 2012 at 07:36:37PM -0800, Linus Torvalds wrote:
> Another week, another -rc.
>=20
> No big surprises, which is just how I like it. About a third of the
> patches are in ARM, but the bulk of that is due to the removal of the
> unused DMA map code form the bcmring support. So no complaints.
>=20
> The rest is fairly flat in the diffstat (=3D=3D random small changes all
> over), although mostly drivers. More sound/hda (and asoc) updates,
> some target and IB updates, etc etc.
>=20
> Shortlog appended for your perusal, you can see the kind of largely
> "fix small details" almost all of it is,

Hi,

just wanted to let You know, that following fix didn't make it into
Your tree yet:
https://lkml.org/lkml/2012/1/15/23

the bug is causing build failures with some GCC versions:

  CC [M]  net/bluetooth/l2cap_sock.o
net/bluetooth/l2cap_sock.c: In function =E2=80=98l2cap_sock_connect=E2=80=
=99:
include/net/bluetooth/l2cap.h:838: sorry, unimplemented: inlining failed in=
 call to =E2=80=98l2cap_chan_connect=E2=80=99: function body not available
net/bluetooth/l2cap_sock.c:126: sorry, unimplemented: called from here
make[2]: *** [net/bluetooth/l2cap_sock.o] Error 1
make[1]: *** [net/bluetooth] Error 2
make: *** [net] Error 2

BR
nik


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

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk807IkACgkQ3xdJJrLygV7ChwCgoHaUp5ze24psaZ9+Rd0AzCH5
EiwAn09Zp6a0x0zPjDVrcPnE/E+FyN3N
=p+FP
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
