Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3AEOUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 09:20:54 -0500
Received: from ozlabs.org ([203.10.76.45]:55395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab3AEOUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 09:20:51 -0500
Date: Sat, 5 Jan 2013 23:49:36 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Jon Loeliger <jdl@jdl.com>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: Fix util_is_printable_string
Message-ID: <20130105124936.GE4674@truffula.fritz.box>
References: <1357326778-12725-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Content-Disposition: inline
In-Reply-To: <1357326778-12725-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 09:12:58PM +0200, Pantelis Antoniou wrote:
> The method used did not account for multi-part strings.
>=20
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

I think it could do with some more commenting of exactly what it's
considering a printable string(s).  I'm pretty sure it's doing the
right thing, but if you're not already familiar with the OF
multi-string convention, it would be easy to get confused by the
code.  Other than that

Acked-by: David Gibson <david@gibson.dropbear.id.au>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDoIWAACgkQaILKxv3ab8afkACdFV6ucIb/p95nMaqhVPapwRQ+
TasAmwR+agw0IbAU0QtRI7Gj44DbdAuU
=Oot0
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
