Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2D3JCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:02:00 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:33001 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828Ab2D3JB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:01:58 -0400
Date: Mon, 30 Apr 2012 12:00:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Steffen =?iso-8859-1?Q?M=FCller?= <steffen.mueller@radio-frei.de>
Cc: Oliver Neukum <oliver@neukum.org>, opensuse-factory@opensuse.org,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Slaby <jslaby@suse.cz>,
        stable@kernel.org, Greg KH <greg@kroah.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [opensuse-factory] Re: usb midi keyboard broken [3.3.3
 regression] [SOLUTION]
Message-ID: <20120430090033.GM20298@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org>
 <5861865.YnqskICckP@thinkpadsm.rf-studio>
 <201204301048.21852.oliver@neukum.org>
 <2197151.1tZV6ssZos@thinkpadsm.rf-studio>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XVTPT6MZt3zd/C+/"
Content-Disposition: inline
In-Reply-To: <2197151.1tZV6ssZos@thinkpadsm.rf-studio>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XVTPT6MZt3zd/C+/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 30, 2012 at 11:00:05AM +0200, Steffen M=FCller wrote:
> Am Montag, 30. April 2012, 10:48:21 schrieb Oliver Neukum:
> > Am Samstag, 28. April 2012, 23:26:58 schrieb Steffen M=FCller:
> > > yes, it works now without blacklisting for autosuspend after build pa=
tched
> > > kernel with this in drivers/usb/core/quirks.c
> > >=20
> > > rf@ThinkpadSM:~/tmp> diff -uNr quirks-org.c quirks.c
> > > --- quirks-org.c        2012-04-28 23:19:45.440959001 +0200
> > > +++ quirks.c    2012-04-28 20:38:50.000000000 +0200
> > > @@ -123,6 +123,9 @@
> > >=20
> > >         /* Guillemot Webcam Hercules Dualpix Exchange*/
> > >         { USB_DEVICE(0x06f8, 0x3005), .driver_info =3D
> > >         USB_QUIRK_RESET_RESUME },
> > >=20
> > > +       /* Midiman M-Audio Keystation 88es */
> > > +       { USB_DEVICE(0x0763, 0x0192), .driver_info =3D
> > > USB_QUIRK_RESET_RESUME }, +
> > >=20
> > >         /* M-Systems Flash Disk Pioneers */
> > >         { USB_DEVICE(0x08ec, 0x1000), .driver_info =3D
> > >         USB_QUIRK_RESET_RESUME },
> > >=20
> > > rf@ThinkpadSM:~/tmp>
> >=20
> > Could you please send a formal patch with "Signed-off-by" and stuff
> > upstream?
> >=20
>=20
> hmm... I would but I've never done this before. No idea how to do this.

Take a look at Documentation/SubmittingPatches, it has all the
information you need ;-)

--=20
balbi

--XVTPT6MZt3zd/C+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnlSxAAoJEIaOsuA1yqREGi4QAKc4Ofke2sgej4XPD7IYkNdQ
X88Mi2sVwwwsndOU6zBLcF4gTMaOlfXDwlPB7txEAF/icqRmut/ziflguiFWEQB2
6z+FV7OwenqcGF7cn344ugmM/WGJcheyRM+XO7WVibaAh2v/hC5JNbM59R4EGhJB
9c1Kjfo1H5A4+AbW3lv5KTT7OWooZWd3LjjOL7wEzZeX64TuHX0FWsNCcyJt7/2K
6lpFFk9qP/n0GBMwAEb6t80Wdpttu/RDAkkfqDORAlWpeNykmtrQw4rpWIcHQDsH
BXGUklBI4tklCjqURAsK1DAxZ6aXu0j/ACpQqsSgfemTeL/IC/23lx2SpbZRbHHV
i/1OZC504nVkN4+I4rzmP1kawEA7sYlMopWfbt8xaALXWDY6UAkEuHYb9ISoaWLX
YcTrs07N5SANCwUeLxyhUARVTOFSChxzBfGiyofJzkf/55Lnps0j0V9y+HR0OJ06
Up9ga7V3CyrZHInUEbh5vt2mn7IwFMpKwb8UD0CaqBbXAi/tLswxgNGIRqahLFXY
NtLFqr0hM9yVk1iKIm7qCTrmDHd3oBIwdsN63oKnJYcsdeCHKRxUhgaQwnFN5krK
2jeQQ8p2p4ZNw2A56Xf9TYLKfoS91Rax2pX9NwuCeh7+B5bWA62/s44Q03NX0ZDm
T8W8c4gUsBGnZ2gRs8KR
=r+z2
-----END PGP SIGNATURE-----

--XVTPT6MZt3zd/C+/--
