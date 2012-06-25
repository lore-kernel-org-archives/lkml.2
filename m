Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2FYWyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:54:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53681 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2FYWyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:54:03 -0400
Date: Tue, 26 Jun 2012 08:53:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>
Subject: Re: linux-next : cpuidle - could you add my tree please
Message-Id: <20120626085349.532133b8b72c92ffa6519043@canb.auug.org.au>
In-Reply-To: <4FE86727.5010400@linaro.org>
References: <4FDEE98D.7010802@linaro.org>
	<4FDF2D58.9010006@ti.com>
	<4FE86727.5010400@linaro.org>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Jun_2012_08_53_49_+1000_Nuiqzk1NuC2Y/NmR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jun_2012_08_53_49_+1000_Nuiqzk1NuC2Y/NmR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Mon, 25 Jun 2012 15:27:03 +0200 Daniel Lezcano <daniel.lezcano@linaro.or=
g> wrote:
>
> we discussed last week to put in place a tree grouping the cpuidle
> modifications [1]. Is it possible to add the tree ?
>=20
> git://git.linaro.org/people/dlezcano/cpuidle-next.git #cpuidle-next
>=20
> It contains for the moment Colin Cross's cpuidle coupled states.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Tue__26_Jun_2012_08_53_49_+1000_Nuiqzk1NuC2Y/NmR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6Ov9AAoJEECxmPOUX5FE4IUP/2q3WNVkErDVVcKmdF2aGXHd
s8puPfgYWRb6JoxPfznHKUL+OR4i+DOcTX423zdxk6vVViAr6LcJ0+L/giEGf/3O
4UPcbo3Or3xFUduiUyCHkhWVRo9LAJsDidak6e9xfZ/3eJdQXdo1E2oPRnWTcKlq
EosOkysGPaafeqRHmQCX9wIV7Pzz33cyBEqnK+CpWmEguPYR4DJ0sOun4AezROLY
aQJ2YXIO9UoIxuwFUcIX97n6T0kAK5XveSiuEu3lHxZiNGebP+3RAL/zQavP9yWH
KOlFboM4gQeOQ4McjHpWsEcR0sgqIGxZRC8RKy/bUZILxGZbVFKzmQB6clHADntn
W0xiAZkWoEk6qw6hizVdD7Bg9Xv18NT9OBUn2tlu6HqLJ82weSIaijdUVr6F0Gd8
z0rmgMFCY84rOVWRsDINoKpkr355AEIN9Yw5kLHlik/bdvj/x9n+p0k6iRMXJEpX
LH0QzsSwwk4qwy0F5SisZyITYhgKqGvEe2gsYXt3uSkhiL0U0xqgtlkGjNSX265n
eIRJ+7gZJizEF+S7/6VTFNqvO/QnCufa5f6wDb66PU1UZhlIQeGXgG+eKpi4bnj5
8sT9mx8uKq2RmNmVOKDsi3fBfBkYbQvovkP2u0enz+uNOpb2Ukcob0RmiuWoSbks
pDusNptPuaBTC0nLwjE0
=onhO
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jun_2012_08_53_49_+1000_Nuiqzk1NuC2Y/NmR--
