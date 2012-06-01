Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2FAILA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:11:00 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab2FAIK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:10:57 -0400
Message-ID: <4FC8790D.8070801@nod.at>
Date: Fri, 01 Jun 2012 10:10:53 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337771191-95358-1-git-send-email-richard@nod.at>  <1337771191-95358-2-git-send-email-richard@nod.at>  <4FC85780.9070200@intel.com> <4FC8768E.1010703@nod.at> <1338538244.2536.147.camel@sauron.fi.intel.com>
In-Reply-To: <1338538244.2536.147.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E30CB438074B695CEEF2453"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E30CB438074B695CEEF2453
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 01.06.2012 10:10, schrieb Artem Bityutskiy:
> On Fri, 2012-06-01 at 10:00 +0200, Richard Weinberger wrote:
>> True. But why is this a problem?
>> If we can recovers using a full scan after a power cut we are fine.
>=20
> Does fastmap have zero power-cut tolerance by design?

Yes.
E.g. If the fastmap was not written corretly the CRC will not match and w=
e fall back
to scanning. That's why fastmap tries hard to fallback to scanning if any=
thing goes wrong.
Why should we make fastmap even more complicated than it already is?

Thanks,
//richard




--------------enig1E30CB438074B695CEEF2453
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPyHkOAAoJEN9758yqZn9eGcwH/jiz+9N7xd07v8Ttx7fHmZxh
wTMw1IbIfBfZezWLhHjn2UOv3TG2UUdJTq97ZVtWjX6KXLDo8v/kaB8V1/aKELCl
uWlIvjkZZ/MmhKgkUu/ektm0lnc4U6oWS+FAo8pQDgAOpoIzqfWLx9k5E3ozAJO0
jGrVPoAcNSKzjQOtwEkJR2P5AOEAWSoVOyAo2UKyMKdEbF6Synk4UScPSVt+eRWs
fbdgDxnY+izwe3VjBdM4Fxl8H+u2wN5Z5hRTGuQ1GFlS0Q0uEp7HGZ50uvlVAcaa
3PIcDSIA4q5yHvkna5aahiLN1qSFv9Bm0QfThznLJM9zW+qyG63HQfwR74Hq08M=
=mrC6
-----END PGP SIGNATURE-----

--------------enig1E30CB438074B695CEEF2453--
