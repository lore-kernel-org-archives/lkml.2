Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2DKIRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:17:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44097 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab2DKIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:17:14 -0400
Date: Wed, 11 Apr 2012 09:17:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: build failure after merge of the regmap tree
Message-ID: <20120411081711.GB3163@opensource.wolfsonmicro.com>
References: <20120411141346.3c4dd8e481d052b583ac95b6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20120411141346.3c4dd8e481d052b583ac95b6@canb.auug.org.au>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 02:13:46PM +1000, Stephen Rothwell wrote:

> Caused by commit f01ee60fffa4 ("regmap: implement register striding").
> Please build test ...

Mainline *still* doesn't build with the .configs I routinely use.

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhT3dAAoJEBus8iNuMP3dG4MQAIK4i+3zfcZkpnWYiGEVaB8e
X6GgmJGF5GSEEzCKzgss51Xm76YKjR6zpamGam55VRR3if95MP98d4ReLjnBTNES
g5Uiyja4alom6Uax+rQCmdfgYqgVPacXRgiu7IkYNV456KK2SzC3msbZbyeyc8XS
sGDHqSZCoRVnS4g+eaR3Bbk0HE1dcwVzJlzieuseZ0pWWAozEDpTOyxbK6m+MKEL
eG1r5E6VdELi2ZgvkGU637No+b1grUXbREqzCF2t9O23u7LLF0PRhiLHEM5d9+QV
9aoJ2/K4Mql6KWEw+QkFQhcCJEtqZjCyPlFD/Fzj4CqRaP3ZpTBkl/eDufNx4pry
Hvmht6gjU6XyR/jtXUmv42FIjeKE3/CMwYY3Xk6PBhPSkydmPVuoWyP9o6WYDOFh
DZ2RUEgeJAnLf6bpjKEB6sIhwpSWy1EAp8OQ0OC372vfSQ/8BqjItGCm+LxO95wN
3Y3MaBWoYUyu5rP5hlVjiBSuLCQtE+qvkWDLIcKXEyywz+FscJUsBmqgMAhuKkC6
jPIfBmH9CaVYoB1xLPyXkv16djHQJWCrxwOMz6mY/+zm3n2w/iGrENIFm6XHB2oP
ian1EkwERXz8tvNtQXWD9vNfmNEwWannMD3ajq7BXIx+x6bLekQqNxCEivfIDyvw
bXKkt85vxmfSl/lYUbFl
=7luu
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
