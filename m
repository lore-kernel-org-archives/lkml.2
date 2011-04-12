Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1DLWjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:39:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44144 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1DLWjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:39:08 -0400
Date: Wed, 13 Apr 2011 08:38:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Baruch Siach <baruch@tkos.co.il>, linux-i2c@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next reresend] i2c: designware-pcidrv depends on PCI
Message-Id: <20110413083855.c37ddadc.sfr@canb.auug.org.au>
In-Reply-To: <20110412114722.0f2e67d6@endymion.delvare>
References: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com>
	<BANLkTikX_rG+6Eg4owary1YRGRG8NzyrGQ@mail.gmail.com>
	<20110412114722.0f2e67d6@endymion.delvare>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Apr_2011_08_38_55_+1000_nTU98=yaV8/OtFn="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Apr_2011_08_38_55_+1000_nTU98=yaV8/OtFn=
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean, Ben,

On Tue, 12 Apr 2011 11:47:22 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> On Sat, 9 Apr 2011 13:34:49 +0200, Geert Uytterhoeven wrote:
> > On Fri, Apr 8, 2011 at 17:32, Randy Dunlap <randy.dunlap@oracle.com> wr=
ote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > > i2c-designware-pcidrv is a PCI driver and should depend on PCI.
> > > Fixes these build errors:
> > >
> > > drivers/i2c/busses/i2c-designware-pcidrv.c:256: error: implicit decla=
ration of function 'pci_request_region'
> > > drivers/i2c/busses/i2c-designware-pcidrv.c:338: error: implicit decla=
ration of function 'pci_release_region'
> > >
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > Cc: Baruch Siach <baruch@tkos.co.il>
> > > ---
> > > =C2=A0drivers/i2c/busses/Kconfig | =C2=A0 =C2=A01 +
> > > =C2=A01 file changed, 1 insertion(+)
> > >
> > > Does anybody merge i2c patches???
> >=20
> > Yes please, it's been there since Mar 17, reported several times, and p=
robably
> > masking other build failures.
>=20
> This bug only exists in linux-next, as the code in question wasn't
> merged in Linus's tree yet. It is drawn into linux-next from Ben
> Dooks's next-i2c branch:
>   http://git.fluff.org/gitweb?p=3Dbjdooks/linux.git;a=3Dshortlog;h=3Drefs=
/heads/next-i2c
>=20
> This is where it has to be fixed, so only Ben can do it. Ben, please?
>=20
> Meanwhile, it should be possible to apply a hot fix to linux-next
> directly, Stephen does it pretty often. Stephen, could you please apply
> this fix temporarily until Ben wakes up and applies it to his tree?

I will apply this patch as a merge fixup from today (if it is still
needed).  I also have a patch being applied to that tree to add an
include of linux/delay.h to drivers/i2c/busses/i2c-designware-core.c .

Ben?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Apr_2011_08_38_55_+1000_nTU98=yaV8/OtFn=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNpNR/AAoJEDMEi1NhKgbskRAH/js0mYL+s/7V4wSHpECSeLvw
rO82Vhso4vLnBVgqGRswXjcA5ZOTvogSMum8MEbw7Nsnwai5r+K8xR6G2b+ADH72
x0PIWTHUoPLRw0/Mg9/sorHjLZ2aWn6Ve1q1V3BaEQ5RpdqKNViEe/z2IjrjcnOc
PJZZUtutUMZTkDRY4Sk5wNDr9+U0aBPDzuJBHL8/DTzrFsuI+eLNtsrP7nZme2FV
MfOMc0rQRTB/BqR0wCbpLSzL5ETwneNJBQz1bGzSLcF0+CFuJY5pb1MfiSqerSFQ
zVYEIQ0NuAEKqamwbW0qlLLZhSjmrZmNakWy22B8ohf7hEjDTPOX9ngRtu0wdDM=
=xutK
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Apr_2011_08_38_55_+1000_nTU98=yaV8/OtFn=--
