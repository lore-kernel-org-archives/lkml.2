Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1EBUmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:42:12 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:57735 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1EBUmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:42:10 -0400
Date: Mon, 2 May 2011 22:41:27 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        hirofuchi@users.sourceforge.net, arjan.mels@gmx.net, rjw@sisk.pl,
        Stanislav SCHATTKE <schattke@linuxbox.cz>
Subject: Re: [regression?] d199c96d41d80a567493e12b8e96ea056a1350c1 breaks
	usbip
Message-ID: <20110502204126.GB2550@nik-comp.lan>
References: <20110501192725.GA28466@kroah.com> <Pine.LNX.4.44L0.1105021008491.2106-100000@iolanthe.rowland.org> <20110502165950.GA2550@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20110502165950.GA2550@nik-comp.lan>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5072835 records (last update: 20110502)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> thanks Alan! I'll now try bisect as Greg suggested to see where usbip got=
 broken in latest git...
ok, I don't seem to be able to reproduce with latest git now...
so unless the problem appears again, I guess this can just be forgotten.
thanks guys!
n.


> Greg, will You please push this to stable once it reaches upstream?
> cheers!
> n.
>=20
>=20
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

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2/FvYACgkQ3xdJJrLygV5bqwCgtkZkr52KkZjlxko3w1fvkemt
cWgAn1vlH2yvJXTL4hdlN4D6cFnmYFUm
=eT1F
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
