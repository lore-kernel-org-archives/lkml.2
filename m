Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1BWCXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:23:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36080 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714Ab1BWCXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:23:30 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Roland Vossen <rvossen@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110222221839.853712243@clark.kroah.org>
References: <20110222221839.853712243@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-IDtKZRlalmsoy2QNxgrs"
Date: Wed, 23 Feb 2011 02:23:07 +0000
Message-ID: <1298427787.2211.498.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [28/70] staging: brcm80211: bugfix for softmac
 crash on multi cpu configurations
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IDtKZRlalmsoy2QNxgrs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-02-22 at 14:17 -0800, Greg KH wrote:
> 2.6.37-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Roland Vossen <rvossen@broadcom.com>
>=20
> commit 6a3be6e6e7feb4cb35275475d6a863b748d59cc3 upstream.

The upstream commit looks completely different; the diffstat is:

 drivers/staging/brcm80211/sys/wl_mac80211.c  |   12 ++++++++++--
 drivers/staging/brcm80211/sys/wlc_mac80211.c |   13 +++++++++++++
 drivers/staging/brcm80211/sys/wlc_pub.h      |    2 ++
 3 files changed, 25 insertions(+), 2 deletions(-)

Why is this so different?

Ben.

[...]
>  drivers/staging/brcm80211/sys/wlc_mac80211.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> --- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
> +++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> @@ -5336,7 +5336,6 @@ wlc_sendpkt_mac80211(wlc_info_t *wlc, vo
>  	fifo =3D prio2fifo[prio];
> =20
>  	ASSERT((uint) PKTHEADROOM(sdu) >=3D TXOFF);
> -	ASSERT(!PKTSHARED(sdu));
>  	ASSERT(!PKTNEXT(sdu));
>  	ASSERT(!PKTLINK(sdu));
>  	ASSERT(fifo < NFIFO);

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-IDtKZRlalmsoy2QNxgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATWRvhee/yOyVhhEJAQoKBBAAz3V4xVKEL8iUoM6EiBXAq3zQrYq8c1Tq
J/4qnTV8dwplpOZAdURIlCiXZi1gXSZ68rhzarIBvgK6ANGyrdg5vw7J1g/xuk2m
8q598ZNLffbZ5wZD0ZUdmGLeZyHswUIwEJsw7qhriIwaCeE4r6cym7ihqZMaabaj
6u63yzh7MhCY8l5aWVfg/hV2PiDTf9q0lYSp94QFGMxbEz4AKrYJUScN0AhWpxpx
jubG4kyJDFjv+J3LSW3MRdQhRmk/YDkWnqUsqXVjKW9lrojs85QhAAMPWLdD5ksE
R1Pb0rHyYxH7K/lQbzXgXLYmYi2wXgA+/tLW1SPXEB45xrcglQxMdHyu+b/ZXdzT
pUJ5NR8eBZf+3js2ShJzl0Ph7dVNFkYctZLFe9mb36dxtjf99BygaE3hxIwV9BF1
4u86XS7HL75UTJO0bB7NPk3ouEy5NbfXXZ95fGTyYYkRQv4WIJ6ikmi2WdKYrr9k
QBlNzhc5xBpGnTcdU1cUv+c4NR+w+wxCCM6QYvCSleElJSNSW4ttFR5p6dOViNP0
NgBlDUQ3CO7o9AqBqTo8ktvF50N4kIRBBoc2QBDqyC7nFK1x39+U7UTGSGRpTzlN
smqFhr9/bxDcBii2X/H0CbNxVp4k5m6QrotHVmSVtA2wWweNX0oczBjjEBD1neE5
3IuF0pv48+g=
=IBka
-----END PGP SIGNATURE-----

--=-IDtKZRlalmsoy2QNxgrs--
