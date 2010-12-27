Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0L0PUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:20:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52083 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0L0PUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:20:33 -0500
Date: Tue, 28 Dec 2010 02:20:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 27
Message-Id: <20101228022027.8519be82.sfr@canb.auug.org.au>
In-Reply-To: <20101227113857.GA31293@sirena.org.uk>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	<20101227113857.GA31293@sirena.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_02_20_27_+1100_KZy/X7wM6iv3CquZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_02_20_27_+1100_KZy/X7wM6iv3CquZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, 27 Dec 2010 11:38:58 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Mon, Dec 27, 2010 at 05:04:51PM +1100, Stephen Rothwell wrote:
>=20
> > The sound-asoc tree also had a build failure, so I used the version from
> > next-20101221.
>=20
> What is the problem you are seeing in the sound-asoc tree?  I saw a mail
> about the sound tree but didn't see any failures reported for ASoC.

I got this error after merging the sound tree:

ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8962.ko]=
 undefined!

after that, I merged the old version of the sound tree.  I then merged
the sound-asoc tree and go the same error.  I presumed that you had fixed
the other error:

ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8903.ko]=
 undefined!

in the sound-asoc tree and then that version of the sound-asoc tree had
been merged into the sound tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_02_20_27_+1100_KZy/X7wM6iv3CquZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGK67AAoJEDMEi1NhKgbsRIkH+wV3B4T0MFY4rmrd3v/znaF9
wZXVLZpGvqFelWpH98RoJuaXBixntkjqMK4Bclki0UoxmZqWjGUhGLTnp+NIz00D
cLXvyrEkUocXVJb/g1e/behoAiw0BTRn5uaYZzS/mzEyc9gHTYtsnVmW9tR8bsUB
4K3UGMA3VeupIyUBQsgZpuoUITfOQTSwxvKupBrMBlWPIsdtskXZxktS7MTq2xA1
q+X6Rohr1PFrsZMicd1I5ambensnSfvuAhpJLYmrm6O1TfSccTbqIziMp0k6irRn
LmXnYLWmPYFJGFAAmq4eZPrDOc8KD3FulS+mfPNR5HcwHb9nTpqZBAknFT/auf8=
=TYom
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_02_20_27_+1100_KZy/X7wM6iv3CquZ--
