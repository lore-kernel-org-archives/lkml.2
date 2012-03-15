Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab2COHQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:16:48 -0400
Received: from mail.gw90.de ([188.40.100.199]:57884 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab2COHQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:16:46 -0400
Message-ID: <1331795799.3718.7.camel@mattotaupa>
Subject: Re: [V2 PATCH 2/2] drivers-gpu-drm-i915-invert-backlight-brightness
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Keith Packard <keithp@keithp.com>
Cc: Carsten Emde <C.Emde@osadl.org>, David Airlie <airlied@linux.ie>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Mar 2012 08:16:39 +0100
In-Reply-To: <8662e6inzr.fsf@sumi.keithp.com>
References: <20120314233544.629616190@osadl.org>
	 <20120314234830.227490545@osadl.org> <8662e6inzr.fsf@sumi.keithp.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lQPKSD7DUkmaxepAl6wo"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lQPKSD7DUkmaxepAl6wo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, den 14.03.2012, 19:42 -0700 schrieb Keith Packard:
> <#part sign=3Dpgpmime>

Notmuch sometimes seems to add that line. Is that a bug?

> On Thu, 15 Mar 2012 00:35:46 +0100, Carsten Emde <C.Emde@osadl.org> wrote=
:
>=20
> > This patch adds a module parameter to invert the backlight brightness
> > value before writing and after reading which makes the affected noteboo=
k
> > usable again.
>=20
> You should add a quirk for this and set things up so that your machine
> automatically gets the right value; when we find more machines that do
> this, we can add them so that more people will get a system that 'just
> works'.

Keith, do you mean adding the quirk additionally in a separate patch?
Having that module option would ease testing the workaround without
needing to build a custom Linux kernel with a quirk added.


Thanks,

Paul



--=-lQPKSD7DUkmaxepAl6wo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk9hl1cACgkQPX1aK2wOHVjuPwCcDKSWdklU7CBjs/V+5Njr4be/
wBkAn3mW7f4AMusXhRlGkDPDhco6uC0P
=0SCM
-----END PGP SIGNATURE-----

--=-lQPKSD7DUkmaxepAl6wo--

