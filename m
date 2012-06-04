Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2FDANK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:13:10 -0400
Received: from ozlabs.org ([203.10.76.45]:38750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab2FDANJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:13:09 -0400
Date: Mon, 4 Jun 2012 10:13:02 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] h8300/signal: Fix typo "statis"
Message-ID: <20120604001302.GA19504@thor.bakeyournoodle.com>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
 <1338669339-23214-3-git-send-email-geert@linux-m68k.org>
 <20120602213728.GO30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20120602213728.GO30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 02, 2012 at 10:37:28PM +0100, Al Viro wrote:
> On Sat, Jun 02, 2012 at 10:35:36PM +0200, Geert Uytterhoeven wrote:
> > The keyword is "static", not "statis":
> >=20
> > arch/h8300/kernel/signal.c:455:8: error: expected '=3D', ',', ';', 'asm=
' or '__attribute__' before 'void'
> > arch/h8300/kernel/signal.c: In function 'do_notify_resume':
> > arch/h8300/kernel/signal.c:511:3: error: implicit declaration of functi=
on 'do_signal' [-Werror=3Dimplicit-function-declaration]
> > arch/h8300/kernel/signal.c: At top level:
> > arch/h8300/kernel/signal.c:414:1: warning: 'handle_signal' defined but =
not used [-Wunused-function]
> >=20
> > Introduced in commit 7ae4e32a65148353db3458e3eb87117f25620ac5 ("h8300: =
switch
> > to saved_sigmask-based sigsuspend/rt_sigsuspend")
>=20
> Sigh...  This one I don't even have a cross-toolchain for (ICEs galore),
> nevermind the setup to test on ;-/

/me pimps his crosscompilers *again*

http://kernel.org/pub/tools/crosstool/

I know it wont help with boot tests but it will catch simple build
thinko/typos

Yours Tony

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPy/2OAAoJEEsCiJRY75GKBHwQAI9nUg+CwNJNOBTt4QIQDx2Y
OqfvWQLJc1gcQDtUcfYDBKMHNNZmpAKAyCHQS34OGoQ1srN+eNlaUbdbc9hiHtex
RxDUH0hayaPfeza2tWsXBbPr1CSQq/EbVGCRWrJ8+JtWUs1aXgf3F+q7VQJo+prv
IuIk4sVVlPRTb4g0daIFrNliyAU6dh2/C3LpdQv90QhE3fwamaDz/67YTv6zsMRV
y5+0LTJB1MKFykRSzfg9yp/Jr/Y3yKLVozEMAfcZEeMDHZTRFcULrCzO7gNEwTfI
DsVNKyqV53JtMGxIBjUZ3jbbDXd72YLUTDasv1qEaOum0YC+7oSc9gxt0rCpiJj1
A5a+e2Ayhltjmgh3qvpf4zcnWy5zWTSVIFmWrHPqulfcQuuFhSYx4jFU9wMGg1u/
Cg8wM9SHceYnurk5RkPvCwd0Fe2G7MXXv17PbUbLRLqXR2/ejzSdsDcMWGfdTbU4
5nzwLT7KMjYhNxyLD/pDDmvz9vgQCA8N/S+ecV26My1mk6mAp3izl1RuNjPjWALG
iN2xWfN2qGtVlWxkNTmF8c6HkigZgPCwXmMT0WaeVP7xDTO39vcTycaZayEix9ha
nmRnBo4r1OVE82+bzci+nR/gB9ResjcKtLVx3W1EUJfHwdNq+AuFJzlQT6iBicdm
LvTC4OmfCtVocjtDsoUG
=kPAW
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
