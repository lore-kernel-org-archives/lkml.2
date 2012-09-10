Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2IJP0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:26:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941Ab2IJP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:26:06 -0400
Message-ID: <1347290758.5134.123.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 84/95] virtio_blk: fix config handler race
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Michael S. Tsirkin" <mst@redhat.com>,
        Asias He <asias@redhat.com>
Date: Mon, 10 Sep 2012 16:25:58 +0100
In-Reply-To: <87392qfw9u.fsf@rustcorp.com.au>
References: <20120909224202.102918910@decadent.org.uk>
	 <87392qfw9u.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3Q+4XiBG9sLlIP+dr/uf"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Q+4XiBG9sLlIP+dr/uf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-09-10 at 11:56 +0930, Rusty Russell wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: "Michael S. Tsirkin" <mst@redhat.com>
> >
> > commit 4678d6f970c2f7c0cbfefc0cc666432d153b321b upstream.
> >
> > Fix a theoretical race related to config work
>=20
> ???
>=20
> From Documentation/stable_kernel_rules.txt:
>=20
>  - No "theoretical race condition" issues, unless an explanation of how t=
he
>    race can be exploited is also provided.
>=20
> Similarly, '[ 85/95] virtio_blk: Drop unused request tracking list'
> is a marginal perf improvement, why is it in there?
>=20
> Neither of these were cc:stable; did someone request them specifically?

They weren't requested; I think I included them as apparent dependencies
of one or more of the others:

b79d866 virtio-blk: Fix hot-unplug race in remove method
02e2b12 virtio-blk: Call del_gendisk() before disable guest kick
483001c virtio-blk: Reset device after blk_cleanup_queue()

The last of those was cc'd to stable and the first two were applied in
3.5.2, thus I assume requested by someone.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-3Q+4XiBG9sLlIP+dr/uf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUE4Ghue/yOyVhhEJAQpbQBAAyzYgyaXE3l9MlonZIy8cFk8GF/vcnoZA
4CqUfzKfFHTfq9LsKEkP+BuSOF/VY9zv8d8Cpnnnh8fLry3vmK1KdNpUAe+gc1dD
0pERrluVnUK+tILCddPur+60VXwH1RmEOHYk7PEGAEcUVkwI8uGUUXHNbjYWHsMF
cQg/1L82ucEbkwZ9HnE5NusTplzJuBWI8SUWHTUszNle3e/AMh04yPtks2zxqbxb
OrlEODfxCJA7cI7cCSjHxzKY4wPmL/D+7/yHySwhppCB/0Tkfv8o+LKEa6kP1nZr
ywu5z6kWwYVVF2vT/OrNvCFPCjhl8IgUWRsywvzOhGWYZTLhoQ5pg3jjw4bOuyn1
rZ6rHq0aWj9m9qAfkDHFGmbZCoIMUKWAWK64M6YBDZFAlqCvWNwp9/+xBlstMMfV
GOlXWfzsjSTs/s4vbA7b+9oka2SFZQklfVfb8TQ0BdWGvzueimEvYjrBL4EL01zI
xU69u452yzWe3Nx1Dk2CPxLOQPvxTn9CIxlNwwViUlnBzOTJb3LJW0iZUUw1RgRg
XgdiM1DMMhaCl7xw+M0G260xsfpp3LYXqxGniu64iWZrtCTTu/l49frmmDCJIMem
t/wnOl2ylwEJdyWy0yVFHp1tED2YQ674rWZtNI2Kty4pmYOWO8oHZdOBeQChD8Hm
pqM1O+m9EGc=
=CNxe
-----END PGP SIGNATURE-----

--=-3Q+4XiBG9sLlIP+dr/uf--
