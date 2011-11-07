Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1KGTjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:39:15 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49749 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab1KGTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:39:14 -0500
Date: Mon, 7 Nov 2011 21:39:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107193908.GA5059@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320688617-4543-1-git-send-email-balbi@ti.com>
 <20111107183208.GG15294@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20111107183208.GG15294@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 07, 2011 at 06:32:08PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 07, 2011 at 07:56:57PM +0200, Felipe Balbi wrote:
> > commit d6504acd (OMAP2+: hwmod: remove OMAP_CHIP*) has
> > mistakenly added MUSB as a hwmod available only on ES2.0
> > of OMAP3430.
> >=20
> > MUSB hwmod has always be available on all OMAP revisions
> > since OMAP2430.
>=20
> This doesn't seem to solve it:

then i can't help. From all I know the LDP is based on OMAP3430 so that
should work. If it doesn't, it's something deeper on hwmod, maybe ?

Paul, it's your call.

--=20
balbi

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuDPcAAoJEIaOsuA1yqREKx0QAKAm1ByGrBRsS662BsjwPe3g
7EzPZo4+QeRkgVGUBimAItrI76ktvOpsFkVUoQUuzA1LZpZekuW8ajpagfPpUyhP
EkNS9QOzpxfl/ecOlEm2Cw40E7W4qONY7ejJE8NuTKp9mOjdz2533TSQToWl4GVs
abSvrXw653tFhD556E0bljaupKE4merYN0HaCqKx+VfQJsPSjAI9QMXwZz3yku/O
ZKgT/PJJ0fPV7xxqIUdIv3uZzbQbyCRjsoR9P9DOyPq1NslM9/8ebCUz5K++F+Hr
VKIjADTgKXPjXH33VnfTC1v2Lzja55NwIOPaRg85RIxxo41S+E92yi7ETxGkhwah
f5MeAPVOxcaFpGBek2HJ/9+jLOA09ytHfPrE8k7O261eCQauIDO/5SMdz358QN/2
IM6J7FcSuP5btSiuUIPms5MFz94rV2ChU9AEuskiQtGjyDAFc0Z59OfkWdFfaucg
r4Yvgd8WGdJcK8fxWdFgpoCYlw5jdBRrNf6GV6/ulXC5llCrW03kekpLNzs1T9HY
tEwpjY5qp8rIIgMoXI62o2b82RutqpyzoIda0/YCifOrSArQyIt/kuK6+AsdE9Zb
JwNSAGQ4WcTjNzxXiHz6585OPLeh4bFiZeCEEBcpnBUjHU07PqHCvrAqTLQXr5U8
/8ngvsXvwRZPXLV/tcKS
=KH3I
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
