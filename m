Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2BGXwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:52:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40168 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2BGXwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:52:39 -0500
Date: Wed, 8 Feb 2012 10:52:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the sound-asoc tree
Message-Id: <20120208105228.a3b2ceeaba1a63e5df9dfbbc@canb.auug.org.au>
In-Reply-To: <20120203105123.GB3151@opensource.wolfsonmicro.com>
References: <20120203125902.558e273c84b339957869f281@canb.auug.org.au>
	<20120203105123.GB3151@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__8_Feb_2012_10_52_28_+1100_z681Py=ybApKpNKc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Feb_2012_10_52_28_+1100_z681Py=ybApKpNKc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Fri, 3 Feb 2012 10:51:24 +0000 Mark Brown <broonie@opensource.wolfsonmic=
ro.com> wrote:
>
> On Fri, Feb 03, 2012 at 12:59:02PM +1100, Stephen Rothwell wrote:
>=20
> > I fixed it up (I think - see below) and can carry the fix as necessary.
>=20
> That's the correct fix, thanks.  I'll resolve this in my tree once
> Linus' tree has merged the conflicting stuff.

So, you have redone the merge (it was commit 05960268bcef and is now
6127dd802637) and still left the conflict tags in
sound/soc/codecs/wm5100.c ...

:-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__8_Feb_2012_10_52_28_+1100_z681Py=ybApKpNKc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPMbk8AAoJEECxmPOUX5FEdkYP/j3KhAbVP6Is+lmht4+1krWw
KhMmr+xRuyBq6bjU6SK6KvKtzm5yjjpKKbVJtfXMxKetMned8FojXtLzfLyVy0ld
o8TaFVZWydqfvkRQfL2649JBRFUdt1KATXaxDOL3kEndhR6/jVAkbtJ+GFjY040A
sYDNEEvHcXnDvlPPm1eWQYiKBqvuV8uUthm7wZs5LgpjCEBh0ni5KpdqOFTv1ay7
4FBlV3mbpkRSsp2wgmyQz8tTeRw73v/w7upCYOEBgsK+kum9IgyL+CrL8CMw45zf
zPTNYGNgkEND2vlE+Ff1uA+buJfMmyR4RqtWbT3eOe9M9af5cbTB/LmJiszxH5NV
nIsPBj1HV96upyG/qZ/478LpswZSg0gp4/VoLFGnxzb1E4hKkZa3Wib+6vvKdcxA
FEW7GItY5Iwh/OkXgzW7zHyVbqi8Ds3sV+cb7AAmBI2WGz6vkcYm7TZPwSFvB4CV
Cm4YgkHD3WuvVpni0lMPO5PRAZdPPbotA3+Sfy3yQzRyjEM+n3eCHPjZH8mnzoiT
afzTRCzribKTkNeF5lDwocdTz7Qfxw5fVXIWBy2x7eTIK9eT2rl6HVaZkFC193qN
ZZSONFZkkVk6g8ZqUcxCqGAviXp1BN7zb6TlvveUn+z1TgaRxF9X986jG23XnOuE
ITWSbkx/4MYpG8lyTbpV
=8KDO
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Feb_2012_10_52_28_+1100_z681Py=ybApKpNKc--
