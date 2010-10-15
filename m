Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0JOAaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 20:30:01 -0400
Received: from ozlabs.org ([203.10.76.45]:35760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0JOAaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 20:30:00 -0400
Subject: Re: [RFC PATCH] ppc: don't override CONFIG_PPC_PSERIES_DEBUG
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, Frans Pop <elendil@planet.nl>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101015002300.GB7522@us.ibm.com>
References: <1287078495-11722-1-git-send-email-nacc@us.ibm.com>
	 <1287101663.4194.5.camel@concordia>  <20101015002300.GB7522@us.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tSfPy+9328y+2YgHwZ1Q"
Date: Fri, 15 Oct 2010 11:29:59 +1100
Message-ID: <1287102599.4194.19.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tSfPy+9328y+2YgHwZ1Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-10-14 at 17:23 -0700, Nishanth Aravamudan wrote:
> On 15.10.2010 [11:14:23 +1100], Michael Ellerman wrote:
> > On Thu, 2010-10-14 at 10:48 -0700, Nishanth Aravamudan wrote:
> > > Because the lpar and pci_dlpar code is pretty low-level & verbose,
> > > perhaps it makes sense to add another Kconfig variable for really
> > > low-level stuff? But it's annoying to have DEBUG *somewhat* effective=
,
> > > especially in the EEH area when doing PCI stuff.
> >=20
> > I really don't think you want to enable the lpar debug by default.
> > Have you tried it? It can make for a pretty unusable system, just
> > because of the console spam.
>=20
> Yeah, you're right. After enabling it, I had to kill my boot and start
> over w/o the lpar DEBUG on.=20

:)

> I assume dlpar_pci is similar?

That should be OK to enable I think. Suck it and see I guess.

> I dunno, would a patch to a least remove the EEH one be ok? Seems like
> it isn't super-verbose, and does have some handy output.

Yeah definitely. That undef was merged as part of a cleanup/fix patch
but shouldn't have been.

cheers



--=-tSfPy+9328y+2YgHwZ1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAky3oIcACgkQdSjSd0sB4dKfFQCeLnSxqXlvtumQg3VnB6/1eFk0
6FEAn0bxW+zpGzjjTgBJfw1Wn/2Dn3Bd
=zsJD
-----END PGP SIGNATURE-----

--=-tSfPy+9328y+2YgHwZ1Q--

