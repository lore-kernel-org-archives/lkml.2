Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab2K1NPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:15:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51985 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079Ab2K1NPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:15:43 -0500
Date: Wed, 28 Nov 2012 13:15:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Navada Kanyana, Mukund" <navada@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Message-ID: <20121128131539.GP32691@opensource.wolfsonmicro.com>
References: <n>
 <1354094577-14967-1-git-send-email-navada@ti.com>
 <20121128092924.GJ32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
 <20121128113443.GM32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959B6C@DBDE01.ent.ti.com>
 <20121128115638.GO32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959B84@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LW0Rr0Uq98qh6Rv"
Content-Disposition: inline
In-Reply-To: <6817C817C9581447825BFB369EAC42163E959B84@DBDE01.ent.ti.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LW0Rr0Uq98qh6Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 28, 2012 at 12:10:21PM +0000, Navada Kanyana, Mukund wrote:

To repeat, fix your mailer to word wrap within paragraphs.

> > You appear to have two different ranges with the same selector and
> > window.  I'm really not sure why you expect this to work...  what
> > happens when someone reads from the two different ranges simultaneously?

> The selector register has to written appropriate page number. Two
> different ranges cannot be accessed simultaneously without changing
> the page number in the selector register.

This would be exactly the problem, yes.  In any case, this looks like
user error.  You shouldn't be using the same window twice.

--1LW0Rr0Uq98qh6Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtg5dAAoJELSic+t+oim9NG0QAJledBSKL6EnhkSyvc/Ha8Vd
9aMGrqsM88wByK0g6QRuELQsWwdJsleHRsSlXghX1EE/hMPw2F1iYSjhxKHB/fD0
lqBw/KgyZ96r/CMHl3gklIqliwP1DmPQwKFhAJ65pnHbc+0l4g1lHJQWT6jBftT0
YLv/y7oeT75nFCxLs33qzHS34mENtU7Z1MDjxT/j8IUVFU9zrLguHAx3f+J+5Omk
6su3IMEgyHG/6zadBNb4715IEyspcT2g3uxPocFWfdYuAjXuTEgI74/ou1TnzA8R
8MLtqvf4U7tvVzpbkWTa6jiP1OBY6Kf/ZYv8EGXvstoVrITrX50Tx+aBFlHENLr6
DbOfJFcSeB5QDCCUtZIIfFav3ZG+6We4FmbgxhCgrejrqXXqcWppN4Aj+zEXY9DZ
6HJfi3y4yhOjsZtkjrxnXWSjWKp7lWPsg8vp1v45wE659TEeqbJinLcsUCEMq9eA
KZmxmZjk8F7a/XVmogg1poiCWKDNLSA6FtYqIcXMKynBTptlQrPw7luVYbysbFO7
NBuRWFt6jnaeA5YB1mLffNeHK3xU/eOzzaK7sGdODQ31Q2ht7W7nNFSWXyXygxOM
H+GCJ3wnMGKI9gI7UuxwgPqVxdCbFP8K2cs18l4vMN/wSFWyey/2fuN6ULbXDni6
QfMpwRSd8n4m+y5mmues
=yKw2
-----END PGP SIGNATURE-----

--1LW0Rr0Uq98qh6Rv--
