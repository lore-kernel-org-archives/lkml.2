Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1JORtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:49:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56738 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab1JORtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:49:49 -0400
Message-ID: <4E99C7B7.5060405@nod.at>
Date: Sat, 15 Oct 2011 19:49:43 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OCFS2 1.6.0 for mainline?
References: <4E99A8F3.50206@nod.at> <30236.1318700758@turing-police.cc.vt.edu>
In-Reply-To: <30236.1318700758@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigADC1C807FECB132B6A79784F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigADC1C807FECB132B6A79784F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.10.2011 19:45, schrieb Valdis.Kletnieks@vt.edu:
> On Sat, 15 Oct 2011 17:38:27 +0200, Richard Weinberger said:
>=20
>> http://oss.oracle.com/projects/ocfs2/source.html states:
>> "Active development on OCFS2 happens in the mainline kernel."
>>
>> But the mainline kernel seems to contain only version 1.5.0.
>>
>> Also the linux-next ocfs2 branch has only 1.5.0.
>> git://oss.oracle.com/git/jlbec/linux-2.6.git linux-next
>>
>> Where can I get 1.6.0?
>=20
> Presumably, it's GPL, so you should be able to get a copy from the
> person that told you that 1.6.0 exists. ;)
>=20
> Put differently, why do you think 1.6.0 is available?

http://oss.oracle.com/projects/ocfs2/

"OCFS2 1.6 RELEASE

OCFS2 1.6.3-1 and OCFS2 Tools 1.6.3-1 are the latest versions. The new
features available in this release include Extended Attributes, POSIX
ACLs, REFLINKs, Indexed Directories, Allocation Reservation, Metadata
Checksums and User/Group Quotas."

Looks like it's only available for "Unbreakable Linux" subscribers.
The development seems to be detached from mainline. :-(

Thanks,
//richard


--------------enigADC1C807FECB132B6A79784F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOmce4AAoJEN9758yqZn9eabIH/2GGp2jKq0ofDOKtI9L/Xqui
9MZ8/52J10ga0W+8QNIWVqviVlpjvuoNSiA/6V17wJrU2OKjvzyfQhX5BgOepFIZ
DYnKC7Icv9pE0SRqjnJpt292AFn8jcFMIHeyEqGsRfJkqBGJ8DK6Eu7V526Rg3zl
dgj9QqcQieBdv7b7X/HXafaZRmqVOko2UzT9jTaScyvTO7tC1etpKwpudq2LNTtM
qpXZOp8FjScATJVCKX7xzaTS7V5JaxRFNlDJKxaxlS36+4h1p968J3ycw8l05LYO
Xu4tCqzJkPidlyfTZgqvRbzlQ8pzHAx0EQ0v3E8ahEwL90iOTahuGR9V7jG3Q2A=
=nb0Q
-----END PGP SIGNATURE-----

--------------enigADC1C807FECB132B6A79784F--
