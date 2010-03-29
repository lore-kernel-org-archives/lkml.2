Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0C2R5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:57:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41074 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755264Ab0C2R5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:57:17 -0400
X-Sasl-enc: Tudj637ujeJc8B+sk9oXHTiaBTjcWlOV/E4KKVbN00hK 1269885435
Message-ID: <4BB0E937.7070200@imap.cc>
Date: Mon, 29 Mar 2010 19:53:59 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
References: <4BA689EA.4050102@imap.cc> <20100329150946.GB2569@linux.vnet.ibm.com>
In-Reply-To: <20100329150946.GB2569@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4C735A898F90C2AC33AE0A2D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4C735A898F90C2AC33AE0A2D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 29.03.2010 17:09 schrieb Paul E. McKenney:
> On Sun, Mar 21, 2010 at 10:04:42PM +0100, Tilman Schmidt wrote:
[...]
>> So if building a proprietary module fails with the message:
>>
>> FATAL: modpost: GPL-incompatible module <module> uses GPL-only symbol
>> 'rcu_lock_map'
>>
>> try rebuilding your kernel with the PROVE_RCU option disabled.
>>
>> Hope it helps someone.
>=20
> I am comfortable with PROVE_RCU being incompatible with non-GPL modules=
=2E
> After all, it is only a debugging option, not intended for production u=
se.

I agree completely. I just wanted to publish that fact because it seems
to be little known and can be quite a puzzler.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4C735A898F90C2AC33AE0A2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuw6UIACgkQQ3+did9BuFvuSwCePYphSQsEmtHdCGTF9NeZX3BI
IugAn1wCJ3Gz7Ni7PfifIQt9vP7nMKNN
=5yw2
-----END PGP SIGNATURE-----

--------------enig4C735A898F90C2AC33AE0A2D--
