Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1LUBVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:21:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51750 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1LUBU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:20:58 -0500
Date: Wed, 21 Dec 2011 12:20:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkVyaWMgQsOpbmFyZCI=?= <eric@eukrea.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the slave-dma tree with the arm-soc
 tree
Message-Id: <20111221122046.e6b8f4a9eb06015cb4f89d36@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_12_20_46_+1100_bEj_oeRvN4tjQV2Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_12_20_46_+1100_bEj_oeRvN4tjQV2Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/Kconfig between commit eb444fee9289 ("dma: MX3_IPU fix
depends") from the arm-soc tree and commit 8e2d41f8c856 ("dma i.MX:
remove individual SOC dependency") from the slave-dma tree.

The latter seems to be a superset of the former, so I used that
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Dec_2011_12_20_46_+1100_bEj_oeRvN4tjQV2Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8TRuAAoJEECxmPOUX5FEK08QAJ6hdxQsn1BqAFKOKU9DjMVp
C8ftGQKFahnOFuPwJd1RuuY1JWKCBFZvj61Ei22cNiFZEno22BtlDqqI8AKp7HIa
pLMdxPT7CinpGRBXVzMQNmEfbIp5cPbaiLNSEbm5i2StF5eEWa0yrKjKHt7P9+D2
qLySL4jpMsvuD4kCcEam88+1JrwHy/YCAehQfL8J6zoBlMvL3+xEjtH8HZyJXDQm
x50TyPq7m3icTFeMc8Nx4bF4YSCO0pT/3r5mlA8QaqCNjkvX2wPQ/H5y6ZO5EgW3
5alEUVJUP5eibhCYU4ozJsQZ/tn9fwVEEsi9fnluWQKo0HCnf+iLdajMjB/cfiQi
1UQLdAbmjNrVXae/sdF4RGfYT+OKMYvRTkR5O9tE25YbuwDK0OH8jpYwwH6xJA3B
nZNMtevi52fMiruYQ00zR7lwi8/KXzAHMMKja/uCP9EOfXi6wZlnLkF8xO//Lj/s
W2TlIqLHuT0k6MLpOL7yDhDzRoYuLcvlG8Btf+XJ7GnF0mYx28B3TkbqwPB+yTQD
sOPl5Qst/3oii9iOXHHXzxG5k/Vo6skAzlag0COlLHfDVNsJIchH/2di48GJIsHX
i3VPcnvtFyymNIlM/RzmIh5bpYfUa8UyG2JC5kUgwAcyylqJAoV/L7kA2gkyk/i4
O/Zc66QRueOQmwaHr3nO
=1ObF
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_12_20_46_+1100_bEj_oeRvN4tjQV2Z--
