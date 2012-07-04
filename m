Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2GDLjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:39:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54099 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274Ab2GDLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:39:44 -0400
Date: Wed, 4 Jul 2012 12:39:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v3] regulator: ad5398: Fix min/max current limit boundary
 checking
Message-ID: <20120704113942.GR4111@opensource.wolfsonmicro.com>
References: <1341374107.27231.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mjrw6G9AoRBv8oQK"
Content-Disposition: inline
In-Reply-To: <1341374107.27231.1.camel@phoenix>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mjrw6G9AoRBv8oQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2012 at 11:55:07AM +0800, Axel Lin wrote:
> It is ok to request current limit with min_uA < chip->min_uA and
> max_uA > chip->max_uA.

Applied, thanks.

--mjrw6G9AoRBv8oQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9Ct3AAoJEBus8iNuMP3dOJIP/2S+Q2mDUuAQ1rcd7wq/Na9I
VfxzZ+8Z5EqEdGAgiSxtNiJ6yod4YmIj3pheoXsLHlEtzL06XnE/FU7SUtqTL4hn
AVw17qnVmXILwe9woBzx89PDFvPTHbpCJ6Wvd0JHGJVABKw+qguA8nrh3+L6WamE
44EHZgeuGP4NyPR5XD9WSIF9nwvML4Nz3KiWH4PML2JpT1zDQ27bb3Hst76rnJPF
Cib2uN30GzuZRWwNiqJVmr4L8+lToeZVg5D93USkAMwNFDOjnzfVzpG4qG1vrv4/
vfgAyb9033Q/NweDxgXzMQHcqOfAbqyU7e2ZZTRDsrn1QZ80U3FRGmE2vcfyF3/1
4slDn750EDn0rbn1rBGZkm9ay3WPRwEfOSO+0lKV7aLg5DWOWxBnSmuakqLagIAy
43+Ic7QXDoQgVQnHTyhNK7nC0GsLbwhdGpDkMka83aQkyAAnNA2Wh4INe3V5tGF/
TanSr9hd0kUWQdR1ONagN7EY0Nc1881jF2TGVxg9KLdwMnYibEfFXSBMhtH0RrrA
IPATSiMCsIbCxStzKg/7LpSmqqXZO2H6Une08i5l20j65TcMzwcoowPjGinxAqwb
TxW5RVeUMfxkq84F9BILgl8SnhtgYCUqw3vful1h7T5eoQhw2wtVyQH57yJ9Cz51
+RtiKbfylXwohEQifY+K
=9xo0
-----END PGP SIGNATURE-----

--mjrw6G9AoRBv8oQK--
