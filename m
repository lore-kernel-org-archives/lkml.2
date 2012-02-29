Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2B2Iec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:34:32 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab2B2Ieb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:34:31 -0500
Message-ID: <4F4DE30B.4060506@nod.at>
Date: Wed, 29 Feb 2012 09:34:19 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] OpenRISC: Fix audit_syscall_exit() usage
References: <1330476393-14264-1-git-send-email-richard@nod.at> <1330501592.2964.1.camel@crucifix>
In-Reply-To: <1330501592.2964.1.camel@crucifix>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig55B7EB4049EF4EEBAB37C36C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig55B7EB4049EF4EEBAB37C36C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 29.02.2012 08:46, schrieb Jonas Bonn:
>=20
> Thanks, Richard.  There is, however, already a patch in linux-next that=

> provides this fix.

No problem.
Why is the fix not in Linus' tree?
We are already at 3.3-rc5...

Thanks,
//richard


--------------enig55B7EB4049EF4EEBAB37C36C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPTeMTAAoJEN9758yqZn9evgAH/2RCxf48dUFEPuTpjtw+wb4j
dCR4vepsUIdcGwA3a98Uaj26IB7pgBLg85HgleD3Fp0aQrB5KC43Fq0mb7NquKv/
d2xaGPzYPxgwbYV2GLNEZFQy+LPouR5itS/mgffQTslC6LHDXpSdm7H49FKj7bnn
XDpv0EbE0ZiACEvDozsNSFjR8fjQqVLh0IuPKcrZ2ySUIgEdYsffRsF13/7U3xqa
LaX+H35QyleGhagv8FS3LY0nJxOBI8o6SwZRqmKbC2TGOyN6arSHBa7qZp49Xpz0
qJQ6jgM7IY30r4lMZ3J32MNRUWeG/Z3fI82gLjeXnbmWeZhPJLbcvznCEPi87gY=
=u4X/
-----END PGP SIGNATURE-----

--------------enig55B7EB4049EF4EEBAB37C36C--
