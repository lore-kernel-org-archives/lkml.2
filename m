Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2LUQ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:28:17 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54952 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab2LUQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:28:08 -0500
X-Sasl-enc: PUDUSwWPlWJrB+mHSS50XfpEtKpWrB3/zTAeiZJiJwWf 1356107287
Message-ID: <50D48E0D.7000207@imap.cc>
Date: Fri, 21 Dec 2012 17:27:57 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.2
References: <1355754352-5133-1-git-send-email-herton.krzesinski@canonical.com>
In-Reply-To: <1355754352-5133-1-git-send-email-herton.krzesinski@canonical.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8B7779CDB87728FDB512DB92"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B7779CDB87728FDB512DB92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.12.2012 15:25, schrieb Herton Ronaldo Krzesinski:
> I am announcing the release of the 3.5.7.2 tree of stable patches.
[...]
> For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable
>=20
> The updated 3.5.y tree can be found at:=20
>=20
>   git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

Is there a rollup patch against 3.5.7 available somewhere?
I'm very interested in this as I'm currently forced to stay with
kernel 3.5 (or revert to something even older) because of the
unresolved hangs of 3.6+ on my development machine.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)



--------------enig8B7779CDB87728FDB512DB92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlDUjhYACgkQMdB4Whm86/ld0QCdEh/MJpjGIvi68Wy7Pn/x4B4B
slkAnjRorTGER5rSen5zamNDFSqIaAeZ
=/xuE
-----END PGP SIGNATURE-----

--------------enig8B7779CDB87728FDB512DB92--
