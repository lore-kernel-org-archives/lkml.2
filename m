Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1FGBzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:55:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53610 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab1FGBzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:55:17 -0400
Date: Tue, 7 Jun 2011 11:55:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lars-Peter Clausen" <lars@metafoo.de>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110607115505.71c9a330.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jun_2011_11_55_05_+1000_L9jwzeJl3nkGkRTU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jun_2011_11_55_05_+1000_L9jwzeJl3nkGkRTU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/ad1836.c:130:2: error: 'AD183X_ADC_CTRL1' undeclared here =
(not in a function)

Caused by commit f97d0c6d5f94 ("ASoC: AD1836: Add input gain control for
ADC2").

I have used the sound-asoc tree from next-20110606 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Jun_2011_11_55_05_+1000_L9jwzeJl3nkGkRTU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7YT5AAoJEDMEi1NhKgbsjjwH/0ozpjnraPKnoNQJAiusmW7Q
2SMZQOvXZF4xbIbErpslXQ4yhKlsa4ixSTCV8hkpiIv6r90HvPvMnfzKqeKgSfAA
m0UrDeY/Tc83nzZXiRlnYUAKhQpstjtstwCbuNNlSJkQG1Cchp0T5vUcSBw5jF9h
dCzKw0g3KOjtml2RlL3HoBpqR3AigHKWzIC881Gdwf4c6BIBNuw1PbclChYanxD9
wAw2k8aMYDOUvpx1SiiUhwXJp8KwJ1BhBo0pS5zJGF1C6mfNI5yhSktipm5FPeYw
G60/i2jtjo1GJaLZkU2Wiy8wq4YsHSri1RrQxZooZUm2TKKWYwBSHEUBOqrX3bo=
=f0Kq
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jun_2011_11_55_05_+1000_L9jwzeJl3nkGkRTU--
