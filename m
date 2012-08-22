Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2HVLkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:40:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60652 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab2HVLkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:40:18 -0400
Date: Wed, 22 Aug 2012 12:40:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        "'Ben Dooks'" <ben-linux@fluff.org>, kernel-janitors@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] drivers/spi/spi-s3c24xx.c: fix error return code
Message-ID: <20120822114015.GI7995@opensource.wolfsonmicro.com>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
 <1345365870-29831-15-git-send-email-Julia.Lawall@lip6.fr>
 <1b3201cd8049$e753f720$b5fbe560$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="faJ0ivz08JzDjTH2"
Content-Disposition: inline
In-Reply-To: <1b3201cd8049$e753f720$b5fbe560$%kim@samsung.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--faJ0ivz08JzDjTH2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 22, 2012 at 06:38:36PM +0900, Kukjin Kim wrote:
> Julia Lawall wrote:

> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> (Cc'ed Mark Brown who is handling spi for a moment)

Please resend the patch to me so I can apply this.

--faJ0ivz08JzDjTH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNMUYAAoJEFJkBDiqVpZ45xQQAIWvPsMbnRa1fHnVQe1R1mmM
rO35Lc41I+XnRD8/Ye6wm3/qAwV3ug3wny48IbXFzKgboTyHHOZzkmAOA270bIPG
IM+75uKi9WOf7fbmF35MIcoFj4v1+2DM+pwEBV93dlli+VR8wDicpEimQ++JWg6e
IB1sFr3RpxZxPaS3TglrpPVhCYBDOdAhf0CWLy9jLECsOWJU0xh93S8Ujcwc4YNG
rjV9QKi5Q4CJHhFsldw3imy4D9SMFvkeqD/pwREtnqeMCi01FqFvgJyym7+szK1h
Q8v7dpaKPjSlxhtdJ/FZV8RBnRRLy5g2CoarSBQHlVRyoKyJgvqaSaWfd0SOYAz4
hId3PhDKwCz927yjbKeINgmDBwobgDQhn6yN4gfxwpLGc3j7+MK2oKhye/oiF0Jr
BGPGA7WBM5TIIun8li9KR+FlbZ4L2i/J8EpN+cppBw2Z9vz0y+u/z/Jl9X18QYrC
zdajXQM5JNGyrhgp3xwip12yVLX5Ej9hISD1Unwa9u3MdEQD+bSUuoi4KCeAOpl0
Or0yp07JUgtwyxa5MHxDnyJpTMhYUqlhapd3ZnLFYvJA8Cz6oS8lFH3apQS+Cp2p
pe28/J/OCjZCofqgTFzCJhSuljh2dbgp0QJquZdIBT9B9W/ND9psiU8qqh6q9LFM
QGyjpPjbtkhVIkXpzY0V
=W7/D
-----END PGP SIGNATURE-----

--faJ0ivz08JzDjTH2--
