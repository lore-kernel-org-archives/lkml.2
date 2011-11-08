Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1KHVv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:51:59 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:32823 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1KHVv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:51:57 -0500
Date: Wed, 9 Nov 2011 08:51:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>
Subject: Re: HSI framework for linux-next
Message-Id: <20111109085140.908f89d0e2b8160cc959d67c@canb.auug.org.au>
In-Reply-To: <1319794066.28874.22.camel@groo>
References: <1319794066.28874.22.camel@groo>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_08_51_40_+1100_BlUvxPXo0PhUn6A2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_08_51_40_+1100_BlUvxPXo0PhUn6A2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Carlos,

On Fri, 28 Oct 2011 12:27:46 +0300 Carlos Chinea <carlos.chinea@nokia.com> =
wrote:
>
> I have been working in an HSI framework for linux:
>=20
> https://lkml.org/lkml/2011/6/10/280
>=20
> The framework is in good shape and is currently being used for some
> people so we would like it to see it integrated, if possible, for 3.3
>=20
> Latest discussion for integration:
> https://lkml.org/lkml/2011/10/20/177
>=20
> Therefore, could you add the following tree to linux-next ?=20
> 	git@gitorious.org:kernel-hsi/kernel-hsi.git for-next
>=20
> Currently the framework does not have any HSI/SSI controller driver, but
> myself I am working on an SSI OMAP one, which needs some changes to get
> full acceptance. So hopefully I will have the changes done and acked on
> time.
> There are also other people preparing their controllers for integration
> (see the integration discussion)

Right, so -rc1 has been released so I can consider this.  Just a couple of =
things:

	Linus (and the rest of us) is being a bit nmore paranoid about
where to fetch trees from.  Public git hosters (like gitorious) can be
problematic since it is hard for us to verify the owners of trees
reliably.  You either need to apply for a kernel.org account, or you will
need to add a signed tag to your tree before asking Linus to pull from
it.  And that atg will have to be singned with a GPG key that can be
verified by Linus ...

	I am not sure how to translate that gitorious URI above into a
simple, publically fetchable URI (git://gitorious.org...).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Nov_2011_08_51_40_+1100_BlUvxPXo0PhUn6A2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuaRsAAoJEECxmPOUX5FEH28P/3QXJgKwfLjKLOITZKNv6Gya
dAir4rs5TSb6IJlxjxjJSyY7fDkaK/ees1y9ptCEVyvWTSegGaVWSHzrqp4+fb1l
66ew0UwFAph6FRVgCswAXOQTDlAUL2Eny4xebjBYlkefZUJCjy1vG0hz92jeEcKt
+aVA9OUVRhBH5Wtf11o8yyCGESyaNMG702uKBXujj4E0dEN8TtonE8zE6Nojcwkg
cIGo1eSdc1b3HedLhqDB1DavBjvA/w3SqcDtSA3NR7VmmvlWe+3WxQjpFBPt1H3I
PGbAseq1T56lUCrijxPyz3ESS/MF9hRfiUYhL/UBhOHwneEW/PN77EpRiiHSSO15
PabNmmKJBPaxusj/quF7NxV7s5F+qG2AjY8WpE7jGy07kJG5O02T84qGQBGiTasa
PvoiTJ/vKZwOUdkBDlHcSEAqosJ912GI7mfLyr8LsLZt1Ws7YmHPLvrZqWnyRuhG
nbYg0ioYgP0dBWD8ghwbpRv5U4KxKfDIdiXXyKDc6dCmemHbEpTtUyZi8Yvl/auh
ek/rGRUWN2gHBXRjCvgC9WM+1qtGzZK3fUERULzQtabYa1KU4lX86v7Cdt2kQTcg
wKjDQXsTkAMIisByirNNyGHDMM805//tECkSWLn/3lyOqSejmwBPRn4Bcs5UV5PJ
WVW7j16VifjWUrpUAcxU
=TpD1
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_08_51_40_+1100_BlUvxPXo0PhUn6A2--
