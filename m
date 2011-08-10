Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HJQeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:34:12 -0400
Received: from home.keithp.com ([63.227.221.253]:39446 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1HJQeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:34:10 -0400
From: Keith Packard <keithp@keithp.com>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Dave Airlie <airlied@linux.ie>,
        Intel drivers <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, stable@kernel.org
Subject: Re: [PULL] drm-intel-next
In-Reply-To: <4E42AFBE.7000502@mit.edu>
References: <yunhb5xlvfy.fsf@aiko.keithp.com> <4E42AFBE.7000502@mit.edu>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 10 Aug 2011 09:34:06 -0700
Message-ID: <yun39h9gr9d.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Aug 2011 12:20:14 -0400, Andy Lutomirski <luto@MIT.EDU> wrote:

> Can you ack at least this one:
>=20
> >        Revert and fix "drm/i915/dp: remove DPMS mode tracking from DP"
> (i.e. d2b996ac698aebb28557355857927b8b934bb4f9)
>=20
> for -stable?  It fixes an annoying regression in 3.0.

I'm working on a set of patches for -stable; we've found a number of
small patches that fix some fairly serious regressions.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOQrL+Qp8BWwlsTdMRAulpAJ4vAmWxZVeaOQYlUvc1jZH2VfUNPgCeNLG+
aATsbbCtth4jSHyJ0rUwFo4=
=Zr+0
-----END PGP SIGNATURE-----
--=-=-=--
