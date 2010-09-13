Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0IMVmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:42:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39843 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0IMVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=pe83aKDCmkkwa0PgKQOgXl1o9m09nqZzs2efV6uK20+ek0Yw3dGlgaKKz9t8aOLdSv
         lroAAYuQer1A8kkQOWoIBLbSHt2dYQ5NCFp8/M1ozy8DbXXwJDQ6LqlXtgmwOKuAW56w
         up7ym6h/HmLrVX0nUbS17ThD1ydZGDQx30OJw=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Tue, 14 Sep 2010 00:41:18 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r5-anarsoul; KDE/4.5.1; i686; ; )
Cc: intel-gfx@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009140010.14783.anarsoul@gmail.com> <20100913141955.752cbdea@jbarnes-desktop>
In-Reply-To: <20100913141955.752cbdea@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1564341.KjfylMJfeW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009140041.23645.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1564341.KjfylMJfeW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
14 of September 2010 00:19:55 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Jesse Barnes =
=D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> On Tue, 14 Sep 2010 00:10:08 +0300
>=20
> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > =D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=
=82 13 of September 2010 23:44:41 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Jesse Barn=
es =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > > I remember seeing a similar problem on an Eee PC I had; it seemed to =
be
> > > timer/interrupt related somehow.  If I booted with clocksource=3Dtsc
> > > (or maybe it was pit) I got nice smooth animations, but if I used the
> > > HPET things were really slow.
> > >=20
> > > Does the same work for you?
> >=20
> > Yeah, it works for me (will use it as temporary workaround). But it
> > definitely is not clean solution, as I can't use nohz mode with tsc
> > clocksource :)
>=20
> Thomas, does this ring any bells for you?
>=20
> I think the root symptom of the issue is that we get a much reduced i915
> interrupt frequency (or no interrupts) on some 945GM platforms when
> using HPET as our clock source.
>=20
> In fact, on the platform I tested, it seemed that the i915 IRQs wouldn't
> generate interrupts at all when HPET was used.  But shaking the mouse or
> generating network traffic was enough to get i915 interrupts coming in,
> even though neither of those interrupts were shared with the i915
> device.
>=20
> Here's hoping you have some ideas to try...
>=20
> Thanks,

Jesse, is it possible to disable wait for vsync somehow? cpufreq is not=20
working for me with nohz=3Dno for some reason, as result cpu temperature an=
d=20
power usage are higher. I prefer to see tearing but with low power usage an=
d=20
without jerky keyboard :)

Regards
Vasily

--nextPart1564341.KjfylMJfeW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkyOmoMACgkQRM6pQpltKE5WFwCgvIK9Bb3sIzsIqhYAcun7bIxl
FC8AoNVQ0Lh1S7oHf+A7XCQpXh/TULWD
=pDik
-----END PGP SIGNATURE-----

--nextPart1564341.KjfylMJfeW--
