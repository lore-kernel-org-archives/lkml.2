Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2KWINP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:13:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42247 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab2KWINO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:13:14 -0500
Date: Fri, 23 Nov 2012 17:13:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX PATCH] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
Message-ID: <20121123081307.GA4529@opensource.wolfsonmicro.com>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
 <20121123020517.GJ4385@opensource.wolfsonmicro.com>
 <20655.7916.566188.590202@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20655.7916.566188.590202@ipc1.ka-ro>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 07:59:56AM +0100, Lothar Wa=DFmann wrote:
> Mark Brown writes:

> > What is the actual bug here?  This fix doesn't look obviously right, and
> > if we do need to move to -objs for some reason then the block ought to
> > be in the -objs section of the Makefile.

> As I mentioned in the part of my email that you didn't quote, if the
> sound driver is being compiled as module, the files imx-pcm-fiq.c or
> imx-pcm-dma.c which should be compiled as part of imx-pcm.o will not
> be touched by the compiler:

That's more detailed than your previous mail but you're still only
describing the symptom, not the what the actual error is or how it's
fixed...

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQry/wAAoJELSic+t+oim9PI4P/17lQqgJM7mGjhUn6DJ00W0C
PQqqfIO7RUzHrgRP4FcWhmgt6nAiQJxbOr8k/KnLyZmLpn0fYfkNMGj2QIYkiWgT
i2b0VWLJftQ6FdFsL0GC+l02VpCghrFji5J7fgLG4l8YDimNycqLTttZfvhLuhhL
v0NGbrSn/9YxbY5NkUcy9oE2J1/itMkqWvStXn0BUAiD3fSo6TiwJtwz9o+pA/wc
wApAUUiHBvV7vXnepMIFVA/1jj/anp6C7R/PfNsiJkiLgmmxjqbd8Bqm8rEf6xip
FQ638w4BRYcbGdaH2l8hlktIE7QwEHLkNysw+/wlKI6DxQ6P2+WVb1cevUhApMkI
orhb+VgyngmrXxPRYAy+AnYoBh1bQuamcurea19LWE3u5uiaJLtd52+yspGiP4jm
9hYuKqnV5a/4iFBcIwA6lbdIkJYmQAfbxW469Y/M9ogLe1NO+1EvetnOEPNfCUBg
3wU5FvkGTtJUYI4/rDgNFAX7/ltmuqK6mvWkIKJCiB2wpyuMDMTFdTEweCHX21Oa
j30wdY8/2z3LMFE/PJMu711Nn5zGqHThDyP8ZmIzhKJEOYrm6OUfCNzENeV+3kvO
WtaewjDJg2D7YcL3sGOAQWMlTYdHzNFGTNmTLAJUL92ZxhLV9NCNgVuDTbnRIPDP
4pi17Lfb7crDqV5pdsSh
=BMeT
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
