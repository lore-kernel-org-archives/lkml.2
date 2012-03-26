Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2CZOsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:48:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36486 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932652Ab2CZOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:48:07 -0400
Date: Mon, 26 Mar 2012 15:48:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        marc.reilly@gmail.com, s.hauer@pengutronix.de,
        fabio.estevam@freescale.com
Subject: Re: [PATCH] mfd: mc13xxx: add I2C support fix building v3.3
Message-ID: <20120326144804.GU3098@opensource.wolfsonmicro.com>
References: <1332772370-13272-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yk1sSvxP8cRAjBs"
Content-Disposition: inline
In-Reply-To: <1332772370-13272-1-git-send-email-alexg@meprolight.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yk1sSvxP8cRAjBs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 04:32:50PM +0200, Alex Gershgorin wrote:
> This patch fixes the compilation errors after the patches
> from series mc13xxx-add-I2C-support-V4 were applied.
> It was successfully tested on i.MX35 PDK  v3.3

Nack, please submit any required changes properly.

--3yk1sSvxP8cRAjBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcIAFAAoJEBus8iNuMP3dRFUP/iNKibdjtwoCgcsWfBcN5oKF
bsdsLE88RUy1yYsTLGb6TZBSQ8nntLeIpDm7oienljKebYoQKtOEC/RB7Y9vkPqI
xliFU0mONTohP7x7rPYNAl/43IOI8cg7vYBczEBnQHh+onu62uP+EIQZ3Cl2gAps
OIrF9XYl7ZGQ039sRXX8knax9g/VE+uhMrvyohtJ5ilWq+cubHQwacNXqhVDpQvS
ynGtYdrkiSlACmvY0zJaNfzljriTonSYhNnf72U0+4oharE8knvl1USSeHeSO3CM
DYPMfp7lwYkaBpC6iUxVaeiccutK9aAlkRzxTsWx3kOln7dzEJ5WtGz9c/7IRxDC
EF1vmDUbUNrgS/Q8utDZ9mHnF/dm1q8Gex15yqzojcFRuccYajbSO5qjGShoDpQx
efpf1jad+wDe2U9m3e1YNKmi3bSGDVLVule2oXz+SKLnGbj9Sg7iO5zrFLdjNOJe
fCCCCRHwXkdbs9B4hBsHt9cH5aoG0Q8Al8F2BfroJhKhbkz/hWo0ep9sLJl6tnaY
9KrY6/6wZNU2yC2HRmcfX74lMzNeypYdtc1ugl4OrxCo54ni23y7D9m9UoCsWR5H
gaullWenzd7j3IlglY2usbEVoVZ+fOjLlDsh7KhZIo8x9EmQh4A8YKEo7BJq7w6V
ODhaHnNbgYSSsCGBzKzw
=bNrv
-----END PGP SIGNATURE-----

--3yk1sSvxP8cRAjBs--
