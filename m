Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0LNEtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:49:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35346 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab0LNEtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:49:43 -0500
Date: Tue, 14 Dec 2010 15:49:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Shen <yong.shen@linaro.org>
Subject: linux-next: build failure after merge of the voltage tree
Message-Id: <20101214154933.a4b36f69.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Dec_2010_15_49_33_+1100_SqMkrBxcI5NaDQ=J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Dec_2010_15_49_33_+1100_SqMkrBxcI5NaDQ=J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

After merging the voltage tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/mc13892-regulator.c:21:21: error: mc13xxx.h: No such file=
 or directory
drivers/regulator/mc13892-regulator.c:261: error: array type has incomplete=
 element type
drivers/regulator/mc13892-regulator.c:262: error: implicit declaration of f=
unction 'MC13xxx_DEFINE'
drivers/regulator/mc13892-regulator.c:262: error: 'MC13892_' undeclared her=
e (not in a function)

and on and on ....

Caused by commit b0e2417cdbc12b1649245315a607ae8f1072b2bf ("regulator:
support PMIC mc13892").  A file missing from the commit, I assume.

I have used the voltage tree form next-20101213 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Dec_2010_15_49_33_+1100_SqMkrBxcI5NaDQ=J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBvddAAoJEDMEi1NhKgbshNAH/1Y0OMWoEeucQkt4XIfeHQHd
rDw+Qkq2c1CWl+eLZsb1iurWcBPTohLiuDTZ0fgf6fdfpE8AFNUQnBK4iMs5oCuh
KLSPsaipv256HLM5u0PU56qELyRJKkfcRvnyJQT3mVoYsR7obsxCQN2lAFjU+9n5
D1ro4wVrf23zAqJSA/IvppoIOzh8qfO1mE+Um8TYCwZTgNLF5KJLTIsaKL9dPlrt
MjSLu/N7klbLOeLWesm1M0a7sgYieTPr/JUr7I0nRuc/glxOJj+EhB9PiHA4o0zd
yq7UqhXCfaz1llOYLVS7hvrU7jQXHM26XbVft5nMcO+ovcK2Ya+x5d5+ut4OAN0=
=jbgF
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Dec_2010_15_49_33_+1100_SqMkrBxcI5NaDQ=J--
