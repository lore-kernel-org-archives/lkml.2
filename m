Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1JOQnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 12:43:05 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:60981 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1JOQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 12:43:04 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com
In-Reply-To: <20111015130552.GC18864@andromeda.dapyr.net>
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
	 <4E98BEF5.10801@goop.org> <4E98C6CE.4020508@oracle.com>
	 <4E98C8B1.20304@goop.org> <4E98D739.4000705@oracle.com>
	 <20111015130552.GC18864@andromeda.dapyr.net>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-jyMsMYRhBxLV/SbWJa8f"
Date: Sat, 15 Oct 2011 17:42:48 +0100
Message-ID: <1318696968.11016.47.camel@dagon.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] XEN_DOMAIN_MEMORY options.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jyMsMYRhBxLV/SbWJa8f
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-10-15 at 09:05 -0400, Konrad Rzeszutek Wilk wrote:
> > On 10/14/2011 04:41 PM, Jeremy Fitzhardinge wrote:

> > >While it would be very silly to put 128GB of actual RAM on a 32-bit
> > >machine, systems can have non-contiguous RAM placed at high addresses,
> > >which would no longer be accessible.
>=20
> Do you have some ideas of which machines that might be?

Even if you were on such a machine, the discontiguity
(discontiguousness?) wouldn't ever be reflected in the pseudo-physical
memory map, would it? So since this variable controls the maximum size
of the p2m (rather than the m2p) it doesn't need to be larger than the
maximum sane 32 bit guest size (<64G).

Ian.
--=20
Ian Campbell


Every improvement in communication makes the bore more terrible.
		-- Frank Moore Colby

--=-jyMsMYRhBxLV/SbWJa8f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOmbgIAAoJEOxjaZd5B0+onZcP/jYk5JvIVJGoZJ/P+Q775Rp3
SwPvVWy0SV63/uHn1Z3BJzu3DxnCzCQ7zgQvHCBJOJJ9lHDru2voGI/Zit0wY+Ds
ZZXAEcjZg8RWx7+UL6uChgkem3IIhXJNUG+gipBHZmr5wPui7gA+kPyy/YXOn+0v
xAkk8aMuKlX+wSm1rX87p42B5p7YDbefQ3NjVrxp723wFE+HGSjyOZnj3pg20fFR
Pgu8hYYaMK+bDZZ+IAD4GFzDsz8ASaG6YlcFfo3GjAGehu9RRpRJz04jNaGYl/Rp
pMltWnrE+hT8oCJvq0x6Oxo1Al9esc6jlEjEzTX78wxzdP8AjI+bqvXnvHeQbZYl
2pFkVGYi1uIwFImeSucs8eWw+lC4PYS3R0PLAXR74j4jrCvvJRC5ZF/9g5fPiEbr
6ldyASACb3al2amgmMnTgYMWosn/zCXXt6aj2S0sZ4SA7aVNv8cPbqTKZZJH2ZZ8
4Xa3WyllvLZNWAJekzeWsyDA/aITeq7th+OntAXi2rugWi5vR3fHH/rLDjS4X1/D
Ip6Seddyzp3mU3Cs84rCzzWonaVtYjpRXq8U7ZfSMJ7BrUOVME0rmnmGeA3EQ005
6bndcd3V7zeilDsJt2xVNSPwgit91+c5DkXNWt5lfFDS2AzY+qz6Vnqj7cxk7ItG
FhQIUpl4/N8JWVxTIQJv
=4w19
-----END PGP SIGNATURE-----

--=-jyMsMYRhBxLV/SbWJa8f--

