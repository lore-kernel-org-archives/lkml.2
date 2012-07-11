Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2GKJz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:55:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55216 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab2GKJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:55:26 -0400
Date: Wed, 11 Jul 2012 10:55:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH RESEND] spi: tegra: use dmaengine based dma driver
Message-ID: <20120711095504.GD3938@opensource.wolfsonmicro.com>
References: <1341927517-4584-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <1341927517-4584-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 07:08:37PM +0530, Laxman Dewangan wrote:
> Use the dmaengine based Tegra APB DMA driver for
> data transfer between SPI FIFO and memory in
> place of legacy Tegra APB DMA.
>=20
> The new driver is selected if legacy driver is not
> selected and new DMA driver is enabled through config
> file.

Is this any different to the version of the patch that I already
applied?

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/U1rAAoJEBus8iNuMP3dRq4P/1A9KG0kjV5UVr/W/Wxt7gag
9L/tU3LcQw3KdNSWSGX76U6Z0AdC6VQTEKhEHIaTd5LqgCt4heajdWlvEBe2y9Ho
5j7SX+2Xcey74svIzRAi9SqfLa5V9xEN9akm93LeZ3S9XKoU2udi/kCyNs1mephN
xFPt1ImL/gNfTIA9LQYlILjCjyL+oviz+UZVWV5Ev5+z/FVn0u06S6wUdttWmzVc
h/lmr9c6ji6QIWSQLkfa35bJD8XbTkgeh7DjSBdEqy7bWDBHyKdCXfxFVZKe/MaO
LXdZtKhyeDlna/ROOIcD+BgCarb9kxMmFZ/Io3j6la4sr8rIDXISEMaZ608ijd89
h0995TG2j4WjTCoyynvxjuqlbLFXCIcKpI8HnDjutvahv0qCcJ8i2jPVtpDPcLln
PnyGbbpH/i/qq9YwI1gKhBvpF6MC6HysJmw1Sem4fFVnwesq8Jnkv68SJS11GV/a
a5D0/YfF/8tlyoKPrqGTJc1V0ShjCTMVrC6/8r2W6oPX8hUD2peGJ6Z4Gnmfsa3U
q2jCaFVKPESNkugbzerVceApt3lg1O6usoEU04r2vncGSErQlFQumcuzEN6Z1Lfs
h82lfGPeLCT3+ByIsiHpRdq5/YLebwPA+rTB5NoawE4cIaOFZzqr7UfoQ0kAGQbH
byvXaNKpcRej8uDshgjx
=AVt/
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
