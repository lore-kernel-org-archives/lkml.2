Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1KYH0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 02:26:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16904 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1KYH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 02:26:03 -0500
Date: Fri, 25 Nov 2011 10:25:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>, Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
Message-ID: <20111125072550.GK3195@mwanda>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
 <20111123061355.GA3295@mwanda>
 <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
 <20111123145020.GA3258@mwanda>
 <4ECD1A01.3060503@mev.co.uk>
 <4ECD6873.7080106@metafoo.de>
 <20111123215111.GD3258@mwanda>
 <97189E06-26D8-4CF9-B325-06403FB1C42C@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sU4rRG038CsJurvk"
Content-Disposition: inline
In-Reply-To: <97189E06-26D8-4CF9-B325-06403FB1C42C@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4ECF42F7.00C3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sU4rRG038CsJurvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 24, 2011 at 02:07:49PM -0500, Xi Wang wrote:
> Using kcalloc looks good to me.  Do you want to redo the patch in that wa=
y?
>=20

It's your choice.  The other fix you wrote is valid as well.

regards,
dan carpenter


--sU4rRG038CsJurvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOz0L9AAoJEOnZkXI/YHqRZNcP/R2W8s9QTGNrfLi3QZZs8ec/
NoBACvzGXYjPadUlp21Uodi5p3zES5N6Rt8Tpv/WcoFJG7y6ZLAVvlUUcxJ8MGN9
vOXmMYkEj63H/nygv63oQaDliVN3QNr3IRxa4kEa5CwSrL4o2i7vxxoMh5JKzkV4
0VDYXlPDHngpnEjnIl3TPBIQYMHk0iTE/N+2foJEZa59PIw3H9pQhc2G+c5yDZPA
g/kNwZixikt/4UPEA46OYlUY5/IZKmc33bXH02vRG7j9keK/N4eceoAPOmZYVTUw
GYFDB4D5fBFpTOEvGLaOwHu8aUQEOdaNxTZ9XG+WaXY3Ts3GJNAixIkzT1s5jFQ7
8JwgEd4QkhhLe7DR1aI1kvcfHij+y+hh1Xh27aQn94U3GpF2LGPeqV+JEpzb3qLJ
dwup6GJqhix+OBv4/n9/jht3fV9lcJ93uRnC++pgxYO75iK+Be1x1I5TUUrUqDCl
naH30yxVTikXbsL4C6gNqi/FbIM51eou5Rr8mZnNBScgM9DeNko2gmCC8bfNNieG
ZzeVAMIyfdgJTLXWf2YV+g67Vh6rggSU90XdgSHhzBw/jkDKISauczZ36KbCnSCH
2nJe+ZMcf2VTfqRpVS+AHle30tITAwAw6kDn9oOjdjmwmqduzMpPOWTyNLq+SxFm
f1FVonP3n0H1tuYW304a
=7Wgl
-----END PGP SIGNATURE-----

--sU4rRG038CsJurvk--
