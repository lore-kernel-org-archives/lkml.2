Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0HQCYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:24:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42612 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab0HQCYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:24:09 -0400
Date: Tue, 17 Aug 2010 12:24:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the  tree
Message-Id: <20100817122404.ac35bbdb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Aug_2010_12_24_04_+1000_VSRY0+meTM+=jS.J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Aug_2010_12_24_04_+1000_VSRY0+meTM+=jS.J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/codecs/wm8974.c: In function 'wm8974_probe':
sound/soc/codecs/wm8974.c:610: warning: unused variable 'wm8974'

Introduced by commit af3751a0bfe4d461e0567961dc06448f2128e26f ("ASoC:
Remove unneeded control_data management from Wolfson drivers").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Aug_2010_12_24_04_+1000_VSRY0+meTM+=jS.J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMafLEAAoJEDMEi1NhKgbsBywH/jxEcj5QeTCQXLifzsc+uIQk
gg9J/lZfKgfd140Nls5k32BWGEBihNISmXXmC4MaHA79yKoQQy0CLO5pM6dl96Cl
5wiaqGMkMc6CuLpsxwmpOxY76YBtGFjtWGi5yyRTl+yro9DFbq6M7fwEgauYdIP2
dDCaq9FHU48AhSFGCBiqHIjTRClrCZgOy3a9Gh52gqYOIW1n0BS1l47iaSoFS+4a
pWMZRmtW1z4qZAWS8DScfEF67C62NhC6zHnIbPgQcxBdeuYM0NRRENd7jDbdtV5M
ZLyKQKHOm+9IqbFc/4qU/pHO2KP+ZxCcF6inwIyaiPVcUTsdf0Vtac0y6mmuYtI=
=czg2
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Aug_2010_12_24_04_+1000_VSRY0+meTM+=jS.J--
