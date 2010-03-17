Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0CQRdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:33:19 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49321 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850Ab0CQRdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:33:18 -0400
X-Sasl-enc: 7+iwGUZpHU6pLgjxUlC4Cmdq6/dc6lAR7kbCxAUSLlfj 1268847196
Message-ID: <4BA111B3.3040108@imap.cc>
Date: Wed, 17 Mar 2010 18:30:27 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: linux-next: Tree for March 17 (gigaset isdn)
References: <20100317160803.78c63f94.sfr@canb.auug.org.au> <4BA0F78F.9090804@oracle.com>
In-Reply-To: <4BA0F78F.9090804@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD2453755781AE0EC2A96753F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD2453755781AE0EC2A96753F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 17.03.2010 16:38 schrieb Randy Dunlap:
> On 03/16/10 22:08, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20100316:
>=20
>=20
> ERROR: "gigaset_isdn_regdev" [drivers/isdn/gigaset/gigaset.ko] undefine=
d!
> ERROR: "gigaset_isdn_regdrv" [drivers/isdn/gigaset/gigaset.ko] undefine=
d!
> ERROR: "gigaset_isdn_unregdrv" [drivers/isdn/gigaset/gigaset.ko] undefi=
ned!
> ERROR: "gigaset_isdn_unregdev" [drivers/isdn/gigaset/gigaset.ko] undefi=
ned!
>=20
> when
> # CONFIG_ISDN_I4L is not set
> # CONFIG_ISDN_CAPI is not set
> CONFIG_ISDN_DRV_GIGASET=3Dm # or =3Dy
>=20

Rats, you're right. Sorry for the oversight. I will create a fix right aw=
ay.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD2453755781AE0EC2A96753F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuhEb0ACgkQQ3+did9BuFvGEACffyXNiVqTjJcNxwDvvRgDl025
j5oAn0I9akJDhJEQ22Z89207kOQK5W9r
=rDCq
-----END PGP SIGNATURE-----

--------------enigD2453755781AE0EC2A96753F--
