Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2DKKid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:38:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33389 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab2DKKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:38:32 -0400
Date: Wed, 11 Apr 2012 11:38:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120411103827.GH3163@opensource.wolfsonmicro.com>
References: <20120410131206.GB31551@sirena.org.uk>
 <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
 <20120410133339.GK7499@opensource.wolfsonmicro.com>
 <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
 <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
 <20120410175846.GQ7499@opensource.wolfsonmicro.com>
 <20120411112411.11825eec@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtJ+CqYNzKB4ukR4"
Content-Disposition: inline
In-Reply-To: <20120411112411.11825eec@pyramind.ukuu.org.uk>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtJ+CqYNzKB4ukR4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 11:24:11AM +0100, Alan Cox wrote:

> If that code gets pulled out of IIO dumped into drivers/adc and has a bit
> of a different API to the gpadc code then no problem, gpadc can follow it
> happily enough. IIO can use it from staging and IIO can migrate whenever.

> It does make sense to think hard about userspace APIs for IIO but for
> kernel APIs its really being too conservative - we break kernel APIs
> every release. They are not set into stone.

The way I keep thinking about this (which I'm sure I've suggested
before) is that we should be refactoring IIO such that the userspace ABI
is just another in-kernel consumer of the device driver bit of IIO and
that driver bit should be small enough to just use.  I think that winds
up being roughly equivalent to your suggestion but means that there's
just one place to put the drivers which seems like a win.

--vtJ+CqYNzKB4ukR4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhV8FAAoJEBus8iNuMP3dpdgP/2RKx0zRI+lVq5/b5GK99bC4
ABwjQfkZ/6pagKJd1yfQQUjR3JROnwWhP2Gd/KY6VzXlNLGQObwEcHL1grXzr9JY
t5ABRkivijElXZlzKApir8F05jemTDzOypxzlzHKeOkryHHHfNq3BH6D9BNm7Si2
Sya+hAlN+Y4xYrwEAh94df5bNCryCQdsI6G3rvR06JdrdcpEvZPEIENCHOyWnrSY
zXNlsNC92tU9ht1nGZP5Hl80lWOCJp56bSYlTl3CUveZwMb8pmwWmVV9fhlwWLQo
VNICcgBXC3ppNqYPzrv9/vpFqRO2JuCVG7snTDxoZr3DmNTg4WfEd0CwL0iCct1F
OGsYpPINY9yJefnYG+3N9vyVOFsMe1iWbd2JYOUPODs7e90Hk7o1ZKinPIzICAk+
L/1mKk8LclKAbG1zWn499sEQs6KFV1Bx1e9WZB1bvRMiVXlYMBSo1Mx9oywDGWpB
dgGw6PU2kfoaRHTFP1m5BRHeezl2Wok7/Ym1BbAL/XU0kkzA133SjoefAIrAzgzn
dk21ubfP9/xflZLTX4HQaCjjzsIWn57IMAXPw+5pAgT1syzfiEU4b0mHvRaRV40k
v8TjvsystJARltk4EAaPc4F5r3Uwtx8u/y/u2XEwTJG6HdWWjQG+uRAb3YFvQ99P
YPePygl4JwI5Z8d5TtVo
=Rsxi
-----END PGP SIGNATURE-----

--vtJ+CqYNzKB4ukR4--
