Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1IVBtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:49:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36745 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IVBtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:49:32 -0400
Date: Thu, 22 Sep 2011 11:49:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110922114923.86a2325300e87eeaef151b1a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_11_49_23_+1000_rO/5iovjoJ3ao7hr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_11_49_23_+1000_rO/5iovjoJ3ao7hr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-nuc93x/Makefile.boot between commit 86783a0c544d ("ARM:
7022/1: allow to detect conflicting zreladdrs") from the arm tree and
commit 6adc1e7ff19d ("ARM: mach-nuc93x: delete") from the arm-soc tree.

The latter removes the file that the former updates, so i did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Sep_2011_11_49_23_+1000_rO/5iovjoJ3ao7hr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOepQjAAoJEDMEi1NhKgbsM6UH/jyMR6dF6IgTTOkZMxCREPAm
LuKgEfOHx/69xS0KGC0AxSPnZDvqYToqzQYqBoNqoTVkoz8zTJzwsgiS4mKfX2WB
pZpDF9rHx9HFJkvdlYQBcelPi75NJePPW52wAkFbW9Uoz///Qtzzui1NiZ4YHI4M
HmBMnv1zyBjZr6D6OagsGWOr8dVXqpaHQKtnRwyt22NzdsFo7bnbKm7g/Fu4jBry
odwlJmx2ctg5S+Z6c01IN3HP8n4A1d7KV6u66j6M8voh7EJqcj9KAq12sZLO/VaT
Leg6IJquXCdzMM81yR2Epaet5AE2eIyTfdM2oAFJAgdSjMsXjhKw0yWBupj39pY=
=KK/G
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_11_49_23_+1000_rO/5iovjoJ3ao7hr--
