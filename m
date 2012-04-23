Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2DWFYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:24:02 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:36142 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2DWFYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 01:24:00 -0400
Date: Mon, 23 Apr 2012 07:23:50 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: suspected regression in 3.0.28 - applications having problems
	binding to ports
Message-ID: <20120423052350.GD17762@pcnci2.linuxbox.cz>
References: <20120413181856.GA2286@nik-comp.lan> <20120413185452.GA7172@khazad-dum.debian.net> <20120413190822.GA2037@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <20120413190822.GA2037@nik-comp.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7496793 records (last update: 20120423)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

so I'm sorry for the fuss, the problem actually WAS in nagios, which was
randomly binding to various ports blocking both self and other applications.
Dunno why this always showed up after booting to 3.0.27, but this definitely
is userspace problem.

thanks.

nik


On Fri, Apr 13, 2012 at 09:08:22PM +0200, Nikola Ciprich wrote:
> > Did you test 3.0.28?  Your subject line mentions 3.0.28, which was rele=
ased
> > a few hours ago, but the body of the email only mentions a regression in
> > 3.0.27 when compared to 3.0.26...
> ouch, I meant 3.0.27, not 28 :-(
> sorry for confusion. I'll be able to test 3.0.28 next wednesday.
> BR
> nik
>=20
>=20
>=20
> >=20
> > --=20
> >   "One disk to rule them all, One disk to find them. One disk to bring
> >   them all and in the darkness grind them. In the Land of Redmond
> >   where the shadows lie." -- The Silicon Valley Tarot
> >   Henrique Holschuh
> >=20
>=20
> --=20
> -------------------------------------
> Ing. Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28. rijna 168, 709 01 Ostrava
>=20
> tel.:   +420 596 603 142
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
>=20
> www.linuxbox.cz
>=20
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------



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

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk+U52YACgkQ3xdJJrLygV4pEgCgmZGZYu+SgFRclJ/NmiSEtSKJ
MCgAmgPT8BCFQwVEJggJgXmuXYRURD5x
=1Jiq
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
