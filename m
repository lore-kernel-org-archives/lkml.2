Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2ANPeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 10:34:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab2ANPeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 10:34:11 -0500
Message-ID: <4F11A06A.3040703@nod.at>
Date: Sat, 14 Jan 2012 16:34:02 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: Use UBI_LAYOUT_VOLUME_{TYPE, ALIGN}
References: <1326214623-15938-1-git-send-email-richard@nod.at> <1326553866.14299.0.camel@sauron.fi.intel.com>
In-Reply-To: <1326553866.14299.0.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE781820EAD50F4F34660D366"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE781820EAD50F4F34660D366
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 14.01.2012 16:11, schrieb Artem Bityutskiy:
> On Tue, 2012-01-10 at 17:57 +0100, Richard Weinberger wrote:
>> UBI_LAYOUT_VOLUME_TYPE and UBI_LAYOUT_VOLUME_ALIGN are currently
>> defined but not used.
>> Use them at least once. 8-)
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>=20
> Hi Richard,
>=20
> This will break backward compatibility - older and current kernels whic=
h
> do not have this patch will error out when the find a volume without a
> name. The right way to do this would be to change the UBI format
> version, but you would need a really strong reason for this.
>=20

Sorry, this comment makes absolutely no sense.

Did you mean my other patch?
But still, the other patch also does *not* allow volumes without names.

Confused,
//richard


--------------enigE781820EAD50F4F34660D366
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPEaBuAAoJEN9758yqZn9eH4UH/ju+IQ8oBuYVmcBrWB15D5Qa
a6PSDdrFLY9l88ZHEu6MaEaPslltY+uiVniCpYCfu9YhHUsfNbMUqBWmDeyVZoFm
Lr3NasTsp5e7A74QstLeWaKYgK+Amjje/mbf4LA04QxwtBcOxdM48vB+eYs8H4mw
T3R8HPdQpfnDnndJbxCAq0HU+3cPZyotpZa2Hiv2ZueWU0qvumWoepGlXaLXcBpO
rNHRtoZqvK2KRn9gkb0tSlSM4p6xjpF0vbgBXT2KMtCdIxw1L+2VSZDaCR0yswce
PPrZZ7W4gNf6ODHdnGGLhIST+zMjfoFe1/fUud15U9pJf/AKSaHTLUCu23w/dnQ=
=7HuU
-----END PGP SIGNATURE-----

--------------enigE781820EAD50F4F34660D366--
