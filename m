Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2FYTW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab2FYTW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:22:27 -0400
Message-ID: <1340652139.15729.7.camel@atropine>
Subject: Re: Bogus video resolution in Linux 3.5-rc4
From: Adam Jackson <ajax@redhat.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Takashi Iwai <tiwai@suse.de>, dri-devel@lists.freedesktop.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 15:22:19 -0400
In-Reply-To: <87obo7jnmn.fsf@turtle.gmx.de>
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de>
	 <87obo7jnmn.fsf@turtle.gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gsvyrnnbRaBYXd1fPdGJ"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gsvyrnnbRaBYXd1fPdGJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-25 at 19:40 +0200, Sven Joachim wrote:

> > And, does the patch below help?
>=20
> Somewhat: at least I get 1280x1024 again, but at 60 rather than 75 Hz.

That is, in fact, what your monitor claims to prefer.

> The xrandr command shows various bogus modes.

Most of which my patch series would eliminate.

- ajax

--=-gsvyrnnbRaBYXd1fPdGJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk/oumsACgkQW4otUKDs0NO3pACgjtyNdundvgrD1L9/DeW1+om/
lqIAoNe+tFZ3mH9TsEaieBPjh6JNB830
=WRTu
-----END PGP SIGNATURE-----

--=-gsvyrnnbRaBYXd1fPdGJ--

