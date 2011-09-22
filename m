Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1IVIo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:44:29 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46715 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1IVIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:44:26 -0400
Date: Thu, 22 Sep 2011 18:44:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bas Vermeulen <bas.vermeulen@novero.com>
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20110922184418.63db26a381abe00d73eb9c36@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_18_44_18_+1000_tBIbrygFBsaV3AJq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_18_44_18_+1000_tBIbrygFBsaV3AJq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/codecs/88pm860x-codec.c: In function 'pm860x_set_bias_level':
sound/soc/codecs/88pm860x-codec.c:1184:4: error: implicit declaration of fu=
nction 'udelay'

Caused by commit 548aae8cc497 ("ASoC: 88pm860x-codec - reset the codec
correctly") from the sound-asoc tree.  Forgot an include file.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Sep_2011_18_44_18_+1000_tBIbrygFBsaV3AJq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOevViAAoJEDMEi1NhKgbsSY4H/3E5OR8eKJ7l1DzFC46y6WZK
tP4U0Jya0wyP5e7Hi/Oh3gi0cNxRodcSzAvJoMGjbGWYNgl7EgSp5K04f9h3tRNE
5i/srlhvYmxSw+f2i3Uw5yQsPT4Uxy/pR+X/osmhNI+2Fff9T4mfT0uw9YbaTUYy
kkzM9hyoJgKlQDX/xm8fj30W9R5kYXFj3MAbZoLhJ+1HOTl1dl3g81ajedj5bpeH
+bJtjuJ3IQmZbIrE0KDl/nc85XXOoiauXnzloLE4sLpsz1QGSqM1+a3voPOzOwLv
IfX5JYc4bDycNw1+eUMIFZzmZP2Ug0U+WrpBcgLzQKPVkPDjcuqZWvKFgH0isEA=
=uuCA
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_18_44_18_+1000_tBIbrygFBsaV3AJq--
