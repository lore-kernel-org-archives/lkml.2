Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab1FQUjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:39:19 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:52447 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1FQUjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:39:18 -0400
From: Eric Anholt <eric@anholt.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Widawsky <ben@bwidawsk.net>,
        Kenneth Graunke <kenneth@whitecape.org>, Yi Sun <yi.sun@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mengmeng Meng <mengmeng.meng@intel.com>,
        Robert Hooker <sarvatt@ubuntu.com>
Subject: Re: [PATCH 3.0-rc3, v2] i915: Fix gen6 (SNB) GPU stalling
In-Reply-To: <BANLkTimKKcW3yfDBF2ahYag+kKvdMaA7Mw@mail.gmail.com>
References: <1308328920-2068-1-git-send-email-daniel.blueman@gmail.com> <87zklgnyj0.fsf@eliezer.anholt.net> <BANLkTimKKcW3yfDBF2ahYag+kKvdMaA7Mw@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Jun 2011 13:39:09 -0700
Message-ID: <87hb7oi45u.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Jun 2011 02:20:08 +0800, Daniel J Blueman <daniel.blueman@gmail.=
com> wrote:
> On 18 June 2011 01:44, Eric Anholt <eric@anholt.net> wrote:
> > On Sat, 18 Jun 2011 00:42:00 +0800, Daniel J Blueman <daniel.blueman@gm=
ail.com> wrote:
> >> Workaround Sandy Bridge GPU stalls by allowing the blitter command str=
eamer
> >> to write interrupt state to the Hardware Status Page when a MI_USER_IN=
TERRUPT
> >> command is decoded.
> >>
> >> v1->v2: Moved to prior interrupt handler installation and RMW flags as=
 per
> >> feedback.
> >
> > We shouldn't be RMWing. =C2=A0We're the driver, we're supposed to know =
what
> > we want. =C2=A0I'm backing that bit out, will do another round of testi=
ng,
> > and send it off.
>=20
> I still prefer directly setting the mask due to my earlier reasons.
> Unmasking in the IRQ preinstall tests good here, so I'll send a v3
> patch in the morning.

Already tested and sent v3 out to lkml.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk37u20ACgkQHUdvYGzw6veUnACdHXmGVgb/45SmVDxUI3/UzcLg
0kYAn1Wtl6GXZGylkCQmcb1eE5OwxmeR
=UTZ0
-----END PGP SIGNATURE-----
--=-=-=--
