Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0IPFPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:15:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34059 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0IPFPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:15:44 -0400
Date: Thu, 16 Sep 2010 15:15:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100916151534.afb212be.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_15_15_34_+1000_1qRxYBFXrWdrGCj5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_15_15_34_+1000_1qRxYBFXrWdrGCj5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

sound/pci/hda/patch_realtek.c: In function 'patch_alc269':
sound/pci/hda/patch_realtek.c:15028: error: 'alc269_suspend' undeclared (fi=
rst use in this function)

Caused by commit bf402279498f71e6629d90939737c7c0d311c5d6 ("ALSA: hda -
Set up COEFs for ALC269 to avoid click noises at power-saving").

I have reverted that commit for today.

BTW, that commit has no Signed-off-by from its author.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_15_15_34_+1000_1qRxYBFXrWdrGCj5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkaf2AAoJEDMEi1NhKgbsUwsH/2LLWq3Ywq1QVQJPCqIflkx8
TWh4xE6/0gQoSjThxTW97nkZFI4VkOK2OWgBgWMaUEX+dfSqGyhzNR5mbUg8bm60
bOWTKXVvV9hEc8TURxTYhQtnqRPrZEKVPk8NWHbDI05VTOSgoff59ll2nPDKVklW
VSrSOz2uTeOMzOWxdZ6veJ5ePG6muzRJ/488kOsZo5jB94gCXODz2MjoFYxCdId+
4U4MsALga5XlTU6KbQ0yll+0s2+e0KKkK1ol9F51lOpOIVQObVdVnLPtt0tInXzk
TRcvF0LwblfMRvvRlPwWNT+5ua4H6fOch2eUCo8x3QxsQBCBjtvaTEtQEAYurw8=
=eTvD
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_15_15_34_+1000_1qRxYBFXrWdrGCj5--
