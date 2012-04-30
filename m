Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2D3JzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:55:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38015 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab2D3JzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:55:15 -0400
Date: Mon, 30 Apr 2012 10:55:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.hengli.com.au, arnd@arndb.de, olof@lixom.net
Subject: Re: [PATCH] hwrng: Kconfig: modify default state for atmel-rng driver
Message-ID: <20120430095511.GC3170@opensource.wolfsonmicro.com>
References: <20120427173504.GK18260@opensource.wolfsonmicro.com>
 <1335779353-9515-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <1335779353-9515-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 30, 2012 at 11:49:13AM +0200, Nicolas Ferre wrote:
> In order to prevent building the Atmel hw_random driver for each and every
> configuration, add a "default" Kconfig state in relation with
> CONFIG_ARCH_AT91.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnmFrAAoJEBus8iNuMP3dvcIQAJopG/5gHT+xEHp39e9oH3k1
UMN3kIU6i9hxLhiFjCeUtsD9iGXUJNddVLHGMzbwTarsvzGGvhSqYBXrpqLid0WB
hXql38qRjS3Zuq7V4T58eS6PsXWGRa/cry5GiWmswoe+mrbn2r++dCNruGjRdwr3
ycMBBU7rVjp5SGFj9zhHoLU5k0gHWEvoOXzJF3MgxPIsNAFahBEYog0hADdjEBng
EJjeRHgP6O8E2Kd7LItIwu6Ojy1lQV/A3tBMfFSLMrqKEzAVqQ4dQyVvjg5ly6tJ
qxwmxtPK5yspiE6gRj95ftx6rg2guol+4ov2C3sRsdzD29z+4d3/RiMl8vbY0+6g
s88bSL8pD6QZYd9MsQ8Nj2/SmcOB4P9TaKJsWQ3E9tBnSHNZyNIAu5ImgSfuqYan
ihA0BzRMPNrWND74rwKm4YRf/7u+0BZqDQNYCvAiiyDbt4wrklErbd/2YMH7P5xH
urm45DpKaaI8Lt2Y05XVLSAph0xqrn6goOboqIf0wKrM7KvPa83k3YMJgcaGg+fI
oAgFtQJSfN6LHLVsZiqw0g93TGKQWGn0I9FWr6gFW5IFL7OJYHzTYUWUytPJXLCo
Kl5b3xTFG8Xs8AJcjzbZ3QEcpLtiHOlbKu1zQ1XiJ27DOXtZ2oL5IK0/PmMEIiek
oHBjjrJfHRCMuNShz7cf
=Xc2h
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
