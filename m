Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0GFUcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 16:32:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43536 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541Ab0GFUcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 16:32:14 -0400
X-Sasl-enc: dc7H4YOCpJS3OF0yfajQ+ajYdGJDZyROi5yXzf0q6Pce 1278448330
Message-ID: <4C3392BE.4050009@imap.cc>
Date: Tue, 06 Jul 2010 22:31:58 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] isdn/gigaset: improve CAPI message debugging
References: <20100705-patch-gigaset-05.tilman@imap.cc>	<20100705.192356.52184135.davem@davemloft.net>	<4C32E5FD.70103@imap.cc> <20100706.104411.235698140.davem@davemloft.net>
In-Reply-To: <20100706.104411.235698140.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D0953E89D07A3F17E236BCC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D0953E89D07A3F17E236BCC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 06.07.2010 19:44 schrieb David Miller:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Tue, 06 Jul 2010 10:14:53 +0200
>=20
>> So if you'll postpone applying last night's series until
>> after your next merge of net-2.6 into net-next-2.6, it
>> should then apply cleanly.
>=20
> That's the kind of information I'd like to see from you when you
> post patches which have such dependencies.

Understood. It's just that I had thought my "for 2.6.35" patches
had already been applied to net-next-2.6, anyway. When I got
your complaint I noticed I had been mistaken. Sorry for that.
I know how that mistake arose, and it won't happen again.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7D0953E89D07A3F17E236BCC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkwzkscACgkQQ3+did9BuFv16wCfYs3M+itXhNeb0ojrDOenYJ3y
jy4AnAzfDIO55Ml3uyjZJMRgPF2rf2aH
=kzfk
-----END PGP SIGNATURE-----

--------------enig7D0953E89D07A3F17E236BCC--
