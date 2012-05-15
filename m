Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab2EOSO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:14:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50090 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932887Ab2EOSOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:14:54 -0400
Date: Tue, 15 May 2012 19:14:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 1/4] MFD: palmas PMIC device support
Message-ID: <20120515181448.GD19592@opensource.wolfsonmicro.com>
References: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
 <1337064539-3014-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
In-Reply-To: <1337064539-3014-2-git-send-email-gg@slimlogic.co.uk>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 15, 2012 at 03:48:56PM +0900, Graeme Gregory wrote:
> Palmas is a PMIC from Texas Instruments and this is the MFD part of the
> driver for this chip. The PMIC has SMPS and LDO regulators, a general
> purpose ADC, GPIO, USB OTG mode detection, watchdog and RTC features.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

however this depends on some new regmap-irq changes that Graeme posted a
couple of days ago and are only on regmap at the minute - Samuel, if
you're OK with this I guess the easiest thing is if I apply there?

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsp0PAAoJEBus8iNuMP3ddhoP/jC0tmBKEOwe7h//sNZ8Cju4
rglDhAacjSckTKtB/f56IINQUg1hvPCwZ2Z9iXI08xoaXUcXVArTLQa3FUyJ35cK
UX4+528Gj2/QDEtutMx0/i/tNmBt7fa21wqix8tqaKX6GoE5/X0UYxmmmNoI6iZ3
vCGiubtjTV48NMcDKiIoVL+ll8apQ6EjLyig91/X7nLiqrkSobHz5Qh9Z4hLam1x
upasGL8UBSdREaiTSERwsE5Q2Ow90OZv8vfdZEAI2WC7k64njvSLYDfJUGnYrsWd
XnSPoTT8GVZTrB6YqssPUBmE+QSrW9j4HD+s+n9Cp0n7k+Pdro44O9Zdws9Kq3nR
3F7IMTcxX1ZmiEI/doEUmRmbGmrwNRhMT33HEG2LD40gJl1J9wvrODLaVAbE33pz
vIz5wOoXeNOL66PcEiG7uLXpFCxkPumbWu5m1VO5qZjLKcieQB2F1unJd8WE30aG
6SQgptkF7vuTjlk2gH4P9JW1aIP+Hu/aI4Ip3YtduufImGIpc88g+6z5U5yAeVy+
0dc8sfelmqublfxS0rB89c7fs6KLSGN0Wx5U4RjmjdQB9pcIyhECfHbT7nC1kBgu
Mf32EdQlZIs4xWOC7P5RvBjQbnmRHJ0IOPHhR40cMypodFOepnXXuJ30+/kjIToY
KQhD6gcS5gJ4ngPkVG1T
=FSWM
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
