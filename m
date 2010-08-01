Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0HAGXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:23:49 -0400
Received: from ozlabs.org ([203.10.76.45]:35950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0HAGXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:23:48 -0400
Subject: Re: [PATCH] PCI: MSI: Restore read_msi_msg_desc(); add
 get_cached_msi_msg_desc()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
In-Reply-To: <20100730094247.05cb070e@virtuousgeek.org>
References: <20100723102202.871a3131.sfr@canb.auug.org.au>
	 <1279847985.4883.391.camel@localhost> <1279850740.6381.19.camel@concordia>
	 <1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
	 <20100730094247.05cb070e@virtuousgeek.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+AftaXZSiMDhmtGt3pgE"
Date: Sun, 01 Aug 2010 16:23:45 +1000
Message-ID: <1280643825.32151.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+AftaXZSiMDhmtGt3pgE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-30 at 09:42 -0700, Jesse Barnes wrote:
> On Fri, 23 Jul 2010 14:56:28 +0100
> Ben Hutchings <bhutchings@solarflare.com> wrote:
>=20
> > commit 2ca1af9aa3285c6a5f103ed31ad09f7399fc65d7 "PCI: MSI: Remove
> > unsafe and unnecessary hardware access" changed read_msi_msg_desc() to
> > return the last MSI message written instead of reading it from the
> > device, since it may be called while the device is in a reduced
> > power state.
> >=20
> > However, the pSeries platform code really does need to read messages
> > from the device, since they are initially written by firmware.
> > Therefore:
> > - Restore the previous behaviour of read_msi_msg_desc()
> > - Add new functions get_cached_msi_msg{,_desc}() which return the
> >   last MSI message written
> > - Use the new functions where appropriate
> >=20
> > Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> > ---
> > Compile-tested only.
> >=20
>=20
> Applied to linux-next with Michael's ack, thanks.  I hope it actually
> works, I didn't see a tested-by!

I assume Stephen has been using it, otherwise his linux-next boot tests
will all have been failing. Either way he'll test it when it gets into
linux-next proper.

cheers



--=-+AftaXZSiMDhmtGt3pgE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxVEuwACgkQdSjSd0sB4dJDPgCeJpi9KZyePzkns3BtrS8y3zZi
lYoAn19R+/ZzfUuKRP5lwLfMn9/aIAzc
=y+Iy
-----END PGP SIGNATURE-----

--=-+AftaXZSiMDhmtGt3pgE--

