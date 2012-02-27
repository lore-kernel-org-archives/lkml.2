Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2B0AlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:41:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab2B0Akz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:40:55 -0500
Date: Mon, 27 Feb 2012 11:40:40 +1100
From: NeilBrown <neilb@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: MD and rotational attribute
Message-ID: <20120227114040.5b0235de@notabene.brown>
In-Reply-To: <yq18vjpuo1n.fsf@sermon.lab.mkp.net>
References: <20120220122022.GA7466@x2.net.home>
	<20120227104230.125cb9e2@notabene.brown>
	<yq18vjpuo1n.fsf@sermon.lab.mkp.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D3BfURFPGzSV50TuY_ORj/V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/D3BfURFPGzSV50TuY_ORj/V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Feb 2012 19:18:12 -0500 "Martin K. Petersen"
<martin.petersen@oracle.com> wrote:

> >>>>> "Neil" =3D=3D NeilBrown  <neilb@suse.de> writes:
>=20
> Neil,
>=20
> Neil> (I would say that the name 'rotational' is a bug - the issues here
> Neil> is really whether seek is fast or slow is it not??... but no
> Neil> matter).
>=20
> Both the ATA and SCSI specs use the term 'rotational' which I guess is
> how we ended up with that name.
>=20
>=20
> Neil> What do you think Martin?  Should QUEUE_FLAG_NONROT move to
> Neil> queue_limits much like QUEUE_FLAG_CLUSTER did?
>=20
> Absolutely. I posted some patches converting both the nonrot and
> discard/secure discard queue flags a while back but they didn't go
> in. I'll freshen up the kit and resend...
>=20

Thanks!

NeilBrown

--Sig_/D3BfURFPGzSV50TuY_ORj/V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0rRCDnsnt1WYoG5AQKpIRAAo/a3BqRfH1FqRYgrBksIozU0hEIlk3c2
GTUpxRXvC/3D6IzgpvwWDP1YcTsGSTn9G0c3jKXw6BEhyjS1qtUnOFfVB21y2aOt
YzUycgv/GlVw/rVxOdoV1ktHyAJvE01kYhV24R60j/ZkEd7woEwxC5UAuH+n9XeP
3P76WzY82wFp36t3QhVWKGBLJsWLnqFlSCnPvWBPFZC7I7/kzlsoNlHg0BRqUQU3
hsb4EPs0Z3FA2JAWi5h2XFNXo9j9cA+XBsZbee2sMLq+/Mrte9Puk78+KclznWZ/
/dd/WylC4h6V1wwD4qx2ES4IUAltAywjSbPI3hVBvfQ7yvnnf0dJAKhc/nL1rmky
NkqmLeU6VkS2dP77l9YZpCrstkQqx4FcotOFeLB5hVIrn1475DvTuX68BP7ZZUUn
tepJT6JAGhNFFNooO87fhfRVE5TClkrfkAfveDg/UOR+QaTlyWHcNDrKUPb/VR7S
D+m/mk09QE9gQf8W4XZivPFJ7QQrwG9kjVcXLGmubxMPaAuPScaed9OrX5WLJwEp
d3cvyMDPpUI+v0HxHng7qA77gGg1pCH2ilYmF/fFn4prKOdZtJIG9KtzGKpdCBiO
eM0BSAhsbHTmJDAbAIt68/sFQRVQqt3BWqOBL0BCrYr4vp5cYIHOeoYn3Q3OD5os
oo1LQEigOfE=
=wOjI
-----END PGP SIGNATURE-----

--Sig_/D3BfURFPGzSV50TuY_ORj/V--
