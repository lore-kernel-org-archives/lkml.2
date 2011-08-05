Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1HEMgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:36:25 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:55266 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1HEMgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:36:24 -0400
Date: Fri, 5 Aug 2011 09:36:06 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Michael Thayer <michael.thayer@oracle.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Getting notification of PS/2 mouse packages
Message-ID: <20110805123605.GA5464@nautilus.holoscopio.com>
References: <1312544155.2426.49.camel@michael-latitude-e6410>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <1312544155.2426.49.camel@michael-latitude-e6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2011 at 01:35:55PM +0200, Michael Thayer wrote:
> Hello,
>=20
> I am looking at writing a driver (it is to be open source, but not for
> mainstream kernel inclusion) for a virtual machine-specific input
> device.  Unfortunately one of the versions of the device I have to
> support signals that it has new data available by sending a fake package
> to the PS/2 mouse, so I need to be able to get notification of that
> somehow.  Looking at the kernel source, I see that the i8042 driver
> requests IRQ 12 as IRQF_SHARED, and that the kernel always notifies all
> registered interrupt handlers of an interrupt, even if one of them
> returns IRQ_HANDLED.  So it looks like I can just request my own shared
> handler for IRQ 12 and always return IRQ_NONE, but still update my data.
> However I am not sure whether this is something I can count on to keep
> working in future kernel releases.  Does anyone on this list know more
> about this, or can someone suggest a cleaner way to get the
> notifications I need?
>=20
> Thanks.
>=20
> Regards,
>=20
> Michael

Hello, Michael.

My advice is: send it for mainline inclusion!

You more likely get your code reviewed, and it what you do is
acceptable, it will get included and that's a "OK" for your solution.
Then, if it turns out it's not OK anymore, it's much more likely people
will go and fix it for you. At least, that's certainly not going to
happen if it's not published somehow, but out-of-tree drivers or patches
do not usually have the attention of Linux developers.

So, what is it that you consider your work not worth of mainline
inclusion?

Regards,
Cascardo.

> --=20
> ORACLE Deutschland B.V. & Co. KG   Michael Thayer
> Werkstrasse 24                     VirtualBox engineering
> 71384 Weinstadt, Germany           mailto:michael.thayer@oracle.com
>=20
> Hauptverwaltung: Riesstr. 25, D-80992 M=C3=BCnchen
> Registergericht: Amtsgericht M=C3=BCnchen, HRA 95603
>=20
> Komplement=C3=A4rin: ORACLE Deutschland Verwaltung B.V.
> Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
> Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
> Gesch=C3=A4ftsf=C3=BChrer: J=C3=BCrgen Kunz, Marcel van de Molen, Alexand=
er van der Ven

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOO+O0AAoJEEWxSg7udFZIThoP/ifuIAAWHtsW8DNzI/vDMp76
My5ORhuuOdBCImcMNVM8KgtGH+7mqJmCxZ3/T3+E0YoeLJUMqyCvzR3XU9QhkG3e
9B6HzLOK5+pm++EZl1PNk6Cx078wWaWLYOIBKQCmrSGh2uOGuz0e5+du2hiZupM9
76983S+5IXS330QqcPc7ODMTDuoj/oOYDRjmNXE24lGKdqBn7Xb7pRZSvgNsRYhG
QWeusuHDeTDN6wPsz43KzPnW7j6dqVvy1sbYATPFSIIb+bK8GZ/ZoF6W4JPLJPMl
vSwGaD/lVHMdFHAkd5HVMcBpqgyVgqf0JrpXo+MovDfGJqB+GCmyeitiBpfwIHuM
Bvu8FQk9vWFNVo+M890TISkxMKwToqXpLys7ZW9rtLOHyrm691qPzPbOdXwVPxo+
dGL6PnRGqZEgRq5S/2V7EcxUih25sutSA9XaVZisOiw3u9LyYPAzmKaWi2Xfq/h9
ikVHcTrduGmT8XHgREXjzdeikL3OFVX+edq5v3vdW+yVlQGiuL7JXqtxxSyjn9KT
PDYC5NElxit8xdVEx6ILNzotZBW3mZaEr7K/vv1WJpmet0CjDgY9OpW0F+XFeo0Y
IZMGpCb0Hlkk4Q3WisN8N3LUxra/5LfWyeopTWkATt6i3qXXU88DUnjxyB+jBXtI
S+OVx6XIk/7snhvmD+qd
=9501
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
