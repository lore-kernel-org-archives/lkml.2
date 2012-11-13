Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2KMJI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:08:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56573 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2KMJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:08:55 -0500
Date: Tue, 13 Nov 2012 20:08:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joachim Eastwood <manabian@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the net-next
 tree
Message-Id: <20121113200845.719276a14b4aa37a3dbdd896@canb.auug.org.au>
In-Reply-To: <CAGhQ9Vx3Y3j0qqkEif09HebFyR+1UYmSbp=3jwuXnoiuWBdymQ@mail.gmail.com>
References: <20121113151536.50d0292e8cb88b10686b576e@canb.auug.org.au>
	<CAGhQ9Vx3Y3j0qqkEif09HebFyR+1UYmSbp=3jwuXnoiuWBdymQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_20_08_45_+1100_5iglaAZHDz8LU0/s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_20_08_45_+1100_5iglaAZHDz8LU0/s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joachim,

On Tue, 13 Nov 2012 08:21:26 +0100 Joachim  Eastwood <manabian@gmail.com> w=
rote:
>
> The platform_data/atmel.h include shouldn't be necessary since the
> driver already includes platform_data/macb.h.
>=20
> Otherwise the fix up looks correct.

Thanks, I have fixed up my fix for tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Nov_2012_20_08_45_+1100_5iglaAZHDz8LU0/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQog4dAAoJEECxmPOUX5FEnScQAIR8YchYwefEd6VHmWuCZNNe
52NfQXEvlP7jjNPTEAmgg+G2Mn7rdXSMsMYgDlwyJsXts1xCucImr+rDbZk7WwKD
931CWA4Y5j2hDfm0iQOGFPxAShxSKCCAhfTdou179HWj4uRZUMBK5VhcuriSTs3I
Lk6hcHCxXSVhKO+qNugPFPjCxNrZeCV2Enpa+2Ok0u910c5QMo2yYc4hFZQB7Q0l
yPE9ljVIO0AJrMTsaDvm2koUDgOp8DAIK1BA9AmU6MxnIT4zjTt/ihDQKnusLKjt
HxqLAjrqVb5M/yE4OE1pWziOGO0VDfuinPGY1OnQGrLbqaNrZBOVJ0OOtZGnU92t
nOnwrtM9xM2rilSNXwrGiT45bUrJ+/unNltbS8/hqo5RryORn12nU3qb1sd1Ksz6
QmYS9cPFT/V/G88newfMVggWgCibgwh92gMbyfI5xI7zQ2o99zkwKD4TB3sW1ACG
rwdFmk0xLxBpWnpli+zt4wY4B1x9PxE9E+1JuCEUJpPwosgqxNEhiua+I2tMIPDP
llbm5/SZrCj/o78qDoyIp48VyZvnFVfe5hsKjo1OmmgO/vgF6sd4Gx76C6Tx3Bxn
nn6qx9wYW65CbuCdauW1FQ/eezY1aZREEqyJ+vZOzbyhT+aktEM8M1bc6WLPAGxY
APeJ+yib1GdXBmYDjZZI
=3pNi
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_20_08_45_+1100_5iglaAZHDz8LU0/s--
