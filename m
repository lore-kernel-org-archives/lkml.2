Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2LYLvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:51:43 -0500
Received: from [82.221.99.153] ([82.221.99.153]:51574 "EHLO
	diserzione.investici.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753563Ab2LYLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:51:41 -0500
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 06:51:40 EST
X-DKIM: Sendmail DKIM Filter v2.8.2 diserzione.investici.org 9C304180E65
Date: Tue, 25 Dec 2012 12:30:36 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 20/29] batman-adv: rename random32() to prandom_u32()
Message-ID: <20121225113036.GD2604@ritirata.org>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
 <1356315256-6572-21-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <1356315256-6572-21-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 24, 2012 at 11:14:07AM +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Marek Lindner <lindner_marek@yahoo.de>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Cc: Antonio Quartulli <ordex@autistici.org>
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org

Acked-by: Antonio Quartulli <ordex@autistici.org>

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ2Y5cAAoJEADl0hg6qKeOB2EP/3aLU6Z7GKbCDNYiraQ2bjgs
vLxUt44ZuI86+97VNx3k/yVuRbKI+PqpljIGAcGZJAcl3TD3f0VOkvCQt3rcGy1D
+fS0Mu9h77IpQmWXndg76H0Otto92k1ndnmUGhKHT50X2zIxRHyiBjFAH0Nu5TgM
kFoYWHkLeVbEPMe4sBNsjlY44pGwWXGRvCsrqIOdO0A0T64BwGhJCc4M2IiWW59Z
QqkYEQNur5UZ1KEXFS5hYtTkFkxyxQGXKzDYX51QuEaS2fUZxMy4eFfdGmnLa/U9
/eA8bXAbodj3H+g0ZtV+ozs6le1SQ2rg1ihkCQZqnwCaBe6w01NeMOWQjjp+FIpH
QGWCVfDYeWPktR3mqLdED8w1vp+hVKVGbwRr1bbnJChX12UZrl748uU1xYHh8h+z
WWeS9M2mY4x7tNU//j8aIWvrCZeyDKkP4lJtt6LphwDYc3H+7lYRKm0tBu3YBKKR
I7apadEx7xvC6zI94kZDTGxEnnFs11mHLnc9TpgRSzfEHLwmlrHMduhhMNkWpXpn
5KRDGVmglnWqcR6+U973OHY1qveWucdW9ot7RQi2OGP131oRZa9CGDR8ccwjGDyh
+0KGcFkQiPfevtSd89TbmiOL4MjfqNV93XTaaWCyq7iGChmN+kF6xGTO3hA5nf4j
CzGM8O/iteZJAIOgcbBb
=R0LJ
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
