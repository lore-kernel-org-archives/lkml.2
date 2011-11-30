Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1K3W4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:56:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1K3W4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:56:50 -0500
Date: Thu, 1 Dec 2011 09:56:33 +1100
From: NeilBrown <neilb@suse.de>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111201095633.700e2923@notabene.brown>
In-Reply-To: <CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
	<CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nuBHc5bMr=w8hKZI7kQpxVu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nuBHc5bMr=w8hKZI7kQpxVu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Nov 2011 15:40:48 +0900 MyungJoo Ham <myungjoo.ham@gmail.com>
wrote:

> I'm focusing on an external connector or port that each physical port
> may inhabit multiple cables at a time although it should support a
> port that may inhabit a single cable only at a time. However, the
> class could be used for other general "multistate mux" that connects
> different device drivers.

Hi,
 maybe I'm just slow, but I'm having a lot of trouble imagining a single po=
rt
 that could have multiple cables plugged in at the same time.  And this
 blockage is stopping me from reflecting usefully on your other points.

 Are you able to show me a picture or a diagram or something so I can
 visualise what you are talking about?
 To me: once you plug one cable into a port, it is full and there is no room
 for any more cables.

Thanks,
NeilBrown

--Sig_/nuBHc5bMr=w8hKZI7kQpxVu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTta0oTnsnt1WYoG5AQKQfRAAs4ss2NCxrDQRoP8XS3h+bEz1ZKudAklm
PAWOTMAG063KSi5TItvzPaSKUvIaxTnijH/E63990b62wKHUFoovXQgt1XsP+q9S
LrLDUn+b2SUJxWYNiPGabHPCjHDsQX82fYdDks7DaoiM77/cry8bjSgcLxKkXXyj
+WGpxU/fKOWkYGecffsin1n8D5Ut4jyXWu+wvVK1hI9UoV4fMMgpLTTyyzjayyIg
mR8Iv8I0hj1C66xu1I91wrqvJHQ+HLVvR0QucH9Gc9Tf8O2jS9xx14bXusWrl5fF
N53l8gmikZ4K97E7jem3e/cVmzUunIdmpbAlFu54NjCezRRWZ4PbkiZpxKUQmRgJ
WvA75Iq+QM69rKYd/o3wQ9Ji5cJHleGOZaJbJhIGu9FTpPz+L1Tp10v2M6xz3Gy2
NcsrCcMDG67Y8P2zvRZJBxLkdk49NKYDiPtH4zRs1HQoBTWGgpWJN+rJ8EKoW6d6
AvT3M/K8rRGMwzvBjQ08iDNqEV5HF/Ao7YluUnLvpV00BKXtLfkKWcofgl6oGaae
C164lOqr6ymxVHISRK7z1K7ER5YKyEFziyIO39z0pUkDPwxuO7nzQBkWQjCZE+b4
8WqKw4PakundUWxqY+kylMWY6d2yc93B51AMFBBLwtxOfa4Sw9C9blaDGPZadk6q
MNCqC3sbQjs=
=y6Cm
-----END PGP SIGNATURE-----

--Sig_/nuBHc5bMr=w8hKZI7kQpxVu--
