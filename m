Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2FYWcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:32:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44406 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757655Ab2FYWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:32:04 -0400
Date: Mon, 25 Jun 2012 23:32:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: Add support for Wolfson Microelectronics
 Arizona class devices
Message-ID: <20120625223201.GE30406@opensource.wolfsonmicro.com>
References: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdbKyHtwcsGoph_s-YPtn9yUxxKQBfXc_ksiNu=yE51spA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Content-Disposition: inline
In-Reply-To: <CACRpkdbKyHtwcsGoph_s-YPtn9yUxxKQBfXc_ksiNu=yE51spA@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 03:13:58AM +0800, Linus Walleij wrote:

> > + =A0 =A0 =A0 regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + =
offset,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ARIZONA_GPN_LVL, v=
alue);

I should also have said that's (map, register, mask, value) which
updates the bits specified by mask in register to value.

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6ObYAAoJEBus8iNuMP3dlnIP/jB+OjgDkP2i97QFzvub5BLI
FqigC1cSioiFdgvQnETSOTK0Yx3DkDguwORcNDzJluSPLLiUeBn7sRGkJHgTlSSR
And2b/KBEc2TMP3G35ERCwTsatvD7tX12FD5SFPyXw6NOn0+Ex1aIotfDwJARj25
GZBKSh605CvTsuAJGZY7mkFYwWk/qbJF8kLa/T3dHL5NztSbavTcbh36odqYnr3B
9Zz8OS/cLbIWXy2tTpCyWclCjSn3qAEho6jxccLyavDVAqHuknX+O+pTIlcYJqBL
fnDlPMD00/6xTlQ3ElU4JifQnPhXX1tJDrCQGKggLuH7qdsFIx+OfN7M//IdW+uP
qO4P+YnhW/54x6+6nZCYCXAobi5Zmw+qu1CPSYFYfVEjU68kY1bqeT2PXdNkZWva
XTfWNVOGrID/ZzBwlj+rCim63jwzliqYmbmpSql25Auq6uyPvRvJNu2XdBSsITUi
+Lnk5adsfNA0ywyZRx3ZJSOSWTPGahyw2KRbB5ARSW5E27zrJ6MkAMM3Ko1tS3zS
MNUsoYziQVFUNQm+L8nHCdTJGJGlESMiXHkEu/LrypRZXoCtg0OHTCxtXCXhpAzw
KPcVeePZncWcyNkkjwa8QsH3JhXeHrWkHZfOSO8ux9VdvFLVabhTXIJXwfFBUX1p
t2f7rS/FaPGLFzghNKNp
=Iptz
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
