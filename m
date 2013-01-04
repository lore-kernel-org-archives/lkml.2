Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3ADCN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 21:13:56 -0500
Received: from contumacia.investici.org ([178.255.144.35]:36049 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3ADCNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 21:13:54 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 contumacia.investici.org 3F500E8A55
Date: Fri, 4 Jan 2013 03:12:53 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH -v2 19/26] batman-adv: rename random32() to prandom_u32()
Message-ID: <20130104021252.GE27589@ritirata.org>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
 <1357215562-6288-20-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
In-Reply-To: <1357215562-6288-20-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 03, 2013 at 09:19:15PM +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: Antonio Quartulli <ordex@autistici.org>
> Cc: Marek Lindner <lindner_marek@yahoo.de>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Cc: Antonio Quartulli <ordex@autistici.org>
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---

Hello Akinobu,

as you can see in <201301021952.49979.lindner_marek@yahoo.de>, Marek Lindner
already applied this change onto our tree. You didn't need to resend this p=
atch
to netdev, it will be sent by us through a future pull request.


Thanks a lot.
Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5jqkAAoJEADl0hg6qKeO4/wP/11xG2Bo310vl+gCHHVGJL44
e0vYKg/Jpb89sjXerAhAAUzVodMLCoUz/35W6ix8RJtzCkU7b6PCIe25eZtbfvIW
VLnThzhzwrKaXvbsIgydtqOXaMyhjdytkZho0UAnAn8AT39qv+M4nBvjjFFEvs/T
rFIXz9gz7Q7y0CzHxT/3ITRUvE9x8/8aMGcdMsgOmmo8ELQiHa45/cwumUHutVif
dOnK2sSO1GKVQeWG9LkhbCmjY6A+si/q59A4bIcZAi5v75kNqastbi9fm4/G/LuY
gP+g+MrIle9h/bPnrCvjPNHsUl9qcZuFJQEtpuuOIISbqmMKVM63yWeZ8W7+oVc8
lT2NY+uR2gYG0nk3OM2mi9SWqtyh9cATr2dP6nLMlYIDCw3JwqjDqkz1/8BtaBQB
v5gk29b0XkKQ7znoPQGSnBCzHoq91JNsXhLrvEJH0i7DdYGtzTgvU8E/NLSHib7p
D0EU5j37VbgTZW/Ul6Luds4T+slY5TSU9H0NIoSFNkYQtDxK5kDabys4s63r9WKC
AS8Nv6BRxitTTRl287RL18VZQCDsFAdb+hFgKwF5AL8t8FoKCZjpqOLiKTWj9CRs
cLwIEQc/+RCfouG63YW1boXRH/ck4Lt+KKmhHZWHgdf0Zmk0BNkw9uUZ4jAGrM7e
wh3HZikTXjjjc4RyuL6d
=Mkl9
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
