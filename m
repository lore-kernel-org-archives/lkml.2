Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2ENIbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:31:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45699 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2ENIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:31:44 -0400
Date: Mon, 14 May 2012 18:31:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: linux-next: manual merge of the gpio tree with Linus' tree
Message-Id: <20120514183133.e5b44bd8f61cd6bd6805fff4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_18_31_33_+1000_c2W6jm=bxxmD3WFR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_18_31_33_+1000_c2W6jm=bxxmD3WFR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/gpio-samsung.c between commit 2760f7adbb6c ("gpio/exynos:
Fix compiler warnings when non-exynos machines are selected") from Linus'
tree and commit fd454997d687 ("gpio: samsung: refactor gpiolib init for
exynos4/5") from the gpio tree.

I used the version from the gpio tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_18_31_33_+1000_c2W6jm=bxxmD3WFR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMLlAAoJEECxmPOUX5FE3moP/jRbNJIjv8CfQfAO8LcKRSxW
qz9utAiSXbM9fCApjhdThoeI4dVa+WeTX4OfHxKA7fqiWUKALzS8uO0590OblWBE
SRFsf4SVAdP4W/YY3VHd5RT82ySdIlvP5ExBYtVSIiDhqElBp8m9iIycZyLiJ0G1
9DQVxyvP97jLCy90CQimGix2d4X/Lp8IpGZh3MCO4A1GDOZ20x/FJIN939KTU3fm
EcYb8NjUXXr1Nlu65TkLtdlrbWXIDhY7YNOWxkdzRzbWqDbbKniZKZoX8a6oIOBU
oLb+CJnlX+dWMwaY5Aq4MST5rGdil9Zt/asykkXFkS8k/fJs8gR+LDtpkJhnQwZT
af9+ulGXNiIYPBKqUEWoGY57fQ1JVLK2i27A7SlYINZbNzvKg1W/RoqCv8Hr6O0m
qc1boHFpneEWc7DBiD8Jfaz/9heuCAHjnOMy3fjeNhHx0g0JaHM7SV7iohdgHfqa
rP9m8sOU/F0yc+2Pg7k/QAADLAs4T0KIZtcYD4kMuptiIN19kRUyL7kscuRj5lut
r+pJjpyAbF9WfE+6aVyO28j9MpBCif8sMb/KVscmlr877U610fvZxKgS/BBlEGCv
D1pOVVJOX5gcIiZIQKUCQDm9fqMR03tT9ctTC+WZBd7/W4LwlAcvGbSXFxwHcCEB
7CnnCtsMQQf1qSsRiGUE
=zkRZ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_18_31_33_+1000_c2W6jm=bxxmD3WFR--
