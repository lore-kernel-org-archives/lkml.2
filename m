Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0KBA0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:26:05 -0400
Received: from ozlabs.org ([203.10.76.45]:41247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0KBA0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:26:02 -0400
Subject: Re: [PATCH 04/39] arch/powerpc: Update WARN uses
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288622509.366.237.camel@Joe-Laptop>
References: <cover.1288471897.git.joe@perches.com>
	 <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
	 <1288609334.10671.4.camel@concordia>  <1288622509.366.237.camel@Joe-Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sIFNLzaSNVoEuZiTvuSW"
Date: Tue, 02 Nov 2010 11:26:00 +1100
Message-ID: <1288657560.16790.8.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sIFNLzaSNVoEuZiTvuSW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-01 at 07:41 -0700, Joe Perches wrote:
> On Mon, 2010-11-01 at 22:02 +1100, Michael Ellerman wrote:
> > On Sat, 2010-10-30 at 14:08 -0700, Joe Perches wrote:
> > > Coalesce long formats.
> > > Align arguments.
> > > Add missing newlines.
> > >=20
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  arch/powerpc/kernel/hw_breakpoint.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kerne=
l/hw_breakpoint.c
> > > index 5ecd040..d7343a7 100644
> > > --- a/arch/powerpc/kernel/hw_breakpoint.c
> > > +++ b/arch/powerpc/kernel/hw_breakpoint.c
> > > @@ -270,8 +270,8 @@ int __kprobes hw_breakpoint_handler(struct die_ar=
gs *args)
> > >  	 * message to let the user know about it.
> > >  	 */
> > >  	if (!stepped) {
> > > -		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at "
> > > -			"0x%lx will be disabled.", info->address);
> > > +		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at 0x%lx=
 will be disabled.\n",
> > > +		     info->address);
> >=20
> > That appears to have done nothing other than turn a short line into one
> > that is now > 80 columns.
>=20
> Added '\n'.

Right.

> The series was done for a few reasons:
>=20
> o to add missing newlines at the end of messages as was done here
> o to convert a couple of misuses of WARN(msg) to WARN(1, msg)
> o to remove KERN_ prefixes from WARN(test, KERN_<level> msg)

All fair enough.

> >  Is that the latest fad?
>=20
> Pretty much.  Format coalescing is generally preferred for grep.

Really? Grep doesn't work anyway because you have format specifiers, and
although you can try and guess them .. good luck, 0x%lx, or 0x%llx, or
%#lx or ..

cheers



--=-sIFNLzaSNVoEuZiTvuSW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzPWpgACgkQdSjSd0sB4dJHNACgmeX6sZNCJlAmn/k61tOZJ/vQ
uz0AoIh3vUaXs8/PATS6DpYUsQ2hTMAC
=SOtd
-----END PGP SIGNATURE-----

--=-sIFNLzaSNVoEuZiTvuSW--

