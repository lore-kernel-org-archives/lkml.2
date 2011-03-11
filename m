Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1CKHeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:34:12 -0500
Received: from home.keithp.com ([63.227.221.253]:39627 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1CKHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:34:08 -0500
From: Keith Packard <keithp@keithp.com>
To: Indan Zupancic <indan@nul.nu>, Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tino Keitel <tino.keitel@tikei.de>, stable@kernel.org
Subject: Re: [PATCH] drm/i915: Revive combination mode for backlight control
In-Reply-To: <334e13a8513c5863dc9a5d278831777f.squirrel@webmail.greenhost.nl>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com> <20110216192658.GA7225@blimp.localdomain> <20110217221329.GA3332@x61.home> <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl> <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com> <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com> <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com> <20110222130440.21a27714@jbarnes-desktop> <20110222223120.GA3567@x61.home> <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com> <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl> <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com> <1a06e2711df021a802d609ad1a75db17.squirrel@webmail.greenhost.nl> <s5h4o7btnxq.wl%tiwai@suse.de> <s5hy64ns7pq.wl%tiwai@suse.de> <a04bdafb8c7a97d92593e980b01b37fd.squirrel@webmail.greenhost.nl> <s5hr5afm8mj.wl%tiwai@suse.de> <334e13a8513c5863dc9a5d278831777f.squirrel@webmail.greenhost.nl>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Thu, 10 Mar 2011 23:34:01 -0800
Message-ID: <yunei6e2jrq.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Mar 2011 02:23:08 +0100 (CET), "Indan Zupancic" <indan@nul.nu> w=
rote:

> Some nitpicks below. I know you're just restoring the original code,
> but if we improve it we can as well do it now.

Let's pend these changes until after 2.6.38; the backlight code is
fragile enough without trying to 'clean it up' at this point in the
release cycle.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNedBpQp8BWwlsTdMRAu5/AKCBlvr5YlSvpzLCq99eGjKuIe2UTACeK3HH
MmblIWb3NymYJcVMLUf7Bjo=
=K9MH
-----END PGP SIGNATURE-----
--=-=-=--
