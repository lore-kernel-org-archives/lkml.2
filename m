Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab2JXLDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:03:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46381 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119Ab2JXLDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:03:22 -0400
Date: Wed, 24 Oct 2012 12:03:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Shawn Guo <shawn.guo@linaro.org>, Timur Tabi <timur@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Subject: Re: [PATCH 190/193] sound/soc/fsl: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024110320.GE18814@opensource.wolfsonmicro.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-191-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <1351022666-6960-191-git-send-email-keescook@chromium.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 01:04:23PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.

Applied, thanks.  Please use subject lines matching the subsystem.

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh8rvAAoJELSic+t+oim9ND4QAJeDiCh8rdJ0Cfvt4KJ4vAog
cepT2Iya1H5EayJ67zw4SCYslZz5ZaRVdvBgaY5UBpsFegZDww9mQTEcezUDfUb6
xtQSceTINGx4tHI8X6GRTqCbDZPmW/4ikZMAalxYnycDLIzydqo0ieOSIFc1lp5t
XfoCq1gl1yaIaGIS8pGiVhw3xw3WjqFZihFemBcD27icT+Z/9qsT5KxwU1/WlDu4
ftWCfm8Bu1Ujs3Ve7A8QrcGnAT6MVse4sXocsO001041RjcdGj1sgIsFQx2hRBwn
h6CjBR6VS6alGGXtixnoDAWiAwDPYLl7qEoYL4YNxB8AQqPGnAkwj9OijGO/D8xE
ZJmEMoIOqWqkWOsr6l27eWwDCedP8J/0OBLyL0zss7FQKqqbc1emZzfAhVjZ7Out
r4JNxI5SznlxC9hsTIi8zxe9FUgLE1YejVRPs9ao3MERjw5Umz4rg5mCCuI81QDH
DwCY2pad598g06KWm6uzP8wPlsqSqjKCrcmuO8AUb7w3rG/YfrAFTUOo9vhR237B
OjrkDoQbXynEv0R+wYY5A8LtihITPAIGgqL2ifiV7NYTfO50obZo+xW8YGE3Gq99
IWQEcnAhI49X1KTMAem8B+pmda0hj05Riu4h6N3PuwecWHf8nUqHSbya0XrKxdEL
viP3dy1LyVVXKfwYPBS6
=vYtf
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
