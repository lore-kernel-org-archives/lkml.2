Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2FKLnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:43:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41490 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2FKLnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:43:09 -0400
Date: Mon, 11 Jun 2012 19:42:40 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20120611114239.GL11439@opensource.wolfsonmicro.com>
References: <20120530151119.GN9947@opensource.wolfsonmicro.com>
 <4FC63B39.6040905@linaro.org>
 <20120530164152.GP9947@opensource.wolfsonmicro.com>
 <4FC846CC.20801@linaro.org>
 <20120601084850.GJ24139@opensource.wolfsonmicro.com>
 <4FCDDFFC.3000902@linaro.org>
 <20120605103846.GQ23408@opensource.wolfsonmicro.com>
 <4FD5C829.2090408@linaro.org>
 <20120611103606.GG11439@opensource.wolfsonmicro.com>
 <4FD5D679.1070000@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UK1lfQXsnwKrySH9"
Content-Disposition: inline
In-Reply-To: <4FD5D679.1070000@linaro.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UK1lfQXsnwKrySH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 11, 2012 at 12:28:57PM +0100, Lee Jones wrote:
> On 11/06/12 11:36, Mark Brown wrote:

> >Suppose you have two devices of the same type with an array of name
> >based regulators, meaning the nodes with constraints have to have a
> >particular name in order to be matched to the regulator.  How would a
> >consumer reference a node to specify a supply?

> some-regulators {
>     compatible =3D "protect_me_from_similarly_named_regulators";
>=20
>     regulator_node_name_reg: regulator_node_name {
>         <blah>
>     };
> };

> [supply_name]-supply =3D <&regulator_node_name>;

I'm not 100% sure you read what I wrote above or in all the previous
mails about having two devices of the same type?  The case where we have
only one regulator of a given type obviously works otherwise people
would have noticed, the problem starts when you have two of the same
regulator device down.

--UK1lfQXsnwKrySH9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1dfLAAoJEBus8iNuMP3dGZsQAItJx+43SyrvRwDgRelRZAP8
9NhFKBQJwdJf9bycG+rtRojDTK1yO2ekyGU69gq9oBAMW+Ju3ZPfENLzDD8LsWPA
hgz8P1/rutWYAIghnPywENfov2zU94j9ivB4iRcCRvF04kvqv9sGivHQsnZOMG/Y
PR45ZLdJ0jdkzWa7rou/HvRBVxHDFxBoFVOFWHGdbDsiY9cTRZdALwjNDfphe34d
oVhWGBQe5PWayLa41Nv4hjayotIzRgLDjyJGXoWE5XBu5OU7yNFsK1gS0hL8f3Vx
7boTearnGBxGOHxIQck7Jb8vkvCnNkJvsI7ktaqpzREf9I7WS7kjHd1MYZFTTAop
aMYHyK5geghwHgu7TwnooxdX+7V4nbTOI902LxADKdKLDRIMaYB6qM1twNtdj7mK
hog1iP+ldrv61EJ0mWyedajn3NkcW00MUVwX85dkgT+ISSM5I9D86FKCjVFfddRW
1Wi3h6OwdJQniCklsK4jzAUzDMjIOWr4xulzGYYMYIX1Lo+TmzU3EO7c1nv0nZxP
SPDTFlpRYvDfa2y/5DQQsbp/NR0aqwCuhRpWM/SXi456XC4qNsgbervVQNfdX2IE
32jYAuSUq0Js8pAZ8VLdD4OqFfVKSBYMzDpb26b3nVFTwgHZHqlDCTkZVnLfccji
lwkdMN+32/s3tkVkBNmz
=FDFD
-----END PGP SIGNATURE-----

--UK1lfQXsnwKrySH9--
