Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2BPEpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:45:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40681 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803Ab2BPEp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:45:28 -0500
Message-ID: <1329367521.3048.165.camel@deadeye>
Subject: Re: [PATCH 1/2] kbuild: Fix link to headers in 'make deb-pkg'
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org
Date: Thu, 16 Feb 2012 04:45:21 +0000
In-Reply-To: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
References: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-U0D+VeLGdmT4foiX6BHD"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U0D+VeLGdmT4foiX6BHD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-15 at 17:38 +0100, Joerg Roedel wrote:
> The Link to the kernel header files in the debian packages
> point to the original build directory. This is a bad choice
> if the packages were installed on a different machine. Fix
> this in by manually re-creating the link in the builddeb
> script.
>=20
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: maximilian attems <max@stro.at>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: debian-kernel@lists.debian.org
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[...]
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-U0D+VeLGdmT4foiX6BHD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATzyJ4ee/yOyVhhEJAQqjHhAAqhfG/G7p07aaNL2wNGqm4Aiv0mWY/Kpo
cdoTRphuYl7+oRxGF6u6upvdGS8yDE55FngIt93F62eK9J4Z7OOkR4a6lgPj3UBo
tfz4zII+pW08/8aFZcul+3naTa7yReLpHi2n4XviKMo89oa9rb/a81xL10R/vp2c
uNPhfKPqupkvfMtrBQRoSgOGP9SDMKzB0rXY8m9sLULKcK0//jougVBioWnzblTL
fZqbM9/3DscIzsCctG+ElJcHtLD3/eyCT0Zi1kW6wAUC6Esbu+NLfnBm12BjmQt6
LoiwMoylAVFoZ11zHKBSEqvbiKg7jwMyPFi4tmMSdG4f1+O5dfDhMnfiOzFguiH6
f/u669txOtIy1EmTk7p0djPT1+YJn5mNQSOJGFqeRWKxLgndvEKfG88t36OhJnvE
vAVMR8XyHuP969ZB7xEzHyp72nVLU+2DRu5pJJqCp5FDNTqUFIjQfZVShPxr+HsH
E+Eq1/Ph32fV/wi1cQmqcQaFHdr59w/dTmZ+b+Jbt7UMaR5gepUQxbimd9HFKWbp
mFHszzap8bZ2I0z+68Bxu9pvHZKfXLcFUYnYFh139E1wcuVTI76B1S+UYHcOHQ9i
2JlvT/sbPGbTZwtMBeaZ5k8BxOpNhRdBvTg14tHqYMt02wPP6BrwGa8AMsk5WygJ
/9kENlERmBM=
=h2GT
-----END PGP SIGNATURE-----

--=-U0D+VeLGdmT4foiX6BHD--
