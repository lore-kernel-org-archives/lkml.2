Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab2HQHTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:19:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2HQHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:19:37 -0400
Date: Fri, 17 Aug 2012 09:19:32 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120817071931.GB6003@avionic-0098.adnet.avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
 <20120816111044.GA12029@x1.osrc.amd.com>
 <20120816120541.GA10154@avionic-0098.adnet.avionic-design.de>
 <20120817061102.GA6003@avionic-0098.adnet.avionic-design.de>
 <20120817070042.GA24241@liondog.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20120817070042.GA24241@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DIyHCrClr74nWNAtNF4EQRpVYjDNqhkSVPgquExZU3B
 QyqutQpBNcDdfUgTwvl5CTcEpIBKNEUEpTUcgkPGFyxaYwqD2h
 mefHPENgjx56BMmjY5a6dXE95njDLGtetFZeyIiX3RwxpwJI6v
 o25sqKKJOp8HspN4IROq75AYHLrRdXd/tj5N6rrzxKxf9jqsr4
 4EkKhf9yZFMP6RoGbr1G2MDrXDJW00nZZ21TVIZAIJovd3FQ4w
 L+DPg4NZSLPqadPb1kCVTdIQh9bAoQY9faDtqItB1xFB8w5ZOb
 uVrCK+tOvNBdbfODWukZTYJSYVlCN0oSei/3EBnR/9AMet3NCk
 +lGUjcnon/GTInijt5FG5THG/gx90+DX/yDIpfdx7grOoNKtio
 zxBePM8oftvdckhhoqerKu0aIaKht3zXAw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 09:00:42AM +0200, Borislav Petkov wrote:
> On Fri, Aug 17, 2012 at 08:11:02AM +0200, Thierry Reding wrote:
> > How about the patch below?
> >=20
> > Thierry
>=20
> > From deb6852dc5e9da365a33c744f2dc107ae11b407a Mon Sep 17 00:00:00 2001
> > From: Thierry Reding <thierry.reding@avionic-design.de>
> > Date: Thu, 16 Aug 2012 08:01:21 +0200
> > Subject: [PATCH v2] pwm: Improve Kconfig help text
> >=20
> > The Kconfig help text should help the user understand what functionality
> > is provided by an option. This is especially true for new subsystems. An
> > improved help text is provided by this commit in the hopes of clarifying
> > the usefulness of the PWM framework.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Absolutely! Now even I understand it :-).
>=20
> Acked-by: Borislav Petkov <bp@alien8.de>

Thanks, I'll queue this for 3.6-rc3.

Thierry

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLfCDAAoJEN0jrNd/PrOho4YP/2iIKX4e4U/F1R4d7RmynSGQ
kfhRur4brn0gZ1gWdHnlZVoaBrnYvjFV4yLYCRi4N6Ga8B2VSw5kzTC2UMWA2vwh
scqtLiOv4RIx/xswZaOm4ZRAx7dcbl+Of2IciX9l8mq+0zlKrMIydh03VCtXGKm5
1TUVSXRo5qRQh6ek6MA+sOG6JPgamHRQqosPoZPQcKjZIcpHBS7cTt8k/xOfO32A
5tINZgDDrojrYrSK+hTr0QjWgwMf1BIZoiQSege/ody1rEanYrcH2T+7mSIo7a2D
LVtM7G9SWjtqzul/pGPqnCJEEAJIrI1+HonpC4DcZOaSSqdC8ijBg1/UXdcB8/BN
c0NMoLVpfp9b36+UXylUgQbZqS+jKxr4paHP6GKis0g4roaeGYlJjdMBvnTHTKlQ
u97QC59+g64muLaYJ1gecT8uZJ1QghYnrxgU0ZhSNSW4AVJJdenSiBivU9b+hcdK
LIIzl1ibKiVsw3Oue7EZvBJv1vHR0yBDRUfPSQGOlkXTsQTdFSQfzfIhA5wsuzj8
IxLvYtTBH8ZrZQp+XRaJxQDytBSEqhVQHOsrNZfCoGbyiVlRZXQAi6VjFggdMm4X
42Pdqm89p2Yh8O8o06nuSEHrz4/TBzVdGm8zI7l2mt3O/sYG5zJWLOLkLkZuPg4b
P7n1t5IHJd81uj+I8hI8
=Yuuh
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
