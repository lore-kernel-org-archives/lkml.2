Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0HaD6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 23:58:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34619 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab0HaD6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 23:58:37 -0400
Date: Tue, 31 Aug 2010 13:58:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: linux-next: build warning after merge of the net tree
Message-Id: <20100831135831.b0f124c4.sfr@canb.auug.org.au>
In-Reply-To: <1283224474.1759.30.camel@Joe-Laptop>
References: <20100706142542.d723903f.sfr@canb.auug.org.au>
	<20100831125738.7f18610b.sfr@canb.auug.org.au>
	<1283224474.1759.30.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__31_Aug_2010_13_58_31_+1000_2W69EdEeM.GBNXUd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Aug_2010_13_58_31_+1000_2W69EdEeM.GBNXUd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Mon, 30 Aug 2010 20:14:34 -0700 Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2010-08-31 at 12:57 +1000, Stephen Rothwell wrote:
> > On Tue, 6 Jul 2010 14:25:42 +1000 Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> > > After merging the net tree, today's linux-next build (powerpc
> > > ppc64_defconfig) produced these warnings:
> > > drivers/scsi/sym53c8xx_2/sym_hipd.c: In function 'sym_print_msg':
> []
> > > Introduced by commit 99bcf217183e02ebae46373896fba7f12d588001 ("devic=
e.h
> > > drivers/base/core.c Convert dev_<level> logging macros to functions").
> > Can we have a fix for these please?  They make too much noise in the bu=
ilds.
>=20
> Submitted July 7
>=20
> https://patchwork.kernel.org/patch/111271/

Yes, but there were comments on that and nothing since.  I think that
James would like a minimal patch that just fixes the newly introduced
warnings.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__31_Aug_2010_13_58_31_+1000_2W69EdEeM.GBNXUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMfH3nAAoJEDMEi1NhKgbst/EH/jeEhrhMKdGcEvgjPcW91yoQ
suCxG5hOoLe0K27ReBYMsK/JMV/kaROmERrLadl+KEjhHNpY8oWyoLgQzC44fEmf
DVG/ciaK3MmthxTptssxe0IVAGv/t+QkoJITaVz2QGfMYpOlej8ODr+i5GNsHbgP
LaRUvgVSHHF1KeMDv0+0sBkE3S792Ggc9Xeq8eTTc+g3VlFA2OOHer7dY0mg0KOX
GDCulTtDJuNF5VgTwypGgcs/ak56UyNdq9+7e4Kq17caL18eTstcs8PtBdlzBFhU
LYEIS5Lwz0NYgIty3C6ORL/3vTlu86RfuD9pFJeXS5xw7IwPqR/tp2IqU8JzZpA=
=lBnr
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Aug_2010_13_58_31_+1000_2W69EdEeM.GBNXUd--
