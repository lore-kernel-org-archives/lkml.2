Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab2FULEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:04:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38424 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2FULE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:04:28 -0400
Date: Thu, 21 Jun 2012 21:04:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, "Girdwood, Liam" <lrg@ti.com>,
        axel.lin@gmail.com, Alberto Panizzo <alberto@amarulasolutions.com>,
        Jingoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: build failure after merge of the regulator tree
Message-Id: <20120621210412.72321b3ff43d50930b17f760@canb.auug.org.au>
In-Reply-To: <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
	<A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
	<CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Jun_2012_21_04_12_+1000__8PMDz3vER=Ho=if"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jun_2012_21_04_12_+1000__8PMDz3vER=Ho=if
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 21 Jun 2012 16:20:46 +0800 Axel Lin <axel.lin@gmail.com> wrote:
>
> 2012/6/21 Kim, Milo <Milo.Kim@ti.com>:
> >> Caused by commit 809d310c7e69 ("regulator: lp872x: Don't allow modular
> >> build") but that was done to fix a different build problem.
> >
> > Sorry for this conflict.
> >
> > Build config of lp872x driver has been changed as tristate.
> > And related undefined symbol error has been fixed.
> > (don't use devm_gpio_request_one() at this moment because it can not be=
 exported.)
>=20
> I don't think this is the good way, other drivers may have this build pro=
blem.
> I think we can fix it by having the patch exporting
> devm_gpio_request_one upstrem ASAP.
>=20
> BTW, In yesterday's linux-next tree, Andrew has below commit.
>=20
> commit a291ede7be8359a8986740b11b93f9c80e40210b
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Wed Jun 20 09:55:47 2012 +1000
>=20
>     backlight-l4f00242t03-use-devm_gpio_request_one-fix
>=20
>     export devm_gpio_request_one() to modules
>=20
>     Cc: Alberto Panizzo <alberto@amarulasolutions.com>
>     Cc: Jingoo Han <jg1.han@samsung.com>
>     Cc: Richard Purdie <rpurdie@rpsys.net>
>     Cc: Grant Likely <grant.likely@secretlab.ca>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This export is needed for a patch in the regulator tree, so can we have
that patch sent to Linus ASAP, please?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Jun_2012_21_04_12_+1000__8PMDz3vER=Ho=if
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4v+sAAoJEECxmPOUX5FEY0UP/2i7yGqhpUKaw79t6rwMDzxe
HNgnGc5YHej/Gl2nGeHbuTnyMNtxinRGFtCpZ0ihYR4Q+2qpaJJd9JyYAkE4jWsp
ve6k720oTx/ItSSZbaMMWLkFCQQC3RW3stXLGfNdCmkKJkfsir2Pfw5n7+6pSv6C
Sii9gARSpowH7BupXlR4iUCs5F8ycbIrTP8PVC9eJLI093c4HlO7tljO/i0trLf+
D3NDogxo2u1dBWG/bk1qClni1SaD956o75oYYuq1mCNSJUdFlzHoAnrQVm85EILK
Q87KwIRxW39Tk1bONVMxYzY2O6QVc/i3aw4RAkM6n4PM4OvnAf5nZEgzkXDwU8WI
Gbc2ukEjUcYbgvmvVttN6TYzJgJgEXtDDiSOIG5YTY5CC5knBUiyATk2j3H7tcsX
JtPBIryrPUVQSkU94HLXNDcsC4kzzoC6SRM2zUPCK+bF8/g2XUiDKoknbUxViB/o
lcYQuEubu/aOYKem35bu5QVSDwV3bM+e66xqzUm8l5PLpAOFMcRQ+kfjlL38jqfJ
zxC9qW3N1jFhm7vBM4HQuZU12OaxlluR3O/xH5tE8VkgivNQ27ZwuamYxorkz16y
7JzE/QFDTKdFoFeRgbkvbahsDrfV6y14srQ2hQ8ASunQcfHqoPyJAWIhKBLTIxpB
1sWFlWdX+htUkSZIZqQS
=Q1VS
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jun_2012_21_04_12_+1000__8PMDz3vER=Ho=if--
