Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab0JVVSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:18:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56282 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756495Ab0JVVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:18:20 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Florian Fainelli <florian@openwrt.org>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, 600155@bugs.debian.org,
        Jason Heeris <jason.heeris@gmail.com>,
        David Miller <davem@davemloft.net>, spamalot@hispeed.ch
In-Reply-To: <4CC1E610.4050605@fastmail.fm>
References: <20101022184033.486292826@clark.site>
	 <4CC1E257.4070704@fastmail.fm> <20101022192350.GA10673@suse.de>
	 <4CC1E610.4050605@fastmail.fm>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OINCKZR7YeTQerh5eJ3e"
Date: Fri, 22 Oct 2010 22:18:06 +0100
Message-ID: <1287782286.20865.248.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [11/17] r6040: Fix multicast list iteration when hash filter
 is used
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OINCKZR7YeTQerh5eJ3e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-10-22 at 20:29 +0100, Jack Stone wrote:
> On 22/10/2010 20:23, Greg KH wrote:
> > On Fri, Oct 22, 2010 at 08:13:27PM +0100, Jack Stone wrote:
> >> On 22/10/2010 19:39, Greg KH wrote:
> >>>  drivers/net/r6040.c |    1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> --- a/drivers/net/r6040.c
> >>> +++ b/drivers/net/r6040.c
> >>> @@ -976,6 +976,7 @@ static void r6040_multicast_list(struct
> >>>  		iowrite16(hash_table[3], ioaddr + MAR3);
> >>>  	}
> >>>  	/* Multicast Address 1~4 case */
> >>> +	dmi =3D dev->mc_list;
> >>>  	for (i =3D 0, dmi; (i < dev->mc_count) && (i < MCAST_MAX); i++) {
> >> Any reason for the dmi in the above line? As far as I can see it is a
> >> nop.
> >=20
> > Look closer at the for loop please.
>=20
> Maybe I'm missing something but:
> for (i =3D 0, ---->dmi <----; (i < ...
>=20
> The dmi here still doesn't seem to do anything?

It doesn't, but it doesn't do any harm either.  The loop has been
rewritten in mainline.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-OINCKZR7YeTQerh5eJ3e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATMH/iOe/yOyVhhEJAQKZVhAAm6Y6WzSzRZ/5kNbqYrsCqh3OTEWmcdIv
AsefZaxiV14USwHCdiqYRgyPTzOp27OEYPgipf1V8/yyJhek9jwnVXdli8CNC0vk
3dWQ0ahgireRdG/pSC/zIL0FLDJixCGcHNXqQb4TDow2BAfFCA3bCbQdpXLVRhXT
oXEq8iMQnHYb2WirsMokDSxIiCBFkAHIxOtS6/7Hh2ZyjTWBo5Mr1jmGFvZ9U67v
GtN9UKl9A7bVOtVVwezm952fQZ8Ca4ffg3PWgmMpxPEjVT/hu91BWAzpg4klHck1
/159k6AL9MA6n3wL+caRyENoehKRS3Z2BtIbMbvuuKYHp3eZc5UOQPJafU3pqPGh
7qcuel+iVR/tMHreqwjUNnX4ohJXOYKd0tIVN6m1thQvefpvpsDAsTpY1rDpOEJu
UnAUpbvN0/4xPLS6tsMdvtOwkGsvlmKhtkRflVu8ovojaSv06+Odv6vXYl07xY6X
BsezFKKsCV8ZpIxmlxlKXN/Ahu+ciAMCNLOIz7ZWowSinK3CjzrLzo4L1niVt33M
8FacPvrWtH3p5Oj58vTC5BxWQkUF+naFYyA5GawtQpdNx5we8V1VtmO7fbnyhnTE
5cav/18heevdlBFxzYOSL5jE2wAR+OEWm4PEreMnzznmObXgoZyDT2VwvLPVzgCb
zRcjvPd/R8Q=
=S8HM
-----END PGP SIGNATURE-----

--=-OINCKZR7YeTQerh5eJ3e--
