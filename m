Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2IMKcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:32:18 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:7529 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343Ab2IMKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:32:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgDAOe1UVBbdWObgWdsb2JhbABFhUBHrVQih3MiAQEWJieCIAEBBSMEUhALFQMqAgJXBhOIEakAkxyLEIUlgRIDnxKJVA
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="asc'?scan'208";a="951021500"
Message-ID: <1347532384.4539.218.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 3/5] staging: ipack: remove irq field in struct
 ipack_device.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Thu, 13 Sep 2012 12:33:04 +0200
In-Reply-To: <20120913100145.GL19396@mwanda>
References: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
	 <1347529588-21212-3-git-send-email-siglesias@igalia.com>
	 <20120913100145.GL19396@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Z8/3cMdvt0JXFlXIMVYa"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z8/3cMdvt0JXFlXIMVYa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 13:01 +0300, Dan Carpenter wrote:
> On Thu, Sep 13, 2012 at 11:46:26AM +0200, Samuel Iglesias Gonsalvez wrote=
:
> > From: Jens Taprogge <jens.taprogge@taprogge.org>
> >=20
> > The field irq currently is identical to the slot number.  It does not s=
eem to
> > have any real use.  The number is written to hardware in ipoctal but it=
 seems
> > the value that is written does not matter.
> >=20
> > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > ---
> > -	iowrite8(vector, ipoctal->dev->mem_space.address + 1);
> > +	iowrite8(1, ipoctal->dev->mem_space.address + 1);
>=20
> It might be nice to put a /* dummy write */ comment here.
>=20

Added! Thanks for the suggestion,

Sam


--=-Z8/3cMdvt0JXFlXIMVYa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBRtmAACgkQWrfbyfmd9eKq0gCglNGIDbLEYgHeJQH6ZdbPKuvo
XtYAn39I58pLRUiRb/H9/H6gCA6nVYqo
=y+QD
-----END PGP SIGNATURE-----

--=-Z8/3cMdvt0JXFlXIMVYa--

