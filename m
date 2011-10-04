Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1JDA0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:26:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44570 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1JDA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:26:33 -0400
Date: Tue, 4 Oct 2011 11:26:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, stable@kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: build failure after merge of the arm-soc tree
Message-Id: <20111004112623.aa04e959d29cb19af8053739@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Oct_2011_11_26_23_+1100_94jEW.TRCOVl7FZq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_11_26_23_+1100_94jEW.TRCOVl7FZq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

After merging the arm-soc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "clk_enable" [drivers/misc/atmel_pwm.ko] undefined!
ERROR: "clk_disable" [drivers/misc/atmel_pwm.ko] undefined!
ERROR: "clk_put" [drivers/misc/atmel_pwm.ko] undefined!
ERROR: "clk_get_rate" [drivers/misc/atmel_pwm.ko] undefined!
ERROR: "clk_get" [drivers/misc/atmel_pwm.ko] undefined!

Caused by commit 9dccc010c816 ("ARM: at91: remove dependency for Atmel
PWM driver selector in Kconfig").

I have used the arm-soc tree from next-20110930 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_11_26_23_+1100_94jEW.TRCOVl7FZq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOilKvAAoJEDMEi1NhKgbsE7wH/1dLkcaSOH8ZcEFpqgatXa5n
nBZC02dqTlEnW+KplLla9arD/Bz1jptTNuXWiwQJdQ91CvmYvo5PzFePMVBBMLtg
qAU1sawghdJWA5bgaLL2a/9MdwUY3fZCIQu38nEn48zANrPzO1YJxz9N7TNK7GqW
WuPQIcCKhEhv16Vdfr4SVCLgidpxaw9uZUKFXeZNiMJtxqWo1ug5xLjPMV3GiGkc
eGp3aCjV1x4xbAOUQdUzlfCAjECzWHPIQgqBv9p3P4mo/VVpeQO8tOCJkNV8G86K
JJtoZBNWpVARsNgbWFFw5gJSGVOeTJlYlMoSgcroNtxmtV3HrZoYQ1qUD+Qu/Zk=
=fk28
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_11_26_23_+1100_94jEW.TRCOVl7FZq--
