Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab2CUQiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:38:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49327 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758100Ab2CUQiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:38:14 -0400
Date: Wed, 21 Mar 2012 16:38:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Add support for spi regmap
Message-ID: <20120321163811.GH3226@opensource.wolfsonmicro.com>
References: <1332345170.21744.10.camel@matrix>
 <20120321155635.GE3226@opensource.wolfsonmicro.com>
 <1332348080.21744.26.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pfTAc8Cvt8L6I27a"
Content-Disposition: inline
In-Reply-To: <1332348080.21744.26.camel@matrix>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pfTAc8Cvt8L6I27a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 10:11:20PM +0530, Ashish Chavan wrote:
> On Wed, 2012-03-21 at 15:56 +0000, Mark Brown wrote:

> This is writing to page register. SPI register space is divided in to
> two pages. Registers from 0x01 to 0x80 fall in to first page. If we want
> to write to any register above 0x80, first we need to set page register
> with PAGE1. May be I should put comments to make it obvious.

You also need to make sure that the register cache doesn't get confused.

> > >  	/* unlock */
> > >  	regmap_write(da7210->regmap, DA7210_A_HID_UNLOCK,	0x8B);
> > > @@ -1035,6 +1056,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
> > >  	regmap_write(da7210->regmap, DA7210_A_HID_UNLOCK,	0x00);
> > >  	regmap_write(da7210->regmap, DA7210_A_TEST_UNLOCK,	0x00);

> > I also note that you've not yet updated this to use a regmap patch as
> > was previously requested.

> Actually I don't have enough details about the problem that you
> mentioned with this. I am waiting for inputs from some body else. Can

...and didn't bother asking any questions so it's unlikely anyone will
say anything...

> you please elaborate the problem if you have details? so that I can
> correct it.

What is unclear in the previous feedback?  You should be converting this
to use a regmap patch...

--pfTAc8Cvt8L6I27a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPagL+AAoJEBus8iNuMP3d+3kQAJwsFnlgLpxxM91gMA0WCTbN
iKL1QqapB5KdDLEHv/3JGkdMsZ+h0nWVBxe1o61JKiLmiFRI9Zur1zFj7IdnTo/O
bbIkHDlo/2GjhCdsaLHxkWoMhxJxicaE+k/txuNwXjHv+oSPjg4sBNNc9x+lm0aV
ycv3qZfCNK/2HQ4FfjX+nSPW/rMcICxehhHFSGmFu12g+Q/wTI/T1hzFjJvWowmH
RtdSv0kYwoJOCdPD97rbgYcYEVrymlPl5srK8JuQ+f4OHwHuqj1FxHSxV4sgJyJp
MgrW8jMHCRwwA2JACg3xh/EieNFVLlQ+4j97B8/wsertwg2YD4ZRGgmbO+5gDEhS
ZqwVdpTLE5SURtyrm6wI1k5Jwa3IkAf/g1oQ6BULzUQtsGLsa+xH1ChyIKnCKw5G
8mGJxkW9DEMSs1pXkOxlo2KHYjzMJLe7EYj9wepSjbTCHzFnxMg+NNZ4e3Pnuzv9
IjKLmwEPYvht/8OSiLZyicZ/4x2WJAvs9JtGxHvjKlwvcUm9mzGsbp6ea9r4PY0S
d03Z/t/ocyo724hwHP1dxOm8ZDe5Y+Gy6dnp4GeDsKmRPJtkxVdo9/n/qdEaQ9qM
S8wRmWgpe+4lPjGa87rPD42qFsK/DYLVS25ukQzJ7ik2Y8wLZKuQWGBWw6TQ8ZLp
3v1Wq1Ls47vZVoPqsoUM
=bCAI
-----END PGP SIGNATURE-----

--pfTAc8Cvt8L6I27a--
