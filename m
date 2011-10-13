Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1JMAPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:15:49 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37422 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1JMAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:15:48 -0400
Date: Thu, 13 Oct 2011 11:15:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111013111517.a5de832adf0fe007cca0945b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_11_15_17_+1100_YUGtrg9BgSZ3y+fl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_11_15_17_+1100_YUGtrg9BgSZ3y+fl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-ep93xx/Makefile.boot between commit 86783a0c544d ("ARM:
7022/1: allow to detect conflicting zreladdrs") from the arm tree and
commit 758ab7e2046d ("ARM: mach-ep93xx: remove mach/memory.h and Kconfig
selection of SDRAM bank") from the arm-soc tree.

The latter commit just emptied the file (without deleteing it), so I did
that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Oct_2011_11_15_17_+1100_YUGtrg9BgSZ3y+fl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOli2VAAoJEECxmPOUX5FEDfIP/A+JaeBKFY8zfDbX1/DPFLXx
EEvQyr+mGl6HY/WPn8oXjaqt7ft24QUAvfc4/cpf7AqrcZKjA5Nj9Q/dFjK1SWwx
YtKH1VFJZHC/VW8Nc+nxnG5nlAwR7cJUHJtf91u79N+sj66eQCpGmc+3t9LIU1LN
YiEX4Y6HuzbJJ31KmmxxOsHeiW3qzkoODMxmMmGMPj3Xwb//wpZuKCoB5J3thyUb
qOj3KxaTwwdXp8jZ1YVBU3XlADa+RGNoGzmgYRzywcjZviG3vlDCclApVWCZG4sO
7V/gCwIbyCLyMCMXo9v9brT2oJMw4EMnGzU9cGX1FZMH98hh6FT4S+ZRVTNYoFQz
eOmpC1wviMH3CQG/ZHr7pWHGX79FTaX4d1d9mTZERklA2vXIaPvWTv0Qv4yHqH4U
Lk0GIDMAbz4Ol716zYTAD4N7c0xRUfiQTBeBMcezumdh/gYg9wPAafb8oQr4TSiX
u3PVAFlSgFJETLG7lrz9ieQF6eWRZKWL7AmDHJOMW7WRIThQCkyAjri3HZfK5xZ2
NWZidnQcXq8Bw3Odc6mRTT/nQKC7DDJCq3Ap/RlvH3cGfgwiFW5hV8gRMblaUaeQ
EfZcg3I7B5DMhAJnR+zIE3tsVRFxl1DBfGPpcekVnX+eE4RCqGL99fYwtrCpYnRd
3f3zTCgmiTWR4PxShtUx
=F619
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_11_15_17_+1100_YUGtrg9BgSZ3y+fl--
