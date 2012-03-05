Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab2CEMnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:43:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49829 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005Ab2CEMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:43:26 -0500
Date: Mon, 5 Mar 2012 12:43:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT] regulator: da9052: Ensure the selected voltage
 falls within the specified range
Message-ID: <20120305124324.GK3224@opensource.wolfsonmicro.com>
References: <1330950476.3853.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g4MvFqI7wmANiPDo"
Content-Disposition: inline
In-Reply-To: <1330950476.3853.4.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g4MvFqI7wmANiPDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 05, 2012 at 08:27:56PM +0800, Axel Lin wrote:
> Integer division may truncate the result, use DIV_ROUND_UP to ensure the
> selected voltage falls within the specified range.

Applied, thanks.

--g4MvFqI7wmANiPDo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVLTaAAoJEBus8iNuMP3donMP/iwZ96tWkgXON8hLKAGTAPUw
lm8cb+SgB2IXTkMKafp4XYL4NwEcFHOY8N3Yk7lzUxu2yMUFikz0dPD6r9wJtmf0
R3oQ7WtCwhhUzdpvKEoM1vzpD9frQ4Ko2lzZ94ymyQnH3e6ZPQyijefH/X6G+i8r
ooO3VVB3BB+Hg/Py1oI19xdWjuNi09YQfj6NPguDQ2UW8tceIO6WY6mfvNrhWOgq
AzE54lHnpOE+PLcoIvaRNNQcqDBFW7FFnCFmvRK08+qzH73dGmuBI4XSMqE17kpS
h1k4pq652vfDUIbuCW7KCGckS7vYIyEJh8vdIJhFHGKRkHBCG4aCFv448ya3pY1N
3m+nELoE5Cu4+a+dZt8AZGSkmQgGywdqFtomAwfTjgdtHKH2mQz4B0HM2AOV8uXA
cO+Mfi5rOXD0+/qQr3AoI0tX1bRp4ekZXgstJ/81CTWp8oVwNztNbMWhClJtnliX
iXDcF1l5hQZRo+BlFBrGbX87HEZiwXCs6S+kfMtRAn0gCWwSnE0361NPWb+zfML4
GkjdgslbL7ZpHSlofu5VBYAlBbojImdQLTSKXU+YDTGtxEnQMtEuPoKUk3unLEAk
+godVDa4eTdJZOMz/CnwGC+kEMbZjJywiwi21N/sLFhxvQ2N9pfqTij1KkX65vHw
NHuexERq+OmWILPCZRJa
=XLGz
-----END PGP SIGNATURE-----

--g4MvFqI7wmANiPDo--
