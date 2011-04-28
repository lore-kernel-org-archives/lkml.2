Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1D1A5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:57:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36090 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1D1A5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:57:22 -0400
Date: Thu, 28 Apr 2011 10:56:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ux500-core tree
Message-Id: <20110428105634.7a98c094.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Apr_2011_10_56_34_+1000_kOV_.WGjVOvQbJ/z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Apr_2011_10_56_34_+1000_kOV_.WGjVOvQbJ/z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the ux500-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/video/via/via-gpio.c:148: error: 'gpio_config' redeclared as differ=
ent kind of symbol
include/asm-generic/gpio.h:164: note: previous declaration of 'gpio_config'=
 was here

Caused by commit cf451708d300 ("gpio: add a custom configuration
mechanism to gpiolib").

I have used the ux500-core tree from next-20110427 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Apr_2011_10_56_34_+1000_kOV_.WGjVOvQbJ/z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuLtCAAoJEDMEi1NhKgbsq/QH+wU8lM1GMcKpnyKn4ym10lK8
OPfCXiW7ToFFwDYPF/QbXMVWfMKoQnJTh5ZrpNOlkb5KhHB8R1QmKhsg5JsPuuyr
9fAUhHa7Z4iplOpCNCbdK9X1x1OM9bCd+adHPp8oL10PXoIH3M7e/O9zr5lvVptu
+DF3ksMXCZeCjTWW4xq+Wz5tmA01g6WdCBctL5Ldk/krwatZsE+YUgemab4HTudf
siASe+sK4i6UWdvtfpQj1xKa9UtsS28iHFvPmgREABHDl6HdeJ2Qn2doh24TIuth
a1WDpYEC2SENzsdq2Iq6D8ggFlYCmD8RJBDnxfuiYWoMfp5jftHzzizYVVURZIE=
=Pg0x
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Apr_2011_10_56_34_+1000_kOV_.WGjVOvQbJ/z--
