Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab1JLEY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:24:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34579 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1JLEY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:24:57 -0400
Date: Wed, 12 Oct 2011 15:24:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: linux-next: build failure after merge of the gpio tree
Message-Id: <20111012152451.66ce5ddffb4c5b3a4f6a31cf@canb.auug.org.au>
In-Reply-To: <4E93EA10.4030405@dsn.lapis-semi.com>
References: <20111006144826.a69a5ea59d4ca94f8f7414cf@canb.auug.org.au>
	<20111011173714.d54bbcee6c0676ddcc37a1f3@canb.auug.org.au>
	<4E93EA10.4030405@dsn.lapis-semi.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_15_24_51_+1100_ixEDUKGsPJXaxJyD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_15_24_51_+1100_ixEDUKGsPJXaxJyD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 11 Oct 2011 16:02:40 +0900 Tomoya MORINAGA <tomoya-linux@dsn.lapis-=
semi.com> wrote:
>
> (2011/10/11 15:37), Stephen Rothwell wrote:
> >=20
> > On Thu, 6 Oct 2011 14:48:26 +1100 Stephen Rothwell<sfr@canb.auug.org.au=
>  wrote:
> >>
> >> After merging the gpio tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >>
> >> ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
> >> ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
> >> ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefine=
d!
> >> ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefine=
d!
> >>
> >> Presumably caused by commits 54be566317b6 ("gpio-ml-ioh: Support
> >> interrupt function") and 38eb18a6f92d ("gpio-pch: Support interrupt
> >> function").
> >>
> >> I have used the gpio tree from next-20111005 for today.
> >=20
> > I am still getting this build failure.
> >=20
> I built this driver with success using linux-3.0.
> I want to try to build with the same as your build environment.
> Where can I get your environment ?

Just try building gpio-pch and gpio-ml-ioh as modules ...
irq_setup_generic_chip() does not have an EXPORT_SYMBOL (and didn't in
v3.0 either).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Oct_2011_15_24_51_+1100_ixEDUKGsPJXaxJyD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlRaTAAoJEECxmPOUX5FEx/YP/i9jYIDcXmWC6iT0bSejxs4c
izL/T3/yrYNpDIwDcVmaG3fqItK0WuUaTAVGke4eUV5urfsoZfuFeebEHSaJj/kU
OP6jrHwOFEtW/tfz8F3r/nK7FJdM5qzWY0YkwJg1QoEaHm3MsBI+eRmnIEQQt54T
GUHzZri9zWIEHJ1hE5zaq/x65PDl9t9LxCDnwplKFwD8XmBJBbb5bps6WCSAlAwT
loQ4Vv0vOoC+Bi/W4DgpmcjDzO3O2+qdKEvzvJz0cT17Uhs+JNdhk+HWXpL6ov3w
RF/+2fJHDxkwG1aRix+oIGcM95l7BCeh/mI/6cgLOXZL0wr/6E9Pv211LoeE+pPT
EhSJHMBy6h42WL6Y9J4lSsfRWW7syBd/IrgnsY1j5njyyADzBOdhYjH5V0rZw7U9
3+3OedljunGbBL7LGkuxjfr79E223gnm4FlyApbVk/OUnb20HA/jbyL/YYdIhmXe
JCw7Wtsf7le3IgHkQO3iZfAl2VZhUBcQbZbewtuMZ4jPy1zHtaJGHgJ6zC6PL4dU
a9A91UQfMRCHfTq2IegDj6fdeTGa9j49pSYAaHli2Nnl1x3kCLR1sYm+7i4l3i13
APQAqBiGlVIXzbK0poUjesLftS++y7xj7HVaqZxmcdPDftK6EIR7mPVkG2sFcXry
vnFfE0rlS7gHz21B9h/m
=8EUU
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_15_24_51_+1100_ixEDUKGsPJXaxJyD--
