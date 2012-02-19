Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2BSA62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 19:58:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39517 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874Ab2BSA61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 19:58:27 -0500
Message-ID: <1329613104.3258.44.camel@deadeye>
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
From: Ben Hutchings <ben@decadent.org.uk>
To: Divy Le Ray <divy@chelsio.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 19 Feb 2012 00:58:24 +0000
In-Reply-To: <4F3EAAE3.5070705@chelsio.com>
References: <4F35DB79.6070104@chelsio.com>
	  <20120211140701.GA5194@neilslaptop.think-freely.org>
	  <4F38A526.70900@chelsio.com> <4F3CADB7.1030802@chelsio.com>
	 <1329450094.3258.34.camel@deadeye> <4F3EAAE3.5070705@chelsio.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-i+jx8fCyh9SCY/3QY0nR"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i+jx8fCyh9SCY/3QY0nR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-17 at 11:30 -0800, Divy Le Ray wrote:
> On 2/16/2012 7:41 PM, Ben Hutchings wrote:
> > On Wed, 2012-02-15 at 23:18 -0800, Divy Le Ray wrote:
> > [...]
> >> The following changes since commit 38118a598df73d5a9fd72bf04910e8298db=
82a46:
> >>
> >>     linux-firmware: brcm: add firmware for bcm43236 usb device
> >> (2012-02-11 19:20:10 +0000)
> >>
> >> are available in the git repository at:
> >>     git://git.chelsio.net/pub/git/linux-firmware for-upstream
> >>
> >> Divy Le Ray (3):
> >>         linux-firmware: rename t4fw.bin
> >>         linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 drive=
r.
> >>         linux-firmware: update cxgb3 driver firmware to revision 7.12.=
0
> >>
> >>    WHENCE                  |    4 +++-
> >>    cxgb3/t3fw-7.12.0.bin   |  Bin 0 ->  31812 bytes
> >>    cxgb4/t4fw-1.3.10.0.bin |  Bin 0 ->  241664 bytes
> >>    cxgb4/t4fw-1.4.16.0.bin |  Bin 0 ->  298496 bytes
> >>    cxgb4/t4fw.bin          |  Bin 241664 ->  17 bytes
> >>    5 files changed, 3 insertions(+), 1 deletions(-)
> >>    create mode 100755 cxgb3/t3fw-7.12.0.bin
> >>    create mode 100644 cxgb4/t4fw-1.3.10.0.bin
> >>    create mode 100644 cxgb4/t4fw-1.4.16.0.bin
> >>    mode change 100644 =3D>  120000 cxgb4/t4fw.bin
> > Are there any versions of the cxgb4 driver that will specifically
> > request cxgb4/t4fw-1.3.10.0.bin?  If not, what's the point of keeping i=
t
> > around after changing the cxgb4/t4fw.bin symlink?
>=20
> Hi Ben,
>=20
> I originally removed cxgb4/t4fw-1.3.10.0.bin when I posted the request=
=20
> against David's tree.
> Subsequent review from Neil requested to keep it around at least for a=
=20
> while (https://lkml.org/lkml/2012/2/11/61).
> Either way is fine to me.

No, Neil said you need to maintain cxgb4/t4fw.bin, but it's perfectly
fine for that to be a symlink.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-i+jx8fCyh9SCY/3QY0nR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT0BJMOe/yOyVhhEJAQpjIw/9HuCjIByTnQ0xnEU3BFw2iBm7+egWfHSE
mcpvrlGJPbdKWyQBmC3rMWOeU2/wrKzwlYEmr3jFcfSvt3Tabj8zVWXhjG6hPCFm
czFuKZgqMCJxyxnruB9bxnJkN2v+9V8PHlt0Vo97+PqmMyG2CvP1ycPVKuoGpVex
Zw77hOzLtrt+zAOVjFY1kL3QdivV/H90GT/KwDwYFXmw+a8Ry0/m6g3OKgAc/hQ5
biTVbb4Fer4ygepDFMiJewrWRyrhEz/o0ngdDrwI4iEEOwZe3ulydQcsjUiCXrAk
eD5In8HSqTigEQllwq12bWHt8u3jRvFpDcJ+OT6D6pSxrYrZmyB1crwp7vT5SAR3
DEMzcgWrLEIWYruj8JX+2YYieKuz5JOyD1by0K6D7M+tEIOod2aaIx6a/pLIumaq
9HvlIQwXoabmhoQyJzB9/HpL5m93DqTqXzfN07zt3/bDy65KfwzKjaAvUYp3uIao
9NKUF2WwDFiW1m5/HwHol2d3PyaI3xsLh0wn+fjawNEGdc4o6JLB8Hw4Tzikx7Sa
VUak46IDWq+pNXH8udjDPzFUH4kAAC7vWeFTit5eHOFyeXAs6yUqHmlsviqMsjj+
nX2QAgTojabMhANeO1Xzgvw/yiXUKfeGP/QYvrztD15pCrs4k/BDUFZZ9az/V0bq
0C2q/NHKVuc=
=UjWb
-----END PGP SIGNATURE-----

--=-i+jx8fCyh9SCY/3QY0nR--
