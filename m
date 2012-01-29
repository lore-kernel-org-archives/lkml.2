Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2A2VHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 16:07:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47591 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2A2VHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 16:07:09 -0500
Date: Mon, 30 Jan 2012 08:06:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: merge of the arm tree into the at91 tree
Message-Id: <20120130080655.4d963134c5b239e09fb65d7f@canb.auug.org.au>
In-Reply-To: <4F2274CA.7020809@atmel.com>
References: <20120127093619.f2c90c6aa8b542134a157956@canb.auug.org.au>
	<4F2274CA.7020809@atmel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__30_Jan_2012_08_06_55_+1100_PfZo=6aLcIj6Sz+7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Jan_2012_08_06_55_+1100_PfZo=6aLcIj6Sz+7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

On Fri, 27 Jan 2012 10:56:26 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> =
wrote:
>
> So, Stephen, can I ask you to remove the at91-next branch from your
> pull list. For the moment we can rely on arm-soc guys to experiment
> our changes in linux-next. It may be simpler for everyone.

Done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__30_Jan_2012_08_06_55_+1100_PfZo=6aLcIj6Sz+7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJbTvAAoJEECxmPOUX5FEX7UQAKW4AupCHWQFie0nBJlF9SxF
vTghBe1bDp71VDQBbljGiXIq00F3N0nicuaMjop7t5BjQNVqL79xC5QmDkj/bZPv
f3cCQCfKtA66ffXzWbu8TauCqBmBJnFP9CYFpyG39IlHZwhi3nSH0IOWiq1YbRcX
TUSNsZbg1Uu56xgbAyPgS0b3aTbQkTMAYoApA3hVROhLkqE6VI3r8NCOSj4Gwe6T
pAXzZDXpHrDOgPw9oui2cIsLnmPSjRPGWdyLdE9X6Znnsixv+T9fknQCinis/93d
W27f+L3kQ55MnfbmCPowR2fY59t2ii9Udbfz5KDOaoZhlDkB0YRYsCXufpQjVeFq
PPUohpMRvTedcEmlRp02wcuZDYua7pfqkr+BQBHK4P8zdaCclcESZh0k3+X/c178
f0uQmX+v+evtnlgfTYDGRPIFtd0ncxG/UdCgGAevOcLH01FsKeWcfwKnWwnfUyoP
KiCtwARaynkaFLeW4RRpsDb3fSMOJKQ7jsQYuwZ+Zfm4SJkZwQz36g0kp6kXo9Cb
Lk5mLNLpy5vLJNZFSD6ST2CCVBs9MDLLpivuUCoDbG6uNsegnmyHrKUFub7rComc
sBn3Wt4XKqBWEskoXT9eOTTtGXm7HcZo3EjeJYYGoiF6SSSZVcJDyaIcsUSMCxRE
aXSyaR/ES6ksQQNX8cGy
=BAiJ
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Jan_2012_08_06_55_+1100_PfZo=6aLcIj6Sz+7--
