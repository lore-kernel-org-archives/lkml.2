Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab2AEWQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:16:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37251 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218Ab2AEWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:16:01 -0500
Date: Fri, 6 Jan 2012 09:15:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: linux-next: manual merge of the selinux tree with the net-next
 tree
Message-Id: <20120106091550.534131cb1fe6e3dee323699c@canb.auug.org.au>
In-Reply-To: <27624574.j8RvKjachg@sifl>
References: <20120105151255.f72ad113a93493bb55844034@canb.auug.org.au>
	<27624574.j8RvKjachg@sifl>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_09_15_50_+1100_f7Q/N/GKLRBCvOZA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_09_15_50_+1100_f7Q/N/GKLRBCvOZA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 05 Jan 2012 16:25:53 -0500 Paul Moore <pmoore@redhat.com> wrote:
>
> On Thursday, January 05, 2012 03:12:55 PM Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the selinux tree got a conflict in
> > net/bluetooth/l2cap_sock.c between commit 15770b1ab974 ("Bluetooth:
> > convert force_active variable to flag in l2cap chan") from the net-next
> > tree and commit 53860f3d0499 ("bluetooth: Properly clone LSM attributes
> > to newly created child connections") from the selinux tree.
> >=20
> > These both remove the same line, but there is probably something more
> > subtle going on ...  I just used the version from the net-next tree.
>=20
> Something is a bit odd.  When I look in the current linux-next tree I see=
 two=20
> commits which fix a Bluetooth/LSM bug; the first is correct, the second o=
ne=20
> appears to be some other commit which just hijacked the description from =
the=20
> first ... I have no idea what is going on in the second commit; I'll leav=
e=20
> that to you git gurus :)
>=20
>  * Correct commit -> 6230c9b4f8957c8938ee4cf2d03166d3c2dc89de

That is a commit in Linus' tree before v3.1

>  * Garbage commit -> 53860f3d0499992855d58e33f0f79bfe642dfccb

That is the commit in the selinux tree.  This should be unnecessary as
the selinux tree is based on v3.1 (and I basically ignored it in the
merge resolution).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_09_15_50_+1100_f7Q/N/GKLRBCvOZA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBiEWAAoJEECxmPOUX5FEMZMP/i+miHsN7mlL28u1F8NFO1m4
+f2fGQW3pMCD68TrXNiB7hIxQvL3yvOr47dF29h75buFrZ0J/uwdHH7K8QrgArSS
8+Wz7Sf406gPWl0USG9PK0kIaTSMbD7FiQyYb0jtydWk0uZEuo7utU1AkQI89ZXZ
CTebAiwXZyVfyWfeqbVegiEdadEl8OGAGOsUvvrTIo6Cmk3InAozWPSiNlAXYb2s
9uct3YE04jntb6iNCnwVLPonoBsOhi1KFFBHyEFnHDfYONheoFJB0EAZblTEiequ
QPIHPbxX5VMmBujT3uvVYIzQupdsy3z4YMnf2UMS4dvNmG0Q5+3DrKqBz1tQC9hs
vTjbIr4XlqKWRmSwpqnGSXJH8xszARQrTEnZe7G3URi4EewX2kZwGHHc2x+5S/Xw
i8XP5SQwAXlv5retXUneVq8I02atsyq5JRUzTiBVcsM/Jkd0JOWlg1MnlP6THNSh
Y9xKTgrtExSb5ILtGqnAdGQcjGc3M7Pmaw79Do0kU5V1bKmcclrhDeNmK+pzl7ir
IBdiOamrkrxQrRlsdYn5cWxp/DwDkwPn1c62HiOzcj/xhtzK3BO9ZqqpIbWSNW6q
IFo1gRdcV1TmXCWBenDC9Mk4UOcfRgsbbfGIZv3c+LyBF/0/Ffq/I1fX2uEV2kLM
QQ3NVrUIIp+j559f3SsQ
=ZCoB
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_09_15_50_+1100_f7Q/N/GKLRBCvOZA--
