Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HJAZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:25:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36542 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab1HJAZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:25:38 -0400
Date: Wed, 10 Aug 2011 10:25:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110810102525.484fcdc69b5501ffd4b16928@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Aug_2011_10_25_25_+1000_3krc8R1enFZnBJU="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Aug_2011_10_25_25_+1000_3krc8R1enFZnBJU=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/wm8750.c:785:1: error: '__mod_spi_device_table' aliased to=
 undefined symbol 'wm8750_spi_id'
sound/soc/codecs/wm8750.c:785:1: error: '__mod_spi_device_table' aliased to=
 undefined symbol 'wm8750_spi_id'

Caused by commit 40045a85df0e ("ASoC: Fix SPI driver binding for WM8987").

I have used the sound-asoc tree from next-20110809 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Wed__10_Aug_2011_10_25_25_+1000_3krc8R1enFZnBJU=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQc/1AAoJEDMEi1NhKgbsy9kH/0wgEaxtDdE1vZ8cUw5D0epj
AvqKZZCZ7QkQ0KbQQV5HVEnwP4nmY3Gl5YLZTaH+qsA2QgQbq4yd2eltDMOX4Hod
PLIbOcG//7wqoJ+L9Q9I+Ga3jaY4keI1wSJMoVrFnVuwdwGv93Cyum3nIjaTRulw
bX07GAwIasIMIrfEpP/k5KtE+CCkKAl9WMEGxAH2WseS1F0KAUz/0ZIBhcmjXDbU
bMjdHRVyUd72mDg3tvtk9rFCAbnlO3KYvUzhb/G10qEwxuYt5GGTfE3nTgDCXSom
rEQ5aKQKZzrSgZQ7ICq7Xb/RzxmD53CTdFwy8S/BIJG/LgpusOjK6zQAo7NcVk0=
=KPdQ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Aug_2011_10_25_25_+1000_3krc8R1enFZnBJU=--
