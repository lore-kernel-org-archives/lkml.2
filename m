Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1LURnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:43:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55050 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1LURnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:43:14 -0500
Date: Wed, 21 Dec 2011 20:47:14 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Subject: [gone in -rc6+] Re: 3.2-rc3+: [drm:i915_hangcheck_elapsed] *ERROR*
 Hangcheck timer elapsed... GPU hung
Message-ID: <20111221204714.6db51fd6@sf.home>
In-Reply-To: <20111205200943.35e63dd0@sf.home>
References: <20111202205601.115522b1@sf.home>
	<20111204015032.47d0d13b@sf.home>
	<20111205200943.35e63dd0@sf.home>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H4gOttCZ+pjQ5utus=Esu36"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H4gOttCZ+pjQ5utus=Esu36
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 20:09:43 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> > > vanilla kernel:
> > > linux-3.2.0-rc3-00099-g883381d
> > >=20
> > > gentoo's userland:
> > > xorg-1.11.2
> > > libdrm-2.4.27
> > > xf86-video-intel-2.17.0
> > >=20
> > > Attached dmesg_1.txt for second dump, but there is nothing fancy.
> > > The issue renders even without suspend/resume cycles. It just takes
> > > a lot of time (0.5-2 days).
> >=20
> > One mode dump. Got GPU hand right after firefox refresh in static page.
> >=20
> > Are you interested in them?
>=20
> And the last one.
> I've noticed GPU hangs quite fast when heavy load is applied to the box
> (like compiling gcc or clang).
>=20
> Switched to fbdev. No issues so far.

Seems to have fixed in 3.2-rc6+

--=20

  Sergei

--Sig_/H4gOttCZ+pjQ5utus=Esu36
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7yG6MACgkQcaHudmEf86of1QCfYNo+sII1ZAaItGTUCVayBqkX
84AAn1S+42WN31R07tIlBousxDwj31pN
=A5d9
-----END PGP SIGNATURE-----

--Sig_/H4gOttCZ+pjQ5utus=Esu36--
