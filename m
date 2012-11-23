Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2KWLsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:48:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40454 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027Ab2KWLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:47:59 -0500
Date: Fri, 23 Nov 2012 20:47:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
Message-ID: <20121123114603.GF4529@opensource.wolfsonmicro.com>
References: <20121123081307.GA4529@opensource.wolfsonmicro.com>
 <1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
 <20121123100849.GC4529@opensource.wolfsonmicro.com>
 <20655.20022.819710.39381@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lCXDTVICvIQMz0h"
Content-Disposition: inline
In-Reply-To: <20655.20022.819710.39381@ipc1.ka-ro>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6lCXDTVICvIQMz0h
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 11:21:42AM +0100, Lothar Wa=DFmann wrote:

> I already included the actual error messages I got when loading the
> sound module.
> I also mentioned, that in case of module build some source files
> aren't being compiled with those rules. What else do you expect?

The why part of things - what is the reason there was a problem and how
does your change address it?  What is it that you believe your patch
does to address the problem?

--6lCXDTVICvIQMz0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr2JWAAoJELSic+t+oim9k8cQAJ5mpDe4I00wWL7kDz3puA9P
1+4ZppccETzPo+FxWBeSirEla4FAkyN0puRsdHXalEwBh5D20x5oTnTWMYIrQInW
fTJShL87bbWDNKFa7q/1fc66orsac4yw6PUYCICC1CFMMyIC29SDTkar+1TGAwKD
vFGPpNkmA2acDaZ7Y9vicaU73IEREfnAfm4YMMF51hgtufGV9yMvu0T0IZEh2auG
lhCwxcF1brzxVTusN8EbEVeY1bwyeAvh2mtlpjjKEl2oqxxYGvfXPZ7JN65qCulL
H5CfQdxEcxvyMrWwS507Nxcw8+moOwCnKLvJzWD6++zs/+CmNTGm4DtCNaH6ae9M
k+Iz1i3l9OfDUKHrWzG/XnLxb5BSuzVXLS1IaA4SE0nDJ0aYl/wXmKm4pgucldn5
f3jMjAKXFx1OJtSlY3/GEZ9qZIiiXeCKlYsHTtyQFNy/nE0gcTZuWemxA1vFUSn0
lSbdfJvKd/YWC0b/+mUclYvWlzF1KWBx0T5+FVmnZcVFUTHFa4hHy60UKKK/wjgu
+1V+Fyo6a48jMSo4H/q5iJ3kbQ/DkrhmSimHX5sA59rQa5AFLnsZFUFeYzS+6CZt
C7G4S0zF9em7xCLOkQXSzr3wifQO2XTevCKy03e7zpuMAtTarXgMHMybtJ9W1WFL
2oyzSqVUw46866L/IShn
=mixt
-----END PGP SIGNATURE-----

--6lCXDTVICvIQMz0h--
