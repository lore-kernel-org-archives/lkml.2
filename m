Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2DEBD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 21:03:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40422 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 21:03:56 -0400
Date: Thu, 5 Apr 2012 11:03:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        M R Swami Reddy <mr.swami.reddy@ti.com>
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20120405110339.4f83ac849d3bce2893c2ccf8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Apr_2012_11_03_39_+1000_30CR2wXHg6I/y8pU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Apr_2012_11_03_39_+1000_30CR2wXHg6I/y8pU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/codecs/lm49453.c: In function 'lm49453_set_dai_fmt':
sound/soc/codecs/lm49453.c:1189:4: warning: overflow in implicit constant c=
onversion [-Woverflow]
sound/soc/codecs/lm49453.c:1193:4: warning: overflow in implicit constant c=
onversion [-Woverflow]
sound/soc/codecs/lm49453.c:1197:4: warning: overflow in implicit constant c=
onversion [-Woverflow]

Introduced by commit dbf7a733f5fb (ASoC: Support TI LM49453 Audio driver"").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Apr_2012_11_03_39_+1000_30CR2wXHg6I/y8pU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPfO9rAAoJEECxmPOUX5FE8X4QAKcZrUI3q9XK3M/8OMc0Om9M
q2DKlmkVPE08CjxK6Xux+H2Wk3Kj4rVrnMQu3vpg7zLxo0qQ9Xm56ijJSABAbDYE
iLLOg1XSS7UvD0xwWIU6EgMXPGzGoAnmkmp1bTsfGMJSDM0LlNZ+PvwqMWUUi1uB
mlxdJ3MhLQbv8/CNMqZgHbzJhHaz3ZsdeXV3SN1Fau/A/akc1lyMr1LSJdhWtYJ8
mocuRrtsSnSBJcES43xkMkjmXOsrOxzfffZW5SSVbTuBbaPqsbNWeV9z3peVccZL
95H5H06C3i5KflQ+XVzLTcQvK+o0NiYTi4t9NKfHn1+dtHqjsZt40EvdRkpt+nna
5fr+SphGlRkdCzh6ff1HN1EKi6ZMFbGHSlU7WJ2l5DBIomtPanmP2vidXsFlFlSw
EDAFoyaxJ4N/0htlZelUuBEaxA1fFbVkxJAoHKIh0OpicVGb2d3hr0hgDGolnNvB
8PnrmvOw9SvY52seRj7Ae5/3q+CcnlRFcYrfNplAyDWOkQ3GK9baCGio2FcpETdS
h0ihkdaJW6smzgr8CBj7lCiGyGRF2bKVMThuGR+a+yrIBpiDMO7v/ACeUOw5CkRG
QElNof66fKhPrWpniPp8AmBNncXEs6s0LMQw3s9xWNngVvUla71slDQfDPVJrYhf
nF8nTAl1rS2WsU4PTRoP
=IWKz
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Apr_2012_11_03_39_+1000_30CR2wXHg6I/y8pU--
