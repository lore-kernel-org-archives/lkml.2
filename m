Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2J1SIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39624 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab2J1SIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:08:50 -0400
Date: Sun, 28 Oct 2012 18:08:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Q] .readable_reg() not verified during read?
Message-ID: <20121028180629.GB4547@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1210280034310.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210280034310.4378@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 28, 2012 at 12:36:40AM +0200, Guennadi Liakhovetski wrote:

> Looking at regmap.c it looks like the .readable_reg() callback is not=20
> consulted when performing a register read, e.g. in _regmap_raw_read(). Is=
=20
> this intentional? If yes - why?

No real reason, though to be honest it's not that important - the main
reason for having the function is to make the debugfs stuff work nicely
rather than anything else.

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjXQbAAoJELSic+t+oim9puoQAJKTi2wOr4/f10QQ1xTtsVMX
eZrGiZ/+CGuZ0U1FGgLvlON3muIyZX1QEK7m3IO+gLnjCBNvn7a5dOIjKKS4+c3s
CU6qkbnm0K+CMcccgHuEZIrSmx1MD8/ZrUoauZxHhQySTXa5XMhdWESRiBHBeaTf
fM98v7c21ycVS6EMRYbsxzOQ31J7gwIlbxZC4oQmxtw/Z8mEz6z2uwmYv/8A4wiX
VsKMKaNdqX3XIDFETVOzpYBk0wXiRzzZ/pISbYTC/MWzg00ljC8UIPzkY3HL9Qse
K14rBAhQTxSCO0DCVck9NYdutWRDy3ofxF8SHiszIVxtFC5oOjN/e0J4vfFhtAck
q6lBysxRyRqVPJzYjYCLuGIgiHduO2++sKkMfEfoOo+nwd1vyyeSXZbjWe2t1CCD
E2urA89VD0JSLNYL7SF0zogcChMpH8Ptx10s5RfWzSkgey0h2kq14EfKOA8nemTu
xC+t+9sJseveK/sewcuxraW4GQGHrnA8QA4X9p5e7yyGuwD1FfdKiSxAe+ygc8ro
J3ImyzxyeYFgSCNEsNyWwu/otG5JZKHMaGF4DS4KHViniOH64+59Ra/lR25EeRdj
x5trFR28oWkp5Ax/SCGxMxpdkqBOeKtOuneIY4hjVQUxbsw9VqN+ByOBpHe1t8V1
i2AVksfY2bzbPI9VDGZV
=3dX7
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
