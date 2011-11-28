Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1K1CxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:53:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43043 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab1K1CxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:53:24 -0500
Date: Mon, 28 Nov 2011 13:53:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20111128135317.a99880b234c6c060a622fa31@canb.auug.org.au>
In-Reply-To: <CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
	<CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_13_53_17_+1100_i+4n=4q27SY6shMP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_13_53_17_+1100_i+4n=4q27SY6shMP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 25 Nov 2011 10:34:19 +0000 Dave Airlie <airlied@gmail.com> wrote:
>
> I just pushed jbarnes patch into my tree for now, at pushed out the
> mainline gma500 code with it.

And it is a mess (see my linux-next reports).

> But if someone can send a patch to Greg to mark GMA500 broken in
> staging that would be good.

See my reply to Alan.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Nov_2011_13_53_17_+1100_i+4n=4q27SY6shMP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0vedAAoJEECxmPOUX5FEEAoP/01Qmo/rxxW4GLdRF690crGo
AODFIcLjUm55CoExIoFEWMvwM3x0jQ8GETUQ+XePSG1FpevE0aFPA5kn2u8o6KGy
66KFVAQEOXsYfD4dtXmnBpepkcnnNGf8MFCZfK3Fg6LkVLfla/y9VC1CtAeO9MpP
xKpuxFBsUqF1c7tbUkPwKhMoUopQUh62AZceGBF9slSL9TgzLepQQKi7r0rMLVWn
NHSYufEqvGjDKQaYTjfuZrgM54KRfxh61TqyCY7k4z+SpqnBLKT+jpvH0uJk6LUO
YNgg0MZDipAa5OtN7ys2wJnAxY2bdQmSdjOhm5hpHERGYtfuvOqAwiP2Tnfyh2P2
nMSwYo4RuKSqAfURwSNW6YvalzlCMD3itR4IRiqyfgSsx9xOJgQBuKC7JNsEGRS1
hLxAaCbTj5peG1umrCCMj3fAeadjbXSFHxBpk7aTayaqW1clZubdpk+pUMxeduIq
sEQ7GkPYxrhS7wo/KN6TZCGqs7hCI8g0Cn+d1fHe6Rra4l6Su4i29m9TYoqtq7TV
VF3vEFl4KxElRdnO8eb9VERwTHSKxAwNLih1NrsL0x3BQSxYIQsYpOqEHpl7Or38
D3tjizH884WIHOpKMNQW02Bt490dIKUVPbiSh01OKNLM2llgqxnPhed7woviZdAY
Xjz6Tf+zUlpRUiO1MJZJ
=8leR
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_13_53_17_+1100_i+4n=4q27SY6shMP--
