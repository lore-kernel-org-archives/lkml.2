Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2BAJqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:46:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57360 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384Ab2BAJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:46:52 -0500
Date: Wed, 1 Feb 2012 09:46:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mfd regmap irq to handle some cases
Message-ID: <20120201094649.GA3150@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA3C3@KCHJEXMB02.kpit.com>
 <1328082914.19234.3.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1328082914.19234.3.camel@dhruva>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 01, 2012 at 01:25:14PM +0530, Ashish Jangam wrote:
> On Wed, 2012-02-01 at 13:10 +0530, Ashish Jangam wrote:

> > That we can handle easily enough by adding a flag to the interrupt
> > definition deferring the acknowledgement.

> Can you let me know in which linux-next version this will be available so
> that I can test it against the DA9052/53 RTC?

I've no particular plan to work on this myself - I would suggest that
you work on this if it is an urgent requirement for your device.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKQoBAAoJEBus8iNuMP3d3ggP/1ouJH8yE+L6ztey26lulQJ9
a9CkOdoZOPo8uOiCPMm/vZwFLM/Kinj0T7HhoConbSaOyx4HRDjDYa2Zi6Si8mG6
WP0b6Ul8gHmV4jzIBLxj3bV8ynl/YZv+rn1oeRLqXq5ts5j/CmejH1+LuESli/Iw
1pkPe7PK/V8EWd9Utkm29gbBN3m+Ehpz/GvzsqDM9kXb3vG2WvCxa6B1nXrXeicw
TXXhsO1iSymkeLR7lPHQkSEqCAHZvN38u643mUc9PxgUVznlqTAm0fy22aEpRCRO
GsRcqdNAlYP4AqL5L9p2cf0y850H1GRqM/ymTc4/aDbUzqBx4TxU1uoX/o9Nnj5P
yVsF95NPZeqmh0e7O+5r+JK/Jit0bdAm+MsIFyLEcks64T9it8aYP6Ezx8D6+3s0
g90R1Cbp575eOZMEc9iut3MBBNDAnt2n7u8VypBoGX0W9leK8FPa3zpvT7Hw7Q7t
JV34wfTNV3X4TLm3bWmRwEKtd7NCenIlP/+QwVpn7sagMWl1ufg425U4M7juusbF
bopqKtkV1TrEEINSTIbX4pALyfNx6dLlUzhEavhgqxiWhIZ0Ht4Rj6Fd4TsTgVRm
XXeglDqkNLSVIfus2yy0NKPBXllKE0WBgna+fQmqloGotDOIjNhpMga/lm1eVJtK
59BCU4uAdJOIRDyKxObZ
=NCzU
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
