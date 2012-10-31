Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab2JaTnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:43:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38466 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208Ab2JaTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:43:22 -0400
Message-ID: <50917F52.600@kernel.org>
Date: Wed, 31 Oct 2012 15:43:14 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: new daily bugzilla.kernel.org annoyance messages
References: <20121031163005.GA411@kroah.com> <5091535C.9050103@kernel.org> <20121031164504.GB1119@kroah.com> <20121031170159.582acdf6@pyramind.ukuu.org.uk>
In-Reply-To: <20121031170159.582acdf6@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig72A4499BA88DA6B212ACDCCE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig72A4499BA88DA6B212ACDCCE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/10/12 01:01 PM, Alan Cox wrote:
> Is there any chance of also setting it so that anyone who is assigned a=

> bug can close it not just a few people with magical powers and the file=
r ?

I'm not that adept at bugzilla admin bits yet (clearly), but if I'm
reading the docs correctly, the assignee should be allowed to do pretty
much anything with the bugs:

"By default, assignees, QA owners and users with editbugs privileges can
edit all fields of bugs, except group restrictions (unless they are
members of the groups they are trying to change)."

Is that not the case?

Regards,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enig72A4499BA88DA6B212ACDCCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQGcBAEBAgAGBQJQkX9SAAoJEI6WedmufEle76IL/RieMJUclb3oBnRNX2bNjOLn
jb3TyhmCbriOx/X/0V2ddjwtz/Re6fiWXMiAEsd+SgyedZCN0AXmaFkR6GgVwPiZ
Xp/i+4s/IXnIjtJP4OK0LIZ1qO3QkBIltjpZoeP49veUvA+Nyzm7zHqCTjKgikyD
C1kNsgiUecBvkYbJHEbFq8CX8OK/lOVfq7j+KeCAH4Zhs+JoJY0b3gCNGSy8+5w6
LqCi96y6H4g4qpKIeAUm2Pa1m6lLN7/07K6hq+zt0FUAlSd5HNPi4YoagnZhWKXH
wt0cAG+TA9RragpFZcm018L997FmWntan7th5bE2tz5zd43nuqIl27eLa4lshjHm
vUirEqkENKxHd19EeYt0jhH2Kv7GDGOPz7/jsrwHd6uAP74waqD9bXgIa6Wtlbbe
AbY9kpFXMexAQsVfl74TeTzWTl7UwyoKyH856Qehuu0nsD1gq1u7ajka8e12N8xR
esePAefzKRhwbxMhuhdecjvceUGszxcEH3YwM5cCLg==
=gZVZ
-----END PGP SIGNATURE-----

--------------enig72A4499BA88DA6B212ACDCCE--
