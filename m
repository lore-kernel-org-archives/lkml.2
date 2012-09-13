Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2IMKHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:07:13 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:28420 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2IMKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:07:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgDAKmvUVBbdWObgWdsb2JhbABFhUBHrVQih3MiAQEWJieCIAEBBSNWEAsYKgICVwYTiBGpCJMZixCFJYESA6hm
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="asc'?scan'208";a="968256252"
Message-ID: <1347530860.4539.217.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 4/5] Staging: ipack/devices/ipoctal: acknowledge BREAK
 condition.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Date: Thu, 13 Sep 2012 12:07:40 +0200
In-Reply-To: <20120913100250.GM19396@mwanda>
References: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
	 <1347529588-21212-4-git-send-email-siglesias@igalia.com>
	 <20120913100250.GM19396@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vSxffF+zYRlhXWm9k5G2"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vSxffF+zYRlhXWm9k5G2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 13:02 +0300, Dan Carpenter wrote:
> On Thu, Sep 13, 2012 at 11:46:27AM +0200, Samuel Iglesias Gonsalvez wrote=
:
> > Clear the BREAK flag from the ISR register.
> >=20
> > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
>=20
> What are the user visible effects of this bugfix?
>=20

It clears the BREAK flag in the device and avoid to read wrongly the
same condition later.

I should have described better this commit message. I will sent a second
version editing this commit message.

Thanks,

Sam


--=-vSxffF+zYRlhXWm9k5G2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBRsGwACgkQWrfbyfmd9eIupwCeImpsqW3aOdXeFtvxJtP16Z3p
9pQAoIK71Q5qEH/Npz58ufk/z307pPj0
=p3y+
-----END PGP SIGNATURE-----

--=-vSxffF+zYRlhXWm9k5G2--

