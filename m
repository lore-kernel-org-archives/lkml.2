Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab2BJLrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:47:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37437 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab2BJLrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:47:15 -0500
Date: Fri, 10 Feb 2012 11:47:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix kcalloc parameters swapped
Message-ID: <20120210114713.GC6472@opensource.wolfsonmicro.com>
References: <1328873395.4203.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <1328873395.4203.1.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 07:29:55PM +0800, Axel Lin wrote:
> The first parameter should be "number of elements" and the second parameter
> should be "element size".

Applied, thanks.  Not that it makes any practical difference given that
the function will just multiply the two numbers...

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNQOhAAoJEBus8iNuMP3dYAwQAJ00nw1f9IF7qsP4RHZhIc+w
maGZ357/041dna8lAxrKR4TSh+Xu5o2owl7Pjh15oK58Ko6gsv3jOSVI2ovQd8Y1
X1CUENEdwD3o8SPiIew+gvyqOU+/5pGxMsLqsrMeraeakIZQIUZn1wTjH3lvL0LP
CqZjMzXNY0/zi1EmyxOE4EHrTyz4zPeTUMD7hldICwlNsfvg6qba/3oIWXsiZu8D
b70qCd/iVNR/zGo0S4eZnAihdwP1Yj4dIIqT9IHyR6ydXjeTwqCSLDA79iks9dWv
jxI1LRa5BLZhm075Cis1y4A22S+25y2dZOqN2njvvTHHY8zDsytm5ux/Rt2o0ER7
G2z/ljHupx9LhgWC76skH4pJtwxEL4bVpGESgUFpcyPrWkEjWfZbKbBqZUSVn/4v
+hX70avlQWSQfXtONecfz3n7JRkNCXEw8clVrjAiYac4Lggfv0YKCUrJPEKUMCiG
36/gbcRoER70IeVLA3BH4oY1uTbDzwxKaYFVQ4CpMxnwDbSqoprQKKYZAsNJNYQn
HJJJTHcJN/bwUpM53+2O4quUmHu5IFBBfNxRckTmJmsGJpfrDuyrWaEy7SBkdjuU
RlnwU1Hgp0u4j5ZiPLlStA9fJMiXpZZfoUvivz63vPzIWFMnABLo7BoaIplebj1w
lnat8fWslQW9HQ5FFxhV
=BNZr
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
