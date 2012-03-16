Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032028Ab2CPXgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:36:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031009Ab2CPXgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:03 -0400
Message-ID: <4F63CE5A.2090809@nod.at>
Date: Sat, 17 Mar 2012 00:35:54 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: apw@canonical.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] checkpatch.pl: Check for functions without a real prototype
References: <4F63AF10.9030101@zytor.com>  <1331939074-26865-1-git-send-email-richard@nod.at> <1331940707.12813.10.camel@joe2Laptop>
In-Reply-To: <1331940707.12813.10.camel@joe2Laptop>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig67E3F4E6EB658B7FA311C088"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig67E3F4E6EB658B7FA311C088
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.03.2012 00:31, schrieb Joe Perches:
> Perhaps this should be:
> 		if ($line =3D~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {

Makes sense.

>> +			ERROR("FUNCTION_NO_PROTOTYPE",
>> +"Function without a real prototype\n" . $herecurr .
>=20
> Sensible, but maybe:
> "Bad function definition - $1() should probably be $1(void)\n"

Too.

>> +"Thou shalt not, in the language of C, under any circumstances, on th=
e
>> +pain of death, declare or define a function with an empty set of
>> +parentheses, for though in the language of C++ it meaneth the same as=

>> +(void), in C it meaneth (...) which is of meaningless as there be no
>> +anchor argument by which the types of the varadic arguments can be
>> +expressed, and which misleadeth the compiler into allowing unsavory c=
ode
>> +and in some cases generate really ugly stuff for varadic handling.
>> +	-hpa\n");
>=20
> Humorous once, painful in twice, annoying after.
>=20

It has to be annoying and painful. :-)

Thanks,
//richard


--------------enig67E3F4E6EB658B7FA311C088
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPY85eAAoJEN9758yqZn9e3SEIAMQUVI+J1A4hjAn+O/t5v/Ot
K1WnIi5X9G8IkO8zlhAFIhhBjfLOHlO/XBVxWa6pYpx8H6ZsZzpaBhd7WAI44Dw7
vWztHsamRTAEGeNoEjy84jNzhi5LPieQQCx9AVaCY9FPAcB0MyLrl5wBpplBbdre
dMQj7Ri3Mi6PFRE5QMs6odYjXaC22jbmRu63ft057E4ySVn7DYBbuJXO6Sa/uBv2
OyVc6tLQs60JjA7DqvAUEGoc49tgnfHT4iCLSq07LLkZwC5IduJ8TPAy8LeQ379p
h7Dx3tXjnc6eI3HP7+2YWsrhAbQxn87SiHfQGGYqpXaBDARDUBhH3O7VyVI9VLg=
=VEqm
-----END PGP SIGNATURE-----

--------------enig67E3F4E6EB658B7FA311C088--
