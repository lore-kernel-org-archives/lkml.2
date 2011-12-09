Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab1LIFp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 00:45:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44364 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1LIFpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 00:45:52 -0500
Date: Fri, 9 Dec 2011 16:45:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>
Cc: Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the tegra tree with the  tree
Message-Id: <20111209164537.8739df79c3a1733dea4295af@canb.auug.org.au>
In-Reply-To: <4EE1907F.5000003@nvidia.com>
References: <20111209114736.d418deb7228f2b544434b77b@canb.auug.org.au>
	<4EE1907F.5000003@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_16_45_37_+1100_J4PICFsug201Z90i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_16_45_37_+1100_J4PICFsug201Z90i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, 08 Dec 2011 21:37:19 -0700 Stephen Warren <swarren@nvidia.com> wrot=
e:
>
> I'm not very familiar with git diff for merge conflicts, so I might be
> wrong here, but I did reproduce this conflict to investigate, and I
> think your fixup isn't quite correct.
>=20
> I think you're left with two separate copies of the macro
> arch_ret_to_user, and your conflict resolution diff should be more like
> that below:

Good catch!  I have fixed it up for next time.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Dec_2011_16_45_37_+1100_J4PICFsug201Z90i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4aCBAAoJEECxmPOUX5FEUdsP/244dnYXEGOukfulpoe1MRaZ
fihZMqSpWg70NTMoe/cMMdFOt9gcsqRIoRuxSnnNOmyw+No2vN3g3mQHGgovd41x
WK5/CbkaBuGuI6R4A8JDkizUFQeQ6zuviV9HTOntteFPJpX7fR18l9gMiZsmnZIK
yvfNs3ZFgzrzx1rYputak05v5m21MebyEQLhN9gS33mcT4mQ7+0rDyZFS4wdIfmP
8hdLrC5djN8V8Pzi8Qv5zc4a2nfIKHvn8rtGRFXf5YdFtAB0VGJ5WYykDqBF6tfy
Cz5PNL7I7uioFKR23ThhlnDLM2pB6110V3VsjhdTdCtDyNA5Ek1QoEWDF1GXlzSX
HaXV1DgRLOAEki7kYmQrDxkXx7N9yvbhJFCL/8a/IEehBzqP/NiWhrokjeZ6sOYa
WQkfGDI9kNKKnL0pW9zPs+6Mu18YxeTAHq0cGcAsvV5D7CYaF3QKNR3T6hAkUapN
tHk65XPjcxzdvsLK7oaxFD5Jj68Q7Xtvm0djl1OUFwU82Yze5jJLBGy/tozvCGBw
JQhOX0KlQF39/DCgX5/TH2aTJagGPakSNZmzuP5SSjAmpdgAilRrxGigdZ7SWNgj
NAzHAhsDNkxw0rek01CqNmuXcHxvUJard20NMu7pCISHx944KWJJEX/OzqRVQ4Xn
iZCogz80ek1mrncUAThE
=wO2S
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_16_45_37_+1100_J4PICFsug201Z90i--
