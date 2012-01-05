Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2AEWEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:04:06 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab2AEWEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:04:05 -0500
Message-ID: <4F061E4F.4080103@nod.at>
Date: Thu, 05 Jan 2012 23:03:59 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] init: Warn on non-existent rdinit
References: <1325789819-30502-1-git-send-email-richard@nod.at> <m14nw9c1me.fsf@fess.ebiederm.org> <4F0619F9.8010505@nod.at> <m1vcopajxy.fsf@fess.ebiederm.org>
In-Reply-To: <m1vcopajxy.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F52BC6C228FF9F14461AD26"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F52BC6C228FF9F14461AD26
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 05.01.2012 23:00, schrieb Eric W. Biederman:
> Perhaps it has a /linuxrc.  If you can find a way of figuring out we
> always need the file we can print an error.  Otherwise it is a case of
> the kernel auto-detecting what to do, and not printing a warning when i=
t
> has decided there is no /init to play with.
>=20

If i find a nice way, I'll post a patch.

In my case I had a kernel with a built-in initramfs which contained a /li=
nuxrc, but no /init.
I had no clue why the kernel always tried to boot from root=3D.

Thanks,
//richard



--------------enig8F52BC6C228FF9F14461AD26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPBh5PAAoJEN9758yqZn9eEYkIAK2oTajA3+iv4imuFSqtsAso
Ws1hRnBFK22vKTtloSfGaUbIbAiyCQrvOux1a6wiX+uhxpchhIMvDZ0qYwk8k0VY
WldBCE/TQbpO+jpJ2bkwqUwpuDQtszMe4U86530+rWp3us1SDhmKYhFJMHgLoqpq
rhKHboNW+9axFNFU+kz8tVBDViEHr1uNO1MSr8jRdeEhkBHXiJnfTo3K/OVcrtWk
DF5dkPTZ6TtbgwgTB14rLRy06T02WYiqdYcDGsybuIWp8Q1OcR+mwAgQ+CVmrsdB
nakoZP7OJvyHI0PStQSQfrOIBiOX9ca/6CaLeKZDPPBNZCBAGKVyWSNge5cmsWE=
=GDZB
-----END PGP SIGNATURE-----

--------------enig8F52BC6C228FF9F14461AD26--
