Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2CEM1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:27:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42940 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab2CEM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:27:30 -0500
Date: Mon, 5 Mar 2012 12:27:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT] regulator: Set n_voltages for da9052 regulators
Message-ID: <20120305122726.GH3224@opensource.wolfsonmicro.com>
References: <1330949072.3853.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MP5ln1Rcf9Bvi+ZW"
Content-Disposition: inline
In-Reply-To: <1330949072.3853.2.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MP5ln1Rcf9Bvi+ZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 05, 2012 at 08:04:32PM +0800, Axel Lin wrote:
> The n_voltages setting for all LDOs and DCDCs are missing in current code.

Applied, thanks.

--MP5ln1Rcf9Bvi+ZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVLEkAAoJEBus8iNuMP3d0m0QAJaUSDCFIrHU8B6Rg2Vi/YBP
3n2zsIqAzgAL643iiDuJNZRBmT9FMnfngri9/zL3AEd/HPi97/SeQ4JD3S+b/h+F
AxNSCAL9tBwhT6PsqFJH4jlmdA8aYllCi+h/e1+BEbEy2Ka9RSQ2btrRm9OAiOHP
DwQ/PIC6Zrmt6ClFqJ9+J97Pk0IFhhnB0QHHrc9TDUx/0+EjgNI+WuKtYFtvmmUg
VMctljapVbyF01/QDV/1IW0ndwUwn8PC9oHHTwkg3RLfgU8rg/R5UQ2Uc46M7qY3
7x3/WYB+yb+C8yt0tnB73QlASgGQE3L2IWRHnI2xekYm19g7BTjsTyel+JRnKaHH
wDdPQXkjNYdOad5r9Df1oLSvsm8gqz2LjmrhVJ7S597X6ltrLtDFvI7UCkOOknRD
fBBdRzbItGOVYxdzRBLS+Z1MITqL/JeL8rEO6Hj1eMlFQ+AU1GrKhm5kiliG0zc4
2+cRlfOQjxaD610URHVoX+4FZNA5tBRH+nZAaG9UcD9MMAyJjS0j08qttrKBnzDX
/BXVdrj+1O5eCmJ5//DJz1L9moeHCuqVMc1EobeP8MK4IXwRt7bEnZ6Y2r7Uaiw2
cUjkac5iw0N/oP3YElFGhdhzIG3VIOlHy+W/QEA0+2/KEdvAskgiLUaD7kQyCYx6
7SozDlGWsVzcIBgdWkNJ
=a3AY
-----END PGP SIGNATURE-----

--MP5ln1Rcf9Bvi+ZW--
