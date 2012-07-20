Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2GTJ4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:56:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33859 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2GTJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:56:29 -0400
Date: Fri, 20 Jul 2012 10:56:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regmap-irq: use mask and val rather than using
 mask_buf_def
Message-ID: <20120720095627.GO4495@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FD99F@DQHE02.ent.ti.com>
 <20120719091011.GI4495@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998FDA8C@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AQYPrgrEUc/1pSX1"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FDA8C@DQHE02.ent.ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AQYPrgrEUc/1pSX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 20, 2012 at 07:08:15AM +0000, Kim, Milo wrote:

Fix your mailer to word wrap within paragraphs, I have reformatted your
mail for legibility.

> Which is better understandable terminology ? 'mask and value' or
> 'default mask and updated mask' I think 'mask & value' is more clear.

But you need to say which value we're talking about - there's multiple
values we're working with here, the interrupt mask is only one of them.
We also have the wake masks and the actual interrupt status values for
example.

> (b) supporting interrupt-unmasked device
> There is different interrupt concept from interrupt-masked device.
> To enable the IRQ, the register bit should be 1.
> To update this value, the bit of IRQ value should be separated from the mask bit.

The variable you're changing isn't the interrupt value, it's the virtual
copy of the mask registers.  The interrupt status value is managed
separately.

--AQYPrgrEUc/1pSX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCSsYAAoJEBus8iNuMP3dAB0P/RvdFN3yO303zdq59tjE/f6O
4E80baClxXDTaLnb5bB06w+EKJWHafXES0i/3c0Yf0Wj96isMCItWiMc7zxDVLHz
13wk7onQ7skV35UBFFyvZLipB8RZFgTbXwgtHqbFN1Hkmb1TPboPKvHNvjnRfpWj
Rub5wI6LZosuX/Ytxv2l5WYq6Xb/bT2xEKd14UelTQxpBhPlxzoPhkJK+zvAy/Hp
fQVS8u/u+WWlBJSQdUe7+1IdXZ56ses8uArvt0QDSuz9ZO5S7mqiIIRgTW6psrH9
vdwyAllKOylL3hCLtVo6dUALJ9NOKv4t+/2Yb0ngdW2mtI2hu7PBblf4u0aEayzQ
KZa7mnSblOfAY0Fffv3NRMezB4xBZVqbTa8cXD+ElBOcX8j/XFv2xxsJMztHboSo
c8AgVxMdT3KfPUlDd09e99YHFGVpRseZOONwex9hz0FTyxljBmBE/DlmyYZDZacw
d71Bv+ILc0uYOQ96yP94uSbNv9FB81KgJQ9A4uVPxpBqXbcgXfADkO9agNf9fTbp
uHDEcvINzLFThw2YUmwuRX3nvar7crbnjXPZGB+sfNvTF0gsOET5VkmiQt6NtsKS
mpqi5hw5dpL6K7ZVT/XVrqMKS1TXdSLe33BUxyXgHMJcXqHk9Nx+ThEhfnIoNQ3O
LWu3Z7bg3QTelZ9msWoW
=HVhQ
-----END PGP SIGNATURE-----

--AQYPrgrEUc/1pSX1--
