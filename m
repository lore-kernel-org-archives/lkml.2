Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628Ab0HFFRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:17:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39806 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934486Ab0HFFR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:17:28 -0400
Date: Fri, 6 Aug 2010 15:17:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20100806151719.b4b58107.sfr@canb.auug.org.au>
In-Reply-To: <006b01cb3520$869ca6f0$93d5f4d0$%kim@samsung.com>
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
	<20100806102419.3e875933.sfr@canb.auug.org.au>
	<004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
	<20100806114314.6d15d4fb.sfr@canb.auug.org.au>
	<006b01cb3520$869ca6f0$93d5f4d0$%kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Aug_2010_15_17_19_+1000_S1tAeL/I21Ivj4PC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Aug_2010_15_17_19_+1000_S1tAeL/I21Ivj4PC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 06 Aug 2010 13:33:27 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> I will merge Dmitry's merge commit that you inform to me in my tree.
> Then, conflict may be not happened tomorrow. :-)

OK.  Thanks.

> I wonder...as you know, my tree will going to upstream through Russell's
> tree...if his tree doesn't having it, is it no problem when he merges my
> tree?
> I mean, is it no problem that there are Dmitry's stuff which has been mer=
ged
> into Linus' in my tree when I'm sending 'pull request' to Russell?

It should cause no problem to Russell or Linus - git is good at ignoring
common subtrees when merging.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Aug_2010_15_17_19_+1000_S1tAeL/I21Ivj4PC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMW5rfAAoJEDMEi1NhKgbsLfsH/1c5846LcsOquuqZvoMp61uj
65m2NdiuPz6rMCg9aNvLXnfrrs/XuWWcvCxuyoi1X9eGnOxseR02ZFj8Ea3t8npY
lhV/OdVKxAoKHpdbeQlKBheTMurQbdLq0oc7Od0p5p8oE8snBWnQ3DE3NQvn0YVV
jEdD71U34WERveBouR0GI2aF+agGhAD7XyCV8xuWXXIEeAkKbd4bHYLhzyelq/89
90DlSu1xqt5JpfBmDDos879fAeuOEJcBO+QzwH4aVkY6Tr9sUcFaKJvtDFxc5VeF
DyK6O4iM+fvTyNXR6YaHGjOUQ8inym4GkaxS9Cby/U8LoMRr+AnxjHi24urQA+M=
=WH1p
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Aug_2010_15_17_19_+1000_S1tAeL/I21Ivj4PC--
