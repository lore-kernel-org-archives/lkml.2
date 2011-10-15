Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1JOVMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:12:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33042 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1JOVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:12:49 -0400
Message-ID: <4E99F74C.80900@nod.at>
Date: Sat, 15 Oct 2011 23:12:44 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Valdis.Kletnieks@vt.edu, mfasheh@suse.com, jlbec@evilplan.org,
        ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        license-violation@gpl-violations.org
Subject: Re: OCFS2 1.6.0 for mainline?
References: <4E99A8F3.50206@nod.at> <30236.1318700758@turing-police.cc.vt.edu> <4E99C7B7.5060405@nod.at> <33629.1318706796@turing-police.cc.vt.edu> <CAGZ=bqJb5FGJe264TOtfuzm8dyvWO883NFBnzkyA4M6Fe7Nq_g@mail.gmail.com>
In-Reply-To: <CAGZ=bqJb5FGJe264TOtfuzm8dyvWO883NFBnzkyA4M6Fe7Nq_g@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1EFD5CCC47229DE6BD4318B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1EFD5CCC47229DE6BD4318B8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 15.10.2011 23:03, schrieb Kyle Moffett:
> On Sat, Oct 15, 2011 at 15:26,  <Valdis.Kletnieks@vt.edu> wrote:
>> On Sat, 15 Oct 2011 19:49:43 +0200, Richard Weinberger said:
>>> Am 15.10.2011 19:45, schrieb Valdis.Kletnieks@vt.edu:
>>>> Put differently, why do you think 1.6.0 is available?
>>
>>> OCFS2 1.6.3-1 and OCFS2 Tools 1.6.3-1 are the latest versions. The ne=
w
>>> features available in this release include Extended Attributes, POSIX=

>>> ACLs, REFLINKs, Indexed Directories, Allocation Reservation, Metadata=

>>> Checksums and User/Group Quotas."
>>
>> Nice feature list, I can see why you want it. ;)
>>
>>> Looks like it's only available for "Unbreakable Linux" subscribers.
>>> The development seems to be detached from mainline. :-(
>>
>> Well, you have to admit it *is* an interesting business model - giving=
 release
>> N to your customers and N-1 to the world.  I just got totally mislead =
by the
>> quote from the Oracle site that said the development happens in mainli=
ne. ;)
>=20
> If someone who has a copy of Oracle's "Unbreakable Linux" can get
> ahold of the sources, please put them in GIT somewhere for the rest of
> us to access; it *is* GPLed software after all.  Otherwise, please
> distribute the binaries to the rest of us and we will obtain the
> sources on our own.  I can't find any published information on their
> website about how to obtain the sources, so someone will have to
> contact them directly.

I found this src.rpm:
http://public-yum.oracle.com/repo/OracleLinux/OL6/1/base/x86_64/kernel-ue=
k-2.6.32-100.34.1.el6uek.src.rpm

linux-2.6.32/fs/ocfs2 contains OCFS2 1.6.3.

Mark, Joel, can you please port this "release" to mainline?

Thanks,
//richard


--------------enig1EFD5CCC47229DE6BD4318B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOmfdNAAoJEN9758yqZn9e4uYH/1NQWfB+sHS0xc7VVVSo/+7R
TTN9e2r1SymTL0SQmWwZLdmpJoDl7fHBVELBRvYIaJ0UAjIcNM40TXs/b15vxeLW
P+XH+O4SuTLCzOS5N8eDfWdyi7YjzyG5WzCuBIeEQTmr6FyWT9dsN6B9AvaFl2wM
1o4OPEgMvun1h5Zrcx/2vWG05COr1KhDRO/whGHp5YiHJN7jvyg52AbArPrNezmO
mOIo3Z/cigAAb0gERodf1EUkOgJ3vjSmvgLbjBogtXaQItpaRSt7ZnZXVxHV4gF5
xV5DxVCI/UzMgAHy4W77AGsWscDyD9GDhkK4g0FN9tN3iZPx74goP/t/VyUD0Io=
=oqOW
-----END PGP SIGNATURE-----

--------------enig1EFD5CCC47229DE6BD4318B8--
