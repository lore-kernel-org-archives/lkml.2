Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768901Ab2KOUEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:04:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42639 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768435Ab2KOUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:04:39 -0500
Message-ID: <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>, gustavo@padovan.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ulisses@profusion.mobi, marcel@holtmann.org,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Date: Thu, 15 Nov 2012 20:04:32 +0000
In-Reply-To: <20121114213819.GT13292@decadent.org.uk>
References: <20121114053933.726869752@decadent.org.uk>
	 <20121114053933.935584768@decadent.org.uk> <20121114212426.GA1866@joana>
	 <20121114.163044.2287972932330697472.davem@davemloft.net>
	 <20121114213819.GT13292@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OE6h5ELbOyyC5iHpzumj"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OE6h5ELbOyyC5iHpzumj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-14 at 21:38 +0000, Ben Hutchings wrote:
> On Wed, Nov 14, 2012 at 04:30:44PM -0500, David Miller wrote:
> > From: Gustavo Padovan <gustavo@padovan.org>
> > Date: Wed, 14 Nov 2012 19:24:26 -0200
> >=20
> > > Hi Ben,
> > >=20
> > > * Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]:
> > >=20
> > >> 3.2-stable review patch.  If anyone has any objections, please let m=
e know.
> > >>=20
> > >> ------------------
> > >>=20
> > >> From: Ulisses Furquim <ulisses@profusion.mobi>
> > >>=20
> > >> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
> > >>=20
> > >> The handling of SCO audio links and the L2CAP protocol are essential=
 to
> > >> any system with Bluetooth thus are always compiled in from now on.
> > >=20
> > > I wonder if this could not break any kind of script or code people ha=
ve that
> > > refer directly to the sco and l2cap modules. Also I don't see this ch=
ange as
> > > really necessary for 3.2.
> >=20
> > Agreed, I wish this had not been merged into -stable, I would have neve=
r
> > submitted a patch like this myself.
>=20
> This is required by:
>=20
> commit ff03261adc8b4bdd8291f1783c079b53a892b429
> Author: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> Date:   Thu Aug 23 21:32:44 2012 -0300
>=20
>     Bluetooth: Fix sending a HCI Authorization Request over LE links
>    =20
>     commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.
>=20
> which was already applied.

So, do you think it's better to revert that in 3.2, or to go ahead with
this?

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-OE6h5ELbOyyC5iHpzumj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKVK0Oe/yOyVhhEJAQrb3w//bSXUN6/0stkGCJv3/h1i/rUqXrHdiN68
iZ4Z93jhj4AlhqPaKAZjabLXmnM0Tr4dknJqqA5KWjSy661XEtpm8KIz3uypprw8
0sqkW024+qLSV3Y1b0qdB6nAmGxIxbN/YSTVCtimgIA9j2Uph/FfrT8bmqDPer3M
3foSIDvNuzjBKx0L2djvCKrjJ5YZlLL8eSWnNAp0hrABQOXI63ceWUbAjs/KMmBz
/benXdzOfuG79k+bLCy/1OpNedd0xEKUVQ0KGQUpn7Aucdh4UFDeIstzYHQmNwpl
FQnnYosUlYN9TsdK/rpxuAmYn07+G0TI6LxwrSX7vohzSdSzcPP15UaD6X+4hEiV
0OHvxTGEzSKpU0BJ14O/ElhsXYyoIN8w+zi1LVZe6bokW4ZV/fdA5aWB7m96zzdG
pCVCzQguL1WRk5+DlGHRj1r5JYW2Fs+si/yBhx3luZCjWuvPPo8ydAEW3zu0itVu
//nI3RbZ2BX58XyxHgLK17zTdt5qxfrqDmgLYzm1lDmCEKQKPyWeiBFLCawtNq54
aCMhgfhiX3aZZqo8Gzqi5LSb4cBZnXYcXyhieP5ZapNJa6g+rpL3YXp92DlyyBCT
KGmyX6MzFByzb5AiCj6wZV1abi+MyXQdCqa63eYbZDs5a6Hr9IEOioFyWKwfuwTQ
tgDzUjyZetE=
=+ci0
-----END PGP SIGNATURE-----

--=-OE6h5ELbOyyC5iHpzumj--
