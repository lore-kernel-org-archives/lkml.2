Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1H0OJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:09:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61403 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1H0OJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:09:47 -0400
Date: Sat, 27 Aug 2011 17:12:58 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: Re: i915: 3.1.0-rc3+: WARNING: at fs/sysfs/dir.c:455
 sysfs_add_one+0xb8/0xf0()
Message-ID: <20110827171258.3a65b38e@sf.home>
In-Reply-To: <CAKi4VAKHR9EBTwwdmkzf=22LFvWr7L-xFwZ0=V=jB1iKY_+ekw@mail.gmail.com>
References: <20110826233028.074830de@sf.home>
	<CAKi4VAKHR9EBTwwdmkzf=22LFvWr7L-xFwZ0=V=jB1iKY_+ekw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/T37_Sj1mY4B=n3Zkjp_TJ65"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T37_Sj1mY4B=n3Zkjp_TJ65
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> >> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xf0()
> >> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:0=
2.0/drm/card0/card0-LVDS-1/intel_backlight'

> There's another patch that fixes this issue:
>=20
> https://patchwork.kernel.org/patch/1086232/

Yeah, it fixes WARNING: for me and yet does not break anything.

Thank you!

--=20

  Sergei

--Sig_/T37_Sj1mY4B=n3Zkjp_TJ65
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5Y+20ACgkQcaHudmEf86qVJACfT4inzHbCsfNIM8EPnMOIyugM
qsQAn3EUGBR6lAOUSrYCNC5O/1l6LyFm
=izBE
-----END PGP SIGNATURE-----

--Sig_/T37_Sj1mY4B=n3Zkjp_TJ65--
