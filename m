Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1KGFud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:50:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45423 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1KGFuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:50:32 -0500
Date: Mon, 7 Nov 2011 08:51:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] staging/comedi/jr3: Convert pci_table entries to
 PCI_DEVICE (if PCI_ANY_ID is used)
Message-ID: <20111107055100.GV4682@mwanda>
References: <1320623647-5108-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/LSm8UPTCLHL4o89"
Content-Disposition: inline
In-Reply-To: <1320623647-5108-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4EB77199.005B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/LSm8UPTCLHL4o89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 07, 2011 at 12:53:59AM +0100, Peter Huewe wrote:
> This patch converts pci_table entries to use the PCI_DEVICE macro,
> if .subvendor and .subdevice are set to PCI_ANY_ID,
> and thus improves readablity.
>=20
> Since the driver_data field isn't used anywhere we can also drop the
> assignments for class, class_mask and driver_data.
>=20

The other reason we can remove them is that C will initialize them
to zero by default in this case.  So the new code is just shorter to
write and doesn't change anything.

regards,
dan carpenter


--/LSm8UPTCLHL4o89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOt3HEAAoJEOnZkXI/YHqRXTEP/jgJrGKuimMzsLYZgRY/ODmD
a1AzPmURFrHFiTeUsKZBewELDhOqGjUPAx3ZWRxkU6s4nVSLk5E7EezuA1RR+LC+
dkOO+mkmOM8Qu6y2JJy8NdUy6MAFzf+9IZtltcyVfUNG9yps9EflAH5B4GeRoBQe
h1j52PG9l+JN8Fi/DoKr/u1u6Ltd/XhOq7Qe9qCKlVyTBZ63QD7e62EZGYopVJS4
4jaEmMxCQ5wsIQDqm4NxCZzOJQq7I0ssvtay4fmoxNs4XZa5jQpXahsd/HOLSHGi
zz/NedJ3Ce+yqX7qSk79gAXd0kGqXdpiOlKMtagICQNSN1kB2Mku1y/r0XVBugzl
lVxsGtA4oW0Q0uPtEdab2vRw8git9hVG03D1QLzl1wvrgl4NdB4A3PXv1qF/u/5/
jnwqRUqOqavOABiVP7yDrtZXMk+oFuUEIcL0uPlSAx2WlsftM7qwua4ZQlGx7pdY
ragQAZhe1HesY4XfOCgwKPKdFMAC1gz74WpcZtrqi1wmC6IdbD+R9jSnrTkpAkOu
Ao0Doby0+iUrVSx9oa4R2uiPTl9kuhsW0CeQQjOTZDbYZQOy2Q5/PyPoCxsvrG4J
MFdNRf4DqsN1BMhM6W0JnAPtywKEuu3Kl7oL3vLVrw0XRhxk5kyxQBSBQEsw0qPJ
7RM14Dfjy4eotZ/MoOfv
=/3Im
-----END PGP SIGNATURE-----

--/LSm8UPTCLHL4o89--
