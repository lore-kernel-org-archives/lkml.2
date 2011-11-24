Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1KXDLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:11:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34469 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1KXDLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:11:04 -0500
Date: Thu, 24 Nov 2011 14:10:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>,
        Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Subject: linux-next: build failure after merge of the regulator tree
Message-Id: <20111124141046.fdb4b9b923d850b0686924c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_14_10_46_+1100_tR99srbXyEeP1xV."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_14_10_46_+1100_tR99srbXyEeP1xV.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/gpio-regulator.c: In function 'gpio_regulator_probe':
drivers/regulator/gpio-regulator.c:287:8: error: too few arguments to funct=
ion 'regulator_register'
include/linux/regulator/driver.h:215:23: note: declared here


Caused by commit 2c043bcbf287 ("regulator: pass additional of_node to
regulator_register()").

drivers/regulator/gpio-regulator.c was added in commit 3f0292ae8bb1
("regulator: Add driver for gpio-controlled regulators") which was
included in Linus' tree before v3.2-rc1.

I have used the regulator tree from next-20111123 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Nov_2011_14_10_46_+1100_tR99srbXyEeP1xV.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzbW2AAoJEECxmPOUX5FEXJcP/R+2xrhw9aVkB7YeSG2dcSc5
FlXdYp78wksZgX/LyUT1DY6ylNVYDYdglhoEq3Q3yvTKonGZHVEp+mccKmyf3cBr
/lVN6A5EOuyrx7MwIVc1QghfPsup+cEuI1/sgRfh3IxZHviizIEzhVZkCiXLNt/4
H590sXlAlBZ6RV2whMNdkCTNJ/Z6OBmCyAP/Xtvdh+70Lh5IA9aVmqQdvkKYzAJU
oCl86BMiQZ3PcKqVSEuAL0grylYDOPpsQLBj/+dDPegVjv0bn2uk3b4OBI/znDrU
BPdhBrJOLmTxSwmju84PBc4sCFZvjlDJZ/tmGZeoR5WZ94gpqiRvtPEmWUpVQrbh
hgcTmW5GWJNY7y06oWTeLL5wCntIpC+Nsh+LK6KFZVp/Y/LhitDST5nLbLUzBHU7
Tdl3thsRP8D+1yxH0wsLit+WMKLAeeINC6wlUSdpxeBuTsv2pDKQHz0FIPdqOZyV
3sV3D5gY6QqlxuZ0WGXDhoBalsnR5/1KjjvNS3WJqJ762gmfGnd2DTxxrTLlBS/2
mCS3QTPxi1Eo7fjsWM3uNM7hGSt0LAIgOu769sZqkHRKRue3aoYGfPvSVnLT9Jkz
v/3AN+op6JIGOENvrrX1U0UgmMTM5ctoS+IVijRsvx0w4WyX3twYHQgmrnDhzY4T
6dwKeyQPYio4fB5aYjjt
=2iiz
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_14_10_46_+1100_tR99srbXyEeP1xV.--
