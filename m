Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2KZXFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:05:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38818 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2KZXFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:05:39 -0500
Date: Tue, 27 Nov 2012 10:05:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20121127100530.20174586b57ef55da58608d4@canb.auug.org.au>
In-Reply-To: <1353940512.22512.38.camel@fedora>
References: <20121127004948.6e7973525843529de827ed0e@canb.auug.org.au>
	<1353940512.22512.38.camel@fedora>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_10_05_30_+1100_45rKkn55DL6eKuGt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_10_05_30_+1100_45rKkn55DL6eKuGt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 26 Nov 2012 09:35:12 -0500 Steven Rostedt <srostedt@redhat.com> wro=
te:
>
> On Tue, 2012-11-27 at 00:49 +1100, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
> > drivers/staging/sb105x/sb_pci_mp.h:22:25: fatal error: asm/segment.h: N=
o such file or directory
>=20
> I haven't tested this with any other arch than x86. That said, what
> about this instead:
>=20
> > Caused by commit 68a81291ff66 ("staging: Add SystemBase Multi-2/PCI
> > driver").
> >=20
> > I have disabled this driver with this patch:
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 27 Nov 2012 00:45:07 +1100
> > Subject: [PATCH] disable the SB105X driver
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/staging/sb105x/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/Kc=
onfig
> > index ac87c5e..c957e32 100644
> > --- a/drivers/staging/sb105x/Kconfig
> > +++ b/drivers/staging/sb105x/Kconfig
> > @@ -2,6 +2,7 @@ config SB105X
> >  	tristate "SystemBase PCI Multiport UART"
> >  	select SERIAL_CORE
> >  	depends on PCI
> > +	depends on BROKEN
>=20
> 	depends on X86
>=20
> You can add my SOB if you want. I don't care either way.

Please just send a (tested) patch to Greg.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Nov_2012_10_05_30_+1100_45rKkn55DL6eKuGt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs/W6AAoJEECxmPOUX5FEET8QAIKyUaS8WV4/1/Kw0LJHLFEZ
PLKbq7AsXqOW7takY6NteGrZo5hNGlPhnHpdZEYehrj9fg6sT6NbW9OjFlfzO0ak
NlbpLp8cZZcZOwiR+egVwL9T3m7kvfSxoTklLsHzz3ne+utF6ocyP8vySXd5EMXv
9gJLpBeV/kL1JKII+JHvbAnlXlR8tz+lT2i1DkhZKCtDiTXtxvUa6vR+f9tebPyc
4GtpiXexcnkTpzwx4ccfHfKL2f6MrDT/Y8ioGGK82/SzAXw73VMveu41mOf+uzia
ti6vf++ULgFhWKaY5hjTz1O6v6McO7weI0jKh/aOI8SN4Aur+4/efEq4WKWeLtL9
dkAkJ/Ow0p70p9bRML4B1aVBCxAsmpXxLUqsFCqIu7z1qxILn0ZE+qCxy+HRxc1y
sGr9lw4Jw1U9KJIRkWD+H0A+Lh4fVMAj+rPopbGjnKOB9JIq0LHqOCSoBVWzMPKA
IM7h27cOHl6kDvPn+JlorgDsWwLHBOTE6v037znnUVjgHahsu3TXQwKrwnecvipf
KTxNJX/ktfj+TvpRLE2K7tvm22RQwyXMtiCXBoix2NMRcnxocdVrSZPxYrF2fy2e
56A/BVIquvZcmy75tMJwdLmwEuG0D7zGur8IuTMQ7TUoroU45RIhky1bWqIg5Jsm
mGZ5ZAkT/uPt7wgWkPud
=6cpF
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_10_05_30_+1100_45rKkn55DL6eKuGt--
