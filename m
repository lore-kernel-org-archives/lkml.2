Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab2CSWUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:20:30 -0400
Received: from ozlabs.org ([203.10.76.45]:59974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2CSWU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:20:28 -0400
Date: Tue, 20 Mar 2012 09:20:23 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: David Howells <dhowells@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 18, 2012
Message-ID: <20120319222023.GA15781@thor.bakeyournoodle.com>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120318235114.GA30497@thor.bakeyournoodle.com>
 <20120318184105.GC2095@windriver.com>
 <1121.1332169437@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1121.1332169437@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 19, 2012 at 03:03:57PM +0000, David Howells wrote:
> Tony Breeds <tony@bakeyournoodle.com> wrote:
>=20
> > > 	frv:defconfig  (arch/frv/kernel/head.S operand out of range)
>=20
> What binutils are you using?  I suspect this is fixed by a patch that only
> went upstream very recently.  Are you using a 64-bit machine to do your
> compilation?

I'm using binutils 2.22 on a 64-bit machine. So the patch you supplied
probably wasn't applied.  I'll rebuilf the frv toolchain with that patch
today.

Thanks David.

Yours Tony

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZ7EnAAoJEEsCiJRY75GKMIMP/isTLmpMDSwc33ydDEVvKjK6
IsnRhW63NkYP6Q7MLlsgMn1ss/nbL8juc9LrTTNDqdNO1lwYJD5nxfr95xEwU0XO
HpZghRLzWNrKfynEXh318pMVWP7kEb3OKdf0DfWudJbOXJ5DsMQuQfrmSq6FZaEw
Y6HLr1yBtvVEgoMDMdQ/WawrPxOKGu7Yn7T9kfc+WxBNNnrw6eiFGupsAaYyRRB+
fNuJpSPFTYoWLIM5+fJi8wQtGObX4mLz2M/rIy+HEr+Is5nzussSqO23wDKE7mnR
cow0izwjHPKfrcCYTg2FLBckJd8z67oqielCTGPPSVzeupTN6QHhvpAxBN0FGtbm
5LYVnv4wns8Td0ZTN3c4ShUk3/oB/Rrqxnzs01iP+90UUFE9Mtu39vZk0pH7iLQt
QambuAyfb+id0rdXbSfgPAL8K5HiE7Up+u34cbF55PNJ4daxhYI4IrWDb4841UM0
CYpotaBdJK2ITFZrQ8i35aTnia27rOChItIslr68NDy+f/zBcMP3TZ6FxNOC+nnh
qNYPQifhfNkeuJLv+6/YI0DTU+ZWN8nvfIscGYvdt1GOxHafa5SszjA+SI0ecJfb
GM7tJ3wxk7WxnRdwLHO8Ia+3vetN2dyu5AhZ6AS8kN2Xnu6wkzjMoXqWz+1CG/tK
awQmqQ/gOIr/Pyoh2kZW
=QnRJ
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
