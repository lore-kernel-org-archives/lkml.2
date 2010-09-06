Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab0IFH14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 03:27:56 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:42674 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0IFH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 03:27:55 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Sep 2010 03:27:55 EDT
Date: Mon, 6 Sep 2010 09:17:59 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Message-ID: <20100906071759.GB2356@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org>
 <20100709102935.60648095@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20100709102935.60648095@virtuousgeek.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning LKML,

after some time away from the kernel sources, here my latest report
using Linux on the X201:

  vmlinuz-2.6.36-rc1-00051-g3b89f56
  vmlinuz-2.6.36-rc2-00237-gd4348c6
  vmlinuz-2.6.36-rc3

all come up with a black screen at resume.

I "lost" my last working 2.6.34 kernel, which mostly worked.
On the other hand,

  vmlinuz-2.6.35
  vmlinuz-2.6.35-rc2
  vmlinuz-2.6.35-rc3-00262-g984bc96

do suspend and resume some times, afterwards I see a very slow
refreshing screen, with almost no colours, partly windows
no refresh. Error from xorg at that point (log attached):

[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or=20
even a frozen display: Input/output error.

Also with 2.6.35* I saw freezes during suspend or during resume.

As I had an xorg update somewhere in between, I'm not sure whether there
are some bits conflicting from both sidse.

I'll go back to 2.6.34 today to see whether I get that one working "stable"

If you need more information, just let me know.

Cheers,

Nico


Jesse Barnes [Fri, Jul 09, 2010 at 10:29:35AM -0700]:
> On Fri, 9 Jul 2010 19:04:32 +0200
> Nico Schottelius <nico-linux-20100709@schottelius.org> wrote:
>=20
> > Good evening hackers,
> >=20
> > latest report from 2.6.35-rc4 on X201:
> >=20
> >   - (almost) everytime I close and reopen the lid, the image is screwed=
 up
> >     - switching to vt1 (away from xorg) and back to vt7 fixes that almo=
st always
> >     - did not happen on 2.6.34 (iirc)
>=20
> Can you bisect this issue?
>=20
> >   - if it's not screwed up, the system is frozen
> >     - does not react on ping, last image is displayed, no keyboard shor=
tcut works
> >     - ATTENTION: it's *NOT* needed to suspend directly before to get a =
freeze!
> >       - simplying closing & opening the lid is enough
>=20
> Presumably this used to work too, so a bisect might help here as well.
>=20
> FWIW mine doesn't behave this way; I have an x201s and it works pretty
> well with current bits (note that a bunch of 2D, Mesa and libdrm fixes
> have landed recently as well).
>=20
> --=20
> Jesse Barnes, Intel Open Source Technology Center

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyElacACgkQ19zI5DGHffCC6ACeLbANCnIy+5VTu/G7POKFifrR
5SMAoJnHhr6QZTIMBxc+cvRYvUNDRrkr
=dgmJ
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
