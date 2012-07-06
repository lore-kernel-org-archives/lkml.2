Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2GFEwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:52:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47894 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GFEvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:51:43 -0400
Date: Fri, 6 Jul 2012 14:51:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Wu <josh.wu@atmel.com>, Hong Xu <hong.xu@atmel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the dt-rh tree with the l2-mtd tree
Message-Id: <20120706145131.2d590abbdd53af03f4913846@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_14_51_31_+1000_g3YRwybhKC33w46u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_14_51_31_+1000_g3YRwybhKC33w46u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the dt-rh tree got a conflict in
Documentation/devicetree/bindings/mtd/atmel-nand.txt between commit
348d200508b1 ("mtd: at91: add dt parameters for Atmel PMECC") from the
l2-mtd tree and commit e7e88f9f8aeb ("of: fix a few typos in the binding
documentation") from the dt-rh tree.

The former replaced the text (and fixed the typo) fixed by the latter, so
I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Jul_2012_14_51_31_+1000_g3YRwybhKC33w46u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJP9m7TAAoJEECxmPOUX5FEgXAP+Pyzt/jcqg37jxyV6hZJSXps
vkxx+JL9Gu2bI7BqX1kdwaDlYxBeH5k0F9a+fZfCNP02SOdi9ecaTRTuYNqLA+LN
qgeQZLvD4OjzuQnXg6Q3F+bH4+/Pgal4D86944B5/i7BTz1ye3Zi6c/jq8fspQ25
ZOBPzN31jLK2klYtIBmTkKopNV1/J/qx8sjBBX3z0at6bAUQ5Gvt4AE0Slb18Ts2
sMxL6VuPXIbfQNxejVo4mmdwyRBXR6YwdRrqbdXv/yMCHDLVStYKbK69WtC2lztS
633L9+gsGSLPtt0yhKBzxzNAFB4EuqC+o+v8tnYR5rPmnS3mCdsx4sHRQlZf9YqS
M0mQJJtKVfkuuuDVrRA84FYysxxJzaqxpQ3sC6xDeI6RSuTttBux6glF/buU3mIa
q0UlAIfCjolyNLMsx9yVDxSMeTXRpNGpeqWKRTJLTeLGnfyLexO73JhzpUJ/6ukY
bWFn8sp8XsLHCrvVceWTe322biX7p7qwDFCq9BHkZgkDN0zHT7JiFoGgsaJOYeO5
rj3ve3sdUYlsUmkvBwJx6VqF8VVRvixGy8QbORZ7CHWyze6Xi1tDr/BGQeOc8ORb
AQP//IbhmRG6/lWX1zwHqS7Ae0XzV4oL+G3FRNiJ8qma7ZilDpAmp9sC49IziZR4
QC0QBU6IUSoXYsn2i2o=
=aQ4p
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_14_51_31_+1000_g3YRwybhKC33w46u--
