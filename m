Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0JRD3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:29:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0JRD3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:29:49 -0400
Date: Mon, 18 Oct 2010 14:29:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_14_29_34_+1100_5nahqLDohn=RUHBf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_14_29_34_+1100_5nahqLDohn=RUHBf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/max98088.c:28:28: error: sound/max98088.h: No such file or=
 directory
sound/soc/codecs/max98088.c: In function 'max98088_setup_eq1':
sound/soc/codecs/max98088.c:1712: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1713: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1714: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1716: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1720: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1720: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1728: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1730: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1731: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1732: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1733: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1734: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c: In function 'max98088_setup_eq2':
sound/soc/codecs/max98088.c:1759: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1760: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1761: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1763: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1767: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1767: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1775: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1777: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1778: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1779: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1780: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1781: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c: In function 'max98088_put_eq_enum':
sound/soc/codecs/max98088.c:1800: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c: In function 'max98088_handle_eq_pdata':
sound/soc/codecs/max98088.c:1851: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1852: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1861: error: invalid use of undefined type 'str=
uct max98088_eq_cfg'
sound/soc/codecs/max98088.c:1861: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1876: error: invalid use of undefined type 'str=
uct max98088_eq_cfg'
sound/soc/codecs/max98088.c:1876: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c: In function 'max98088_handle_pdata':
sound/soc/codecs/max98088.c:1902: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1905: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1913: error: dereferencing pointer to incomplet=
e type
sound/soc/codecs/max98088.c:1918: error: dereferencing pointer to incomplet=
e type

Caused by commit e65d255a5a610ce9e185e0df855250706aca7c21 ("ASoC: Add
max98088 CODEC driver").

Please, please build test what you are submitting.

I have used the sound-asoc tree from next-20101015 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_14_29_34_+1100_5nahqLDohn=RUHBf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu78eAAoJEDMEi1NhKgbsvqwH/RV9iGDVBDvyh6itrL9zfn6E
Njyyc5V1e/yQuoxDmpTSNU/i/KU5dyr98ZitJqX0NZrYXjfWdAjnQegTHa6BQvPh
e9OTgO82MT3NnFFUccVOgLZa37YH9AzFzeR3C7FMC0loBjTvSgZE0aEYERoOt7fI
yaM4Hn2DcH8wNvwjkAN0vGHh8jxUhsGFisEAD/80eWMoLvJkbu0Yt2XAc/4wiUAV
Dt1BtPJxPMC33gemmHgXmVYSDrVjrw9yW7iUx+7MlZen/5QeQGK9zR4rcrifnmew
32AaktegQ21hk0u0SJFg46cIckbEFAuuwtoGNesK3fkCal2r7U87Dg0pSdXl8NM=
=NGLO
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_14_29_34_+1100_5nahqLDohn=RUHBf--
