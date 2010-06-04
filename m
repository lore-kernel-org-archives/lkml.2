Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0FDJVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:21:05 -0400
Received: from flounder.pepperfish.net ([87.237.62.181]:40580 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0FDJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:21:04 -0400
X-Greylist: delayed 3193 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jun 2010 05:21:03 EDT
Date: Fri, 4 Jun 2010 09:27:46 +0100
From: Vincent Sanders <vince@kyllikki.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
Message-ID: <20100604082746.GA10021@kyllikki.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com> <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org> <87d3w9582z.fsf@deeprootsystems.com> <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2010 at 06:20:09PM -0700, Linus Torvalds wrote:
>=20
>=20

snip

>=20
>  - TWO HUNDRED THOUSAND lines of arch/arm is just pure garbage, namely th=
e=20
>    defconfig files. Quite frankly, anybody who calls that anything but=20
>    pure "noise" is just misguided and being stupid.
>=20

For some hard data which might be useful in arguments on this you
might want to reference

http://armlinux.simtec.co.uk/reports/kautobuild-5year-report.pdf
http://armlinux.simtec.co.uk/reports/kautobuild-5year-stats.ods

The written report is not complete as I had hoped to have an
announcement about the autobuilder fifth aniverasry soon. Perhaps this
will be useful in keeping some default configurations which give us
maximal coverage.

I provide this purely for information, I do not intend to upset you
futher on this subject, pretty please do not shoot the messenger ;-)

--=20
Regards Vincent


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFMCLkCiUwwPOvjHvURArjsAJ9GxtjgR4hgTFiO7gZwsJixUhWuPwCgn8ww
j8OrkgLXwNwatokR5NKLvPs=
=hhKA
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
