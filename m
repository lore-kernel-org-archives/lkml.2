Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1D3MEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:04:23 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:57952 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab1D3MEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:04:22 -0400
Date: Sat, 30 Apr 2011 14:02:05 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        seto.hidetoshi@jp.fujitsu.com
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110430120205.GA2459@nik-comp.lan>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20110430093605.GA10529@1wt.eu>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5064914 records (last update: 20110430)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> There was a kernel parameter in the past that was used to make jiffies wr=
ap
> a few minutes after boot, maybe we should revive it to try to reproduce
> without waiting 7 new months :-/
hmm, I've googled this up, and it seems to have been 2.5.x patch, so it will
certainly need some porting..
I'll try to have a look on it tonight and report...

>=20
> Last, the "advantage" with a suspected regression in a stable series is t=
hat=20
> there are a lot less patches to test.
>=20
> Regards,
> Willy
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
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

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk27+jwACgkQ3xdJJrLygV43ggCgyjqn94HOPdMEYjX8coEsZMMB
FbwAn2Q1cCpmJZB/0mbfaWUV5zMSedzQ
=wrcj
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
