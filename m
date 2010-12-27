Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0L0PRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:17:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52043 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0L0PRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:17:07 -0500
Date: Tue, 28 Dec 2010 02:16:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound tree (Was:
 Re: linux-next: build failure after merge of the sound-asoc tree)
Message-Id: <20101228021657.44144877.sfr@canb.auug.org.au>
In-Reply-To: <20101226235928.GA18334@opensource.wolfsonmicro.com>
References: <20101223120243.1617cd40.sfr@canb.auug.org.au>
	<20101223021212.GA25886@opensource.wolfsonmicro.com>
	<20101227104951.1ecad371.sfr@canb.auug.org.au>
	<20101226235928.GA18334@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_02_16_57_+1100_hJ4snbJNj4roWo1K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_02_16_57_+1100_hJ4snbJNj4roWo1K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Sun, 26 Dec 2010 23:59:29 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> Hrm?  I thought you merged the ASoC tree before the sound tree, in which
> case the above is somehwat surprising.  If the ASoC tree merged OK then
> Takashi it should be a simple case of pulling my for-2.6.38 branch to
> resolve the issue.

I started merging the sound-asoc tree *after* the sound tree when the
sound-asoc tree started to be merged into the sound tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_02_16_57_+1100_hJ4snbJNj4roWo1K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGK3pAAoJEDMEi1NhKgbs1IAH/R0mZ468vdqkBjxBuVMpSEdm
P3ySoAnSBqaOfDuKy+46kw4b3qgdUsGdOUe7AXX9XpqGrKvLltUMvgiEb/xl873D
piLasHhuO9QDSKAewgHUVtn4kytv2MCia1ylqSOjdAx70fW1CjUoNuRHfvv+YcCD
OgJrYopV+BgHnNEMuXOvivaySppBiKhw5gaLsnMO8r0DWpjnK7H3ZlLcDW6d+OWu
NOGHdSKymdboL4+9sJ1hlsqRLqBtW95Iu5AozhxBXH8Xic8M14HTqfMHEyvw/3GL
wMfAim/eQ/d3IjmbDDIA/yOVPgUffDzMtFfxU2oicH3JasE02SRAF+UlDowtVOA=
=vZQp
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_02_16_57_+1100_hJ4snbJNj4roWo1K--
