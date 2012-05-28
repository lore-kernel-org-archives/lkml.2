Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2E1DJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:09:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39966 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2E1DJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:09:09 -0400
Date: Mon, 28 May 2012 13:08:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the pinctrl tree with Linus' tree
Message-Id: <20120528130851.10cca27f0d48da3ccd9d9f95@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_May_2012_13_08_51_+1000_APGmlCxUwOGT1Kp8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_May_2012_13_08_51_+1000_APGmlCxUwOGT1Kp8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got conflicts in
Documentation/driver-model/devres.txt, drivers/pinctrl/Kconfig,
drivers/pinctrl/Makefile, and drivers/pinctrl/pinctrl-tegra.c between
various commits from Linus' tree and various commits from the pinctrl
tree.

The root cause of these conflicts is that the pinctrl tree was merged into
other trees that were meregd into Linus' tree (see commit 813a95e5b4fa on
May 23). Somewhere along the line the pinctrl tree was rebased/rewritten
(May 25 or so) and a new commit added to it.  Also there have been more
commits in Linus' tree that affect these files.

<rant>So, if your tree/branch is merged into other trees, DO NOT REBASE
IT.</rant>

I fixed it up (by using the versions of these files from Linus' tree -
and removing the call to pinctrl_remove_gpio_range()) and can carry the
fixes as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_May_2012_13_08_51_+1000_APGmlCxUwOGT1Kp8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPwuxDAAoJEECxmPOUX5FEO5oQAKMHR3x8ImzCBMBq5JhUQXJI
OP0Gi6py3j9baGxOFp/6fo4mqT8/SD4A9p4OC86AhX2lOSRefLAD1EI4woVtImik
vx+OZXfDWDaQh3Zo9Fi8Y7TK9gowym38y7+FhCDGkv5+nLI/MXkK2kjq8WYD6pxo
pVeQB5TRjBRvsO+XRhpB79trmZLeezl4xqhpzJV6MZjo55SCyOm2E8rYPbjz3rjL
a1PBjDGW1RRJyVTTM3XnOW11m2QPsjxsbshrW2+zUfV/5sOTuYEivdsZLdOC0818
UotSTLi/0HcGjuaEgd0ZH+ESOIv8xVXTUcyO23F+NTLWg46N2ILVJr/xQp+AIJoe
EeqtXWEoZNITLP8JJMwTyIHdl/YcLC35fQy6ncC6XKXg9xYJ6YtycZf73V+Bdlq1
A3HZiH4jw4DZ8MQLUBAR4GU7R4+a7RUPhIGQgSXcopZBpkm645GkUjuxzZtsRp6k
BKlFf95DM0LyhX54on8kW7GBkZTLjrCi6p03/VWRljdI6lEabbDIxnRX5cNtqgpI
mAdGf/6gdcHneaLV29Nggch4sqdIj8uwR57ZQV3+z3VTjBEEIgzpgPlDkvXuUwvL
+k+h4jojSHLg94v039s0VEzp5AmkVtNkem7d3YMV8j6PFD5WAa4058ysd1sX4nzX
v7Zicu8CDYhdVYl/YWHh
=WtKr
-----END PGP SIGNATURE-----

--Signature=_Mon__28_May_2012_13_08_51_+1000_APGmlCxUwOGT1Kp8--
