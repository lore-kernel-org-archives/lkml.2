Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393Ab2JXT47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:56:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50054 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933614Ab2JXT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:56:56 -0400
Date: Wed, 24 Oct 2012 22:51:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024195104.GA1175@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <64355430.MNHe7H1cg3@dtor-d630.eng.vmware.com>
 <20121024191042.GC772@arwen.pp.htv.fi>
 <4612865.mWDXHX689T@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <4612865.mWDXHX689T@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 12:38:44PM -0700, Dmitry Torokhov wrote:
> On Wednesday, October 24, 2012 10:10:42 PM Felipe Balbi wrote:
> > >=20
> > >
> > > That is a valid concern and we'll need to find a compromise here. As I
> > > said,
> > WHAT ?? Silicon erratas are not a valid concern ? Power waste isn't a
> > valid concern ? Tell that to the millions of devices shipped with Linux
> > everyday. Power usage if it's the top concern in any product, is right
> > there as the top five. Likewise for silicon erratas.
>=20
> I think we should come back to this discussion when you get more coffee
> and start parsing other party e-mails properly.

indeed. I really misparsed it. My bad. comments withdrawn.

--=20
balbi

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiEaoAAoJEIaOsuA1yqRE2kAQAIqVwPdCxEwcs4dAfXY8i1k0
tTWRZWWRyGq9ZX+usVg24Xnz186bo2FpiCaMNXuhrVFLK7Z5L4mt80BcJSLj+htt
21j+YJV+y4QHaN29gjJxTjO947VWc1SLjl4ztrlsPdiefFj0KC0NRLTtulAqe40t
rxfZW5v4dkU/VY11UNkG6ACh+/2DMeefiot7O+hSevh8LPvoPzMoluC73HynVwEp
tmCC3L1Neg4sfcegHMqNHkzto8NysOVSNrHFS2A68//KalmKp74jWlzw8Edo4iBh
4HYOdyObMCcVbOWnaZkpPiZtS57JCCfX8VPgEv10Nx5Kh+MxGl+wBCwsDwDS+8sh
7TWc/nUGTIfaaF8OAjqrFbOhr4+BcIE7/FkngRoMmcHJzRFKELRIAibA+2Vi8YP3
hVMd4itvmwIvfR4IuEbIrqkGs3D/qD4GxREaiwhJg0d+aQ7v8iUdfgnhRM6YTcjf
uNVBq/7EodILtfw4v1CJgi1ILrWpCRTAtEUUB4A1HTAfdmF+e2kviUTdnjMxzVqr
58N66fyO9syUzc7UWXaXbzuzDcUkbPAWLXXiHtbCSbYAGSlZ7VOMDe3nLpbV9C5T
XicyR2ursdlMJouvUDiFlaoPix+QNLuWRfo+SBb7gmwgcyElRtlJFTy9TJS+EW9r
p25y75h/VpCAhEm2ZIP0
=UWgz
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
