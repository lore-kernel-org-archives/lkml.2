Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1CBONr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:13:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52797 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1CBONq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:13:46 -0500
Date: Thu, 3 Mar 2011 01:13:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: build failure after merge of the arm tree
Message-Id: <20110303011335.7a8dc21a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Mar_2011_01_13_35_+1100_JgXfiWeOzq8By3Xn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Mar_2011_01_13_35_+1100_JgXfiWeOzq8By3Xn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

After merging the final tree, the linux-next 20110228 build (lots of arm
configs) failed like this:

stat: cannot stat `arch/arm/boot/compressed/../Image': No such file or dire=
ctory
gcc-4.4.0-nolibc/arm-linux/bin/arm-linux-ld:--defsym _image_size=3D: syntax=
 error

Presumably caused by commit d239b1dc093d551046a909920b5310c1d1e308c1
("ARM: 6746/1: remove the 4x expansion presumption while decompressing
the kernel").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Mar_2011_01_13_35_+1100_JgXfiWeOzq8By3Xn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNblCPAAoJEDMEi1NhKgbsK08IAJ+e4xHa/imQAzzACKPGWHsU
CBrWsSzK0KydCz+LWk6F75+phIOa+jagaElZBEjZHeipAshZLmKJTU/BmT+jJm/X
bmW8ywo3AjUa73Nhv+oEQWQM/lDGO12qOF4qvaguoH3a1iHHBRiDaHCXS2oAuiqM
B3TgFCePpK+X2fG0VKnprmqgjmqXiPGgj3nmfdL276XT6mCFexBUOSqEAfTD9CiC
4qImG1UuzUv8+MunTwvRZaFPps/Y4HKe87PoHlpOQCtzX94C02TqoufDWbZm0MYr
FdkoTYOC9pwmZA9ZBPR1anrP0N1RGW/HgLfrPKhHSB+l91XDk40HpXEqLkhcFg8=
=HA8c
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Mar_2011_01_13_35_+1100_JgXfiWeOzq8By3Xn--
