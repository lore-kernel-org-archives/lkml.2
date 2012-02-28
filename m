Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965979Ab2B1ShQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:37:16 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46825 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965107Ab2B1ShO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:37:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Grant Grundler <grantgrundler@gmail.com>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Tue, 28 Feb 2012 13:37:10 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: John David Anglin <dave.anglin@bell.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com> <4F4CF3CF.5090605@bell.net> <CANEJEGv2Zgtd8TGOzSNO8opMLQT8RsGRP=m2rBPUBBOJ9f+fKQ@mail.gmail.com>
In-Reply-To: <CANEJEGv2Zgtd8TGOzSNO8opMLQT8RsGRP=m2rBPUBBOJ9f+fKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1979808.xE6xXEOG8i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202281337.14094.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1979808.xE6xXEOG8i
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 28 February 2012 13:22:50 Grant Grundler wrote:
> On Tue, Feb 28, 2012 at 7:33 AM, John David Anglin wrote:
> > On 2/28/2012 10:21 AM, Mike Frysinger wrote:
> >> we've been using hppa2.0 for years.  gnuconfig certainly recognizes it:
> >> $ grep hppa /usr/share/gnuconfig/config.**sub
> >>=20
> >>         | h8300 | h8500 | hppa | hppa1.[01] | hppa2.0 | hppa2.0[nw] |
> >>=20
> >> hppa64 \
> >>=20
> >>         | hppa-* | hppa1.[01]-* | hppa2.0-* | hppa2.0[nw]-* | hppa64-*=
 \
> >>=20
> >> and i've seen diff projects key off of the hppa2.0* to enable newer
> >> features by
> >> default.
> >=20
> > Some of the above are specific to HP-UX, but hppa1.1, hppa2.0, hppa and
> > hppa64 are
> > valid for Linux based on config.guess.
>=20
> Mike, et al,
> I'd suggest NOT using hppa2.0 as a surrogate for 64-bit build. I'd prefer
> hppa64 if 64-bit is meant.
>=20
> hppa2.0 can also mean PA2.0 compliant binary compiled using ILP32 model.
> right?

i don't think that's what the proposed change does.  James' patch runs $(CC=
)=20
to find the active tuple, then replaces the first part with "hppa64" to get=
 a=20
64bit toolchain automatically.  but that magic only works when the tuple is=
=20
"hppa-xxx" and so will fail when the system is using "hppa2.0-xxx".

short story: the proposed change will additionally support turning "hppa2.0-
linux-gnu" into "hppa64-linux-gnu" rather than the existing "only turns hpp=
a-
linux-gnu" into "hppa64-linux-gnu".
=2Dmike

--nextPart1979808.xE6xXEOG8i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPTR7ZAAoJEEFjO5/oN/WBuXkP/0q95mFhnAbLaazZUGDiQP6r
2CtwhKJsC9795qEyYd7onQsiTN0DJprihiI1BV/xdKBCOateoWfrCjgvbt3HupOB
DaMV8l/bXys6dlgGIe7QrbOod+wDk2RLmkUi5eFa2WM8mwSO/FieX1iHOk4rc017
UKecJJwZSdfKTkzWgk4ocLAfswtXjloj7zj4dw58Fn+BzwaAXXr33tYHKBVqLS9J
BF/vJMOduqK4sB3YEc+aJB0ZikNHYyfeK4LTrYcO2xXYAIKxSciV3vIW/QEsmOXv
RlR/BxhBDbkNUrH4hndMBoDlf5TP7yJFNMsi3IkifVAcgyhNFsuKtZ5sppCb5yHj
xENWX7pSLeQv3QrmXPe3SMiX0gb30lMtH5aPxcOzfnNaB7526OD+hx0zMdnu0+0J
iRMAnjNrfsawjpUx607AwMiOzgPEC31xWXrD8XBx44R8yx/r+a4uzPWsw4kSo4ju
OBqYlggdQSapjxkVMvWy3WmGlMJJmga1ZUIw4kNWQnenZavQElvRz/LMmaL/Eobe
fzWJ2cQhRL2rkXQ1dt2EEsQLcQpEBkXdBxfWp9hNRtaehQxl6CDSSOyfURWns+yv
KsbkTg7CKZNyU5hhLOyxwFGzlsakn5f/Qm2e3BpRvT88Nv2x+F1mobQOIALIP7/u
WnOW3Jl+FpJAk6tSZJ/d
=Lto8
-----END PGP SIGNATURE-----

--nextPart1979808.xE6xXEOG8i--
