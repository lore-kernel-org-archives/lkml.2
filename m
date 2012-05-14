Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab2ENQql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:46:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33134 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab2ENQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:46:39 -0400
Date: Mon, 14 May 2012 17:46:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap-irq add support for non contiguous status
Message-ID: <20120514164636.GC25668@opensource.wolfsonmicro.com>
References: <1337002843-2778-1-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <1337002843-2778-1-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 10:40:43PM +0900, Graeme Gregory wrote:
> In some chips the IRQ status registers are not contiguous in the register
> map but spaced at even spaces. This is an easy case to handle with minor
> changes. It is assume for this purpose that the stride for status is
> equal to the stride for mask/ack registers as well.

Applied, thanks.  It's a shame to loose the block read but we can always
add that back later, it's slightly awkward to fit in though.

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsTbOAAoJEBus8iNuMP3dUMQQAJAT5MzU6lNS53Qnn9yN+u8T
Co8mnDD/QOGxB7AnQP4UG7R6OHcdFWE2T+Y3QDJTLw4pcLXfbqNdZ30VlpwnCKwB
VdqQvO68aWnbowaqUFnX7DHJALssUPD2CRXx9UQK5HHVmXRDzuw5MXdIB0US4QIc
mJ2M+vhMtq428pKSZL3HlFNwxLNIgokLLFb42fZKI/GvpLx72nlUp/fz+h8cdTDr
e80nvYHQBztVSFsj1KuSceIDGpiXIBTPRBCcYcRJNnWW4Dn4Z2LcBgiRRaiWXOyx
cw54GMcXTDpY1LIRXAMUorib7lKM8Y60MV41CSj52VkjLJ05kkeE8d/I2nxuVYpB
9nVFnm2slnP2C8UWoQflkDKBKkLEGqfBx5e3rKdHfvxX0tVq7N1Fya89KCHz9usT
1CVv7PG2ODv0w+LEJ5emAdZwvVSADzXDENm3s9Ai+D7oNpvllSSynU72dKKBR9oR
MprtKDaamyI36QOHDuiD44PrSCjOK6y/aoJ7RsG/vMgkF3LkafAu75qSP8bcHaH5
yj3RNYee+pptj3N4hq30H17dDiNo1mcnK2vcU07KXeVdiuTx/8mXGfXiWUKRHIa9
1eiSudwSVM9W1Ft7OrqhU2hTW1/SeClxS6h8EYI4T1lGYHgJy3l6eZrA5T3xeo8Z
0aS0jnW6UB40E+ciVNnN
=J41i
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
