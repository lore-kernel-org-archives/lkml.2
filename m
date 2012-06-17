Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2FQUOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:14:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49580 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2FQUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:14:22 -0400
Date: Sun, 17 Jun 2012 21:14:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] regulator: Add ramp_delay to regulator constraints to
 get used as a configurable parameter.
Message-ID: <20120617201419.GU4267@opensource.wolfsonmicro.com>
References: <1339416668-17028-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pzbqGaOtRNiVr7w4"
Content-Disposition: inline
In-Reply-To: <1339416668-17028-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pzbqGaOtRNiVr7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 05:41:08PM +0530, Yadwinder Singh Brar wrote:
> For some hardwares ramp_delay for BUCKs is a configurable parameter which can
> be configured through DT or board file.This patch adds ramp_delay to regulator
> constraints and allow user to configure it for regulators which supports this
> feature, through DT or board file. It will provide two ways of setting the
> ramp_delay for a regulator:

Applied, thanks - sorry about the delay, you submitted the day before I
flew back from China.  I rewrote the subject line to fit in 80 columns,
otherwise things like git log and pull requests look odd.

--pzbqGaOtRNiVr7w4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jqVAAoJEBus8iNuMP3dPh8P/1O1yqphLz6fTHVkISPYzZVR
PIOeQLyTWEzdIeJFM4CMOC+uv4bq/oqBk2wtPSUZpklWQSrwFVpUcKJfHDvPV7Fl
6GBSIcUymNJ/MfUjb+FaCpezaMIB6zWFDkDmDWqTxPZzKhpRrD0csbZHflVyVqj3
TvNJnNswX3o84nbxrQjGeQ51MYVi6fRl4Y5LjawDStOxpPoOGbf9FjoL60psGjiF
HhTZsY8v/X0b1z69d4rrow6uO1VU+X1FLdBnpqYVCoBjub0vIvrBvqjtsBBJBYsx
B4MtHOzVA2SJsbr+Aq8loBEVjLgh8i4XcaPCO/PIqeL7AHeJBGthuwLN9KhqIo14
/xdjgOSCQzPAwJ5SIb0gXQxuEcRcmuZt/X10cds25U4t6cosoVr4l7wFWiIygPI8
JXKpLy4a4fXolHVvmGmXG5h1z00arNzB1W2sugne4cNkfA3BcvoVYwNgpJa1yAu1
IZlfl4Fl2UGrM9GxV0XDX1Ye19Cesh/5Y2rvkU8KHFswEOwrs/WiILl5C7kk6TrW
aYOF4l5RDF5m7socq/jl52EBj0aT/PnAmyB/WbL3C463XhznH4rJ+vWb0u/Dj8g+
OaJ2psnP/OFD+oHFQNJ3PIcxeuRto8dmRHj78oTNMXS/K4EV3U/aP9qkfQAKGAhK
ZzBVVfCoZAUBqxRB3Izt
=uUXM
-----END PGP SIGNATURE-----

--pzbqGaOtRNiVr7w4--
