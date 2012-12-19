Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2LSKJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:09:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37921 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2LSKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:09:12 -0500
Date: Wed, 19 Dec 2012 10:09:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Luciano Coelho <coelho@ti.com>,
        svenkatr@ti.com, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, lrg@ti.com, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219100909.GO4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lRF4gxo9Z9M++D0O"
Content-Disposition: inline
In-Reply-To: <50D19040.5090404@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lRF4gxo9Z9M++D0O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 11:00:32AM +0100, Peter Ujfalusi wrote:

> I don't know the state of the common clock framework for OMAPs. Is it already
> up in 3.7? Or going for 3.8? 3.9? 3.10?...
> We need CCF to resolve this. I can cook up the clock driver for the 32k clock
> from twl, but in order to use it we need CCF on OMAP.

Well, we at least ought to make sure it doesn't appear in the regulator
DT bindings even if it's handled via some OMAP magic - that was the key
point here.

--lRF4gxo9Z9M++D0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0ZIzAAoJELSic+t+oim9f24P/iF5uVDPLt/inTJDhwV5LpLS
6cc1AClrpDAp48BM/YQ9UlPJKm4+iN5Q5Udy2oAMzsdqFt9+cpGabMQcfwlD5y9k
NAVcaOa7I46wwAj6q/lN/fvri8VA84N06Ud7NCYksnxr3mWhztpnJMtGnRvNlBO5
39Tyrs1fONMt8w+qgMOykHb04FcEaCIgKafp97IDEgt31etn365NBFtHxar7qzwR
JThzrIXV4mRH5htHHj0W/bOXbqyN8nSR2GZogRc5Hl0BK+GIBKKD/IpY92E3sr7M
S90mA3hIVKHlRaNek7w0YP5NisFPm4DHbjuItmeVN5UleNgyZMANpHhgQca/06LA
E9KYsJcMPt8z6vQQ0a3iaUyMGbayAU9i7nUD/wiig6Q4mAwWudqVXbaAwgv9FyKs
+bd016ExH+p5eUBPmi0wsnShC7LjHHB3LXYKuGcbocjSTCmO7QPyfi7fSb4kFHmc
yUl0yH9ed6Q1lX0cfFZzLueW0nBXOOSsen5g85lSrJJVIvrn7CqLAms5D6acAtHW
eSdZ3SQR7hsEHiElK+0ThXbeVrSiWJbaeiy7GWhByP1Vl+N+E0h7E1ppKIbciFQL
P/DOFgrU9ka9wZ8FTZk8ndSHfkh7kri5phc5s/ckBSBXaWHrk3i4PTmSMo6XO6qq
MFYkD3xor8103n01JSDK
=Cpss
-----END PGP SIGNATURE-----

--lRF4gxo9Z9M++D0O--
