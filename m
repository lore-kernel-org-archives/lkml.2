Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2CBPCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:02:43 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab2CBPCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:02:41 -0500
Message-ID: <4F50E10B.6040806@nod.at>
Date: Fri, 02 Mar 2012 16:02:35 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ian.Campbell@citrix.com,
        florian@mickler.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: Add support for moderated lists
References: <1330544962-995-1-git-send-email-richard@nod.at>  <1330545526.22465.5.camel@joe2Laptop> <4F4E8555.5040002@nod.at>  <20120229160254.eda62e01.akpm@linux-foundation.org> <1330564646.23314.23.camel@joe2Laptop>
In-Reply-To: <1330564646.23314.23.camel@joe2Laptop>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF618CCC855228CD2C1F176FB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF618CCC855228CD2C1F176FB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 01.03.2012 02:17, schrieb Joe Perches:
> On Wed, 2012-02-29 at 16:02 -0800, Andrew Morton wrote:
>> On Wed, 29 Feb 2012 21:06:45 +0100
>> Richard Weinberger <richard@nod.at> wrote:
>>
>>> Am 29.02.2012 20:58, schrieb Joe Perches:
>>>> <shrug>  From my perspective, it's correct and simple.
>>>>
>>>> Moderated lists just means your email may get delayed
>>>> and you may get a "delayed due to moderation" email.
>>>
>>> Most moderated lists are "moderated" by nobody and the patch
>>> goes to /dev/null.
>>
>> That's a big problem - we don't want people to send their fixes and bu=
g
>> reports into black holes.
>>
>> So yes, I think that teaching get_maintainer to emit black hole
>> warnings is a good idea.
>>
>> Problem is, I don't think the string "moderated" explains the situatio=
n
>> very well for the uninitiated :(
>=20
> It's also false.  Most moderated lists in MAINTAINERS
> (and I've probably send patches to most of them) are
> in fact moderated.

What about linux@lists.openrisc.net?
None of my patches shows up there:
http://lists.openrisc.net/pipermail/openrisc/

> My patches generally show up in their list archives.
>=20

You must be a lucky guy. ;-)

Thanks,
//richard


--------------enigF618CCC855228CD2C1F176FB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPUOEMAAoJEN9758yqZn9e0PQIANVJJfmWlmoNq1sG3i5+Xj8C
T0YrOKAbJ4vW4tC0TvD/c/iA8N01ttYRkP0qOLXSp2DsxKn7n8oRceNSkqjQTsWU
a6X86CwWiwzXhek1wSqfx+7g6BvpcSFj8bcsv3KK9GgbDd8VFFObEAwwotBaBrrW
w0rNRQrAspvB6yx2alVSgoejbmgm6bhIJAvHpYJbKFJQsVVReILEnRnw3da/emYX
QP03Zdse87CChIxWuKI6QQBcHl6qs7Zxk8uN6upSPeLboinfToDCnf3oqJw27VJ6
eq3geRDPD3rQ6+NEbmOneWr1S6nMyj7eoj/kKVmZSsKcefT751Xh53iNe7/5In8=
=sO13
-----END PGP SIGNATURE-----

--------------enigF618CCC855228CD2C1F176FB--
