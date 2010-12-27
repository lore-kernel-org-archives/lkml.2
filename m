Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab0L0Xsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:48:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33215 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0L0Xsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:48:46 -0500
Date: Tue, 28 Dec 2010 10:48:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20101228104834.84202d88.sfr@canb.auug.org.au>
In-Reply-To: <20101228104024.fb0e9e34.sfr@canb.auug.org.au>
References: <20101228104024.fb0e9e34.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_10_48_34_+1100_PDaUxtZHv7JtR+n0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_10_48_34_+1100_PDaUxtZHv7JtR+n0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark, Takashi,

On Tue, 28 Dec 2010 10:40:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8962.k=
o] undefined!
>=20
> In sound/soc/codecs/wm8962.c, the tracepoint is protected by
> CONFIG_SOUND_SOC_WM8962_MODULE, it should be CONFIG_SND_SOC_WM8962_MODULE.

I also got the same error in the sound tree, so I used the version of the
sound tree that would have been in next-20101223 again today.

Mark, I reversed the order of the trees today ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_10_48_34_+1100_PDaUxtZHv7JtR+n0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGSXSAAoJEDMEi1NhKgbs0HMH/1jLhLBHu/+/uGbjpZpU7sXj
sCnO4VA4UbLeyNviVUnf/Dpd0HpddQFIOBhKHrnQN2J0ak7YoshlsvwiODqbAMZ2
5ZFqku9koHbWnMMtk+0GOal/bL47BBP81GI69as5aXFCf7axGnPrK0rwThUq9uVC
F+4/2qlp9jF0YGsoiHXNAN58MPBPFBdfu4DiE1n/sojnwPcKBzIp6FiVfVkRRgSy
xxedLX+kmsO63ySfFs2jsMCH8ugrcDhpJ2noN4GASmYu4CJG75/DioCKw9b+PAZU
o3yQNj4abTsVBMQiptXwkwGVrQ3OLd2YXcqQNWRN9La2fo9c72vAPTQM8bkiwdo=
=T80E
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_10_48_34_+1100_PDaUxtZHv7JtR+n0--
