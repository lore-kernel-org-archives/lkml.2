Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2DDCpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 22:45:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57610 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2DDCo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 22:44:59 -0400
Date: Wed, 4 Apr 2012 12:44:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: linux-next: build failure after merge of the pinctrl tree
Message-Id: <20120404124437.ff05ebcc4db98109d5fcee22@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Apr_2012_12_44_37_+1000_w6N=Ai0_oFhAYyQX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Apr_2012_12_44_37_+1000_w6N=Ai0_oFhAYyQX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/pinctrl/devicetree.c: In function 'dt_free_map':
drivers/pinctrl/devicetree.c:44:42: error: dereferencing pointer to incompl=
ete type
drivers/pinctrl/devicetree.c:45:6: error: dereferencing pointer to incomple=
te type
drivers/pinctrl/devicetree.c: In function 'dt_to_map_one_config':
drivers/pinctrl/devicetree.c:140:21: error: dereferencing pointer to incomp=
lete type
drivers/pinctrl/devicetree.c:141:10: error: dereferencing pointer to incomp=
lete type
drivers/pinctrl/devicetree.c:146:11: error: dereferencing pointer to incomp=
lete type

Caused by commit 23289e6ecc6d ("pinctrl: core device tree mapping table
parsing support").  Missing includes?

I have used the version of the pinctrl tree from next-20120403 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__4_Apr_2012_12_44_37_+1000_w6N=Ai0_oFhAYyQX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPe7WVAAoJEECxmPOUX5FEt1EP/2EK0x04zqioCK/nT5u3x70h
mOgXNiu8vY372sKZs3WuspSTNvdHD7vASKrAhJAc15ZmA67aDa8c1rHpGnICOwNT
haG51oq2C+u6FVii1cVgRCYfLBpLbmlat+7ZoJz41BM3svxYGcW86WMo53KtdztT
W4xxCZAvsNDE46Z+usBPhEFVbLbY7x6tv6ULVyf74ovNsEuuKz/7BNuMiMpj2IKv
5p4F0uVUNWL2wMQPWck3SpbCggyWKkNitHtXZtsV/DY2iM08VXVLqmPqTi30ZU1p
X1OpbahpoDG+k9wZJI+u93Y/6W43BWd5UdPXpsBOdcIc2oiAfqrtSo8sit9IM0OU
iFZL5ZdoMgIWW00ONPCZsIs7x2Mvgdso10H6aLaSdHduy2y39sT0ORPTVco5PD/F
2lwW78xkY8yorZplDXh14QijCct3zQnRo+pdi//KA6Htvbyp8hjgDoiqlsHGsrLs
yZwmbD/Stf6AmEFD/WSS8YTPqYdIzAVhA99ds3N0WRFcn7xUK6/ipF0h+4rCfzLZ
r9XY6wsj6PBtwvndo4w2XXhZIUA9fkm0UEjeXJyEBGXHbrSsqNOvHTuXIcQA6LmV
1rEIMwI/SjnM+Sx6PolQYtprMU2UZESWPGSvKYIEhAoWfObFUG6RsfkCtCNl5im+
eFEtFjMGs9SsRdSVwrER
=mQjp
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Apr_2012_12_44_37_+1000_w6N=Ai0_oFhAYyQX--
