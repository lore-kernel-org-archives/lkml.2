Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2AWBOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 20:14:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38954 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2AWBOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 20:14:39 -0500
Date: Mon, 23 Jan 2012 12:14:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120123121422.f3e41d97bae580544abfab63@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jan_2012_12_14_22_+1100_.X2jDET9o4bSnZJO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jan_2012_12_14_22_+1100_.X2jDET9o4bSnZJO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/sgtl5000.c:1398:18: error: 'sgtl500_dapm_widgets' undeclar=
ed here (not in a function)
sound/soc/codecs/sgtl5000.c:1399:22: error: negative width in bit-field '<a=
nonymous>'
sound/soc/codecs/sgtl5000.c:1400:17: error: 'sgtl500_dapm_routes' undeclare=
d here (not in a function)
sound/soc/codecs/sgtl5000.c:1401:21: error: negative width in bit-field '<a=
nonymous>'

Caused by commit 899896379670 ("ASoC: sgtl5000: Convert to table based
DAPM and control init").  Please at least build this stuff :-(

I have used the sound-asoc tree from next-20120120 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Jan_2012_12_14_22_+1100_.X2jDET9o4bSnZJO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHLRuAAoJEECxmPOUX5FEQMgQAKNiEm/IzhBFVaG5XSjsJ4ka
o2sa0q7W065YAK9PJaEgVdWF96iu7TeuIWp5d0ZwVQbF+vtB74hdxhbXK8iMOtG/
2PcBhNmylQD4oibffPq9UZj9TJBN40oIn6lL+8rFBcfuKnLLFRL4ZebNjNagscaR
PRh4OJQJKnwPvCrC0b6Dbl98sA/3EMjLJG1lvDeY7dgjYUHLWcIC9YKF+cfXDn3B
0fh9RsQ91c5ely6SiHkUMufL47rWf7O0CBB2kI7LwZaI2n0SfeWcsaihYvxbuMOO
fC6aOvh4E92IJqyIefTXykbni3pPgQjYm6LwokYABqfOCcYQvgG0Lt7vOnoItwDj
vUGSav+HO5nVpDycXJeKHV24VHy3cJYgpP7bLFDHuwUmcswoHUeilVcgf6aVDoXm
IL+gJOyLwlP0hnjkwPJkplMdq3xovC+Bcv4fzC9WD/gshZ10WGOReCM9vt2Vwdzb
NaVIyOwjWnnzW3g2ywlKhrJt2K7FmdTX4IHoD6dT7ep+h/gZVo7N7C7B1mrWGWJ+
apbvR+KYsR//7l2TTJ3E/np7oezwSn+TAfxINHkMFD5h+SX2ovkOkalBwA+4hEkV
Fx74VIWz4oB5g93jJJ1PZCSOZXPCtpVhkUq2dzMb5E/zouXnvUHugVHL5Q0eiGrc
y/PacUp6REeY0zdy74X8
=Jx4x
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jan_2012_12_14_22_+1100_.X2jDET9o4bSnZJO--
