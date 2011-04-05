Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab1DEBrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:47:55 -0400
Received: from home.keithp.com ([63.227.221.253]:46629 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab1DEBry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:47:54 -0400
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <BANLkTimtAy7wTq8dbhy3LKVHAM=pS6A4-w@mail.gmail.com>
References: <alpine.DEB.2.00.1104050137040.8684@skynet.skynet.ie> <yun4o6dik8g.fsf@aiko.keithp.com> <BANLkTimtAy7wTq8dbhy3LKVHAM=pS6A4-w@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 04 Apr 2011 18:47:46 -0700
Message-ID: <yuny63ph3jx.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Apr 2011 18:09:55 -0700, Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:

> I'm not doing an -rc2 until tomorrow, though, so hopefully the issue
> will be resolved and a fix pushed to me by then.

Should be resolved this evening; someone is trying to use an i2c address
of 0xa0, which is obviously wrong, we're just trying to figure out where
that code came from.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNmnTCQp8BWwlsTdMRAifbAJ9FlWbxMX0cf1Xxd+yE17yPthNH6ACgjMze
tNElsrSpySJ8nAitA7kTFfg=
=Dc0P
-----END PGP SIGNATURE-----
--=-=-=--
