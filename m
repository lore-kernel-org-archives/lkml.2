Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0JSIgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:36:25 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:33669 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab0JSIgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:36:24 -0400
Date: Tue, 19 Oct 2010 09:37:41 +0200
From: Nico Schottelius <nico-linux-20101018@schottelius.org>
To: Nico Schottelius <nico-linux-20101018@schottelius.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Display freezes: 2.6.36-rc6-00137-g7c6d45e and
 2.6.36-rc7-00124-g85a3318
Message-ID: <20101019073741.GA2604@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20101018@schottelius.org>,
	linux-kernel@vger.kernel.org
References: <20101018083307.GA4744@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20101018083307.GA4744@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.36-rc8-00022-g2b666ca x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Update:

Nico Schottelius [Mon, Oct 18, 2010 at 10:33:07AM +0200]:
> as reported before, the system does not freeze completly anymore
> and even reports errors after the nth time resumed (about 10 cycles
> needed). Currently the display gets redrawn VERY slow, if at all.
> Restarting xorg does not help, rebooting the system does.

It seems that this happens more often/always when a second
monitor is enabled using xrandr.

At least the two last times the slow drawing state occured
directly after the first resume with an enabled external
monitor.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAky9SsUACgkQ19zI5DGHffAMmgCdEzTC24Cjzfky0rPh3lnf7xIA
TBsAoKtw0WdDKP6TTMUxF7p6eqOGLrIj
=yRFm
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
