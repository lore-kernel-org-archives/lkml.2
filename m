Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1B1DPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:15:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab1B1DPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:15:40 -0500
Date: Mon, 28 Feb 2011 14:15:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>
Subject: linux-next: build failure after merge of the sound and sound-asoc
 trees
Message-Id: <20110228141528.00fc4ab4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Feb_2011_14_15_28_+1100_xII_2PrqpdYDclos"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Feb_2011_14_15_28_+1100_xII_2PrqpdYDclos
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/sgtl5000.c:30:27: error: mach/hardware.h: No such file or =
directory

Caused by commit 9b34e6cc3bc2bf826c078c93c81b46f6c08da25f ("ASoC: Add
Freescale SGTL5000 codec support").  Maybe it needs restricting to a
particular architecture?

I have used the sound tree from next-20110225 for today.

This also affected the sound-asoc tree so I have used the next-20110225
version of that as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Feb_2011_14_15_28_+1100_xII_2PrqpdYDclos
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNaxNQAAoJEDMEi1NhKgbsUloH/16G4nOhv5dmCp4S+TlU9z9d
L+6ATnrB2lC4YlonGhi6q/6Nc6k3H1dt5W2roSFSmEq8nk0kWD7ogk6NBfDPJX29
q7DexLHGRQ2vJ4gsTdcI6hP6ay179rxkxKE53vY6gnxhk7nCQoLbu3yfFGLpbfqs
xi/suX35DxR4Rai1CqvqbdF4bKR2fUmy23F9T8GKaSSQuvqrrSAQihw/0KjBmK9h
6LNG8Nn7ONfsPOMu3ybphd8kZN2/q63xW/LlWU8X2FDuV1yuZM9QGePF//drIcU0
Z00SjHWZGEuqqEfMJrazWwgIk42YCAzRN7V/OPxB07N7zH7J8rz6U3uK7Ohmgeg=
=e+Yq
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Feb_2011_14_15_28_+1100_xII_2PrqpdYDclos--
