Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1KCWS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:18:59 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34558 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1KCWS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:18:58 -0400
Message-ID: <4EB3134E.8080102@nod.at>
Date: Thu, 03 Nov 2011 23:18:54 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
Subject: Re: [GIT PULL] UML changes for 3.2
References: <4EB14F51.1050004@nod.at>  <1320348750.14409.249.camel@x61.thuisdomein>  <1320352899.14409.260.camel@x61.thuisdomein>  <1320354072.14409.265.camel@x61.thuisdomein>  <4EB3045A.6050501@nod.at>  <1320355503.14409.269.camel@x61.thuisdomein>  <4EB30994.9050309@nod.at>  <1320357369.14409.276.camel@x61.thuisdomein> <1320358228.14409.279.camel@x61.thuisdomein>
In-Reply-To: <1320358228.14409.279.camel@x61.thuisdomein>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA4D07677933842359159EB2B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA4D07677933842359159EB2B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.11.2011 23:10, schrieb Paul Bolle:
> On Thu, 2011-11-03 at 22:56 +0100, Paul Bolle wrote:
>> These Makefiles always make me nervous. Is SUBARCH set by the time the=

>> update-po-config target is run? If so, we could simply do "env SUBARCH=
=3D
>> $(SUBARCH) [...]". But how do I check that SUBARCH really is set (ie,
>> that I'm not passing env an empty string)?
>=20
> It seems the trick here should be
>     env SUBARCH=3D$(KBUILD_BUILDHOST) [...]
>=20
> Michal, does that make sense?
>=20

Beware, it's also possible to set it by hand.
E.g. for building a i386 UML on x86_64.
make linux ARCH=3Dum SUBARCH=3Di386.

As long no inclusion of another Kconfig file depends on SUBARCH, setting
it to the empty string is ok.

Thanks,
//richard


--------------enigA4D07677933842359159EB2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJOsxNOAAoJEN9758yqZn9evlYH/3c0kDmXnwzKRIUKdK14RVJK
cIWCbjs95s+l4s5HXQw0Y4p+gO4J7ZaVAarlf2r+WDVAOSvh40D1CyZPIbG8yX9j
Qn/lJBWLMOvtek1LlzfUp7j+8b/VTu6KLfE+RCifOZqqIw5mCLWUi8EeeoxT1WLj
/9kWv3kIpcCWkwGlbKO4SQpfmerElCZQds4IO44drTZ39xiN0y80TE3qmReE1w2q
YUdzMfvN0zGx31FV4E2DBNeSt/BB0zzM27Kkq0SY0x4LUz1O27N40SNyE3awvm/e
P4A5Hup0DEptMCwwNHfd9jq9n1edYp2mctb5Y2CwSzKdvIxkxEGmwUvJV4Z1QG8=
=4eTw
-----END PGP SIGNATURE-----

--------------enigA4D07677933842359159EB2B--
