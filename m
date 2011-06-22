Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab1FVTOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:14:14 -0400
Received: from mail.southpole.se ([193.12.106.18]:53339 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab1FVTON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:14:13 -0400
Subject: Re: [PATCH 14/19] OpenRISC: Module support
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <201106221626.12023.arnd@arndb.de>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	 <1308483825-6023-15-git-send-email-jonas@southpole.se>
	 <31626.1308686616@turing-police.cc.vt.edu>
	 <201106221626.12023.arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0DLDXc2aZrs0diINoba9"
Organization: South Pole Consulting AB
Date: Wed, 22 Jun 2011 21:14:10 +0200
Message-ID: <1308770050.20122.4951.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-0DLDXc2aZrs0diINoba9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-22 at 16:26 +0200, Arnd Bergmann wrote:
> On Tuesday 21 June 2011, Valdis.Kletnieks@vt.edu wrote:
> > On Sun, 19 Jun 2011 13:43:40 +0200, Jonas Bonn said:
>=20
> > > diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/mod=
ule.c
> > > new file mode 100644
> > > index 0000000..952b129
> > > --- /dev/null
> > > +++ b/arch/openrisc/kernel/module.c
> > > @@ -0,0 +1,126 @@
> > > +/*
> > > + * OpenRISC module.c
> >=20
> > Lose the filenames in the headers - you do this in multiple files.
>=20
> Good point.

What's an acceptable "comment title"?  Most other arch's seem to put the
filename there... I understand this is undesirable, but what can I put
there instead?  Is "OpenRISC Linux" acceptable, or is nothing at all
preferable?

Just want to be clear about what's allowed before I go changing all of
these...

/Jonas


--=-0DLDXc2aZrs0diINoba9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk4CPv4ACgkQ70gcjN2673NMEgCcCoG/GCP0/mvtwpMM4br73dQZ
vHsAn1CcZMjBruBGGmqHG87dGQEqQZiF
=I2I6
-----END PGP SIGNATURE-----

--=-0DLDXc2aZrs0diINoba9--

