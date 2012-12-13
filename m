Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2LMXdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:33:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37499 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2LMXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:33:05 -0500
Date: Fri, 14 Dec 2012 10:32:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20121214103256.ce307015fd09961ad82346f9@canb.auug.org.au>
In-Reply-To: <20121127100530.20174586b57ef55da58608d4@canb.auug.org.au>
References: <20121127004948.6e7973525843529de827ed0e@canb.auug.org.au>
	<1353940512.22512.38.camel@fedora>
	<20121127100530.20174586b57ef55da58608d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Dec_2012_10_32_56_+1100_TcmBkA6F/Nq6.NSi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Dec_2012_10_32_56_+1100_TcmBkA6F/Nq6.NSi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve, Greg,

On Tue, 27 Nov 2012 10:05:30 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 26 Nov 2012 09:35:12 -0500 Steven Rostedt <srostedt@redhat.com> w=
rote:
> >
> > On Tue, 2012-11-27 at 00:49 +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >=20
> > > In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
> > > drivers/staging/sb105x/sb_pci_mp.h:22:25: fatal error: asm/segment.h:=
 No such file or directory
> >=20
> > I haven't tested this with any other arch than x86. That said, what
> > about this instead:
> >=20
> > > Caused by commit 68a81291ff66 ("staging: Add SystemBase Multi-2/PCI
> > > driver").
> > >=20
> > > I have disabled this driver with this patch:
> > >=20
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date: Tue, 27 Nov 2012 00:45:07 +1100
> > > Subject: [PATCH] disable the SB105X driver
> > >=20
> > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > ---
> > >  drivers/staging/sb105x/Kconfig |    1 +
> > >  1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/=
Kconfig
> > > index ac87c5e..c957e32 100644
> > > --- a/drivers/staging/sb105x/Kconfig
> > > +++ b/drivers/staging/sb105x/Kconfig
> > > @@ -2,6 +2,7 @@ config SB105X
> > >  	tristate "SystemBase PCI Multiport UART"
> > >  	select SERIAL_CORE
> > >  	depends on PCI
> > > +	depends on BROKEN
> >=20
> > 	depends on X86
> >=20
> > You can add my SOB if you want. I don't care either way.
>=20
> Please just send a (tested) patch to Greg.

This now breaks Linus' tree .....
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Dec_2012_10_32_56_+1100_TcmBkA6F/Nq6.NSi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQymWoAAoJEECxmPOUX5FEsuwQAJKo4xn+fwiYQIpCdUlviAIm
q/UFwQH5D3sKtysnVBbR3cqRCmExyVZTpWU5N93Kcw01qXsQxcsSBzJHVfOR9Biy
RKG6kBZuYwIu4FmWJCy0wKHY9lqVNpVBSdiEH5weZ7oFCupk3XNh9AxxgijijvKz
G6JUgcCX3wUg5vZ/GsIy5boPYZmc7PnG5s0ypydNM5HzsrYeziz5wU0L5C/7b6CU
JwrR6EFP4h7oDdW7g+Z0VyMtmwT7ZLbAWZ4LBwxInUIzGzmW9j21yKu4T0h+o1b7
eWYvJ8gpQOzwFUd2qNDBIX2n2Sz2e0jOHd7Hq9KjinU2hK174RwLG0YVs/1NpQqj
TXJ9U9XnQmT0JgiaIMsIySk121unn+8VpEU3OcmDDohDGozxwQTMMeRGRJzE6RUI
pxexHWel47O6SgjEfJY2RuWVYTVrZWz6TrUJMT0a5A3v5kPBCwSCyqmYWBbmog6/
MjWGSVPyn60Py96RN2OFSaX5ERlVxNaDWePoux+ExwaFL3DXLo1HZKMTVCNXzb/4
hU+vOSoYe0VToD5zsn6/38RwwlnagSHdXxDaxKeMHOI0TJaLX9MkQvhma/afP0Em
vWCawwpjMAA6YspVDmRo+fOLNSZ3Qh21qJGRZ2DKVNhG/Pm3s6XE8w2S/eDT3fQE
FqhHmh43QcCcMSfzUekW
=kar7
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Dec_2012_10_32_56_+1100_TcmBkA6F/Nq6.NSi--
