Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1EQXjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:39:40 -0400
Received: from home.keithp.com ([63.227.221.253]:39317 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1EQXjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:39:40 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-next
In-Reply-To: <yunfwodyom6.fsf@aiko.keithp.com>
References: <yunr57z3b58.fsf@aiko.keithp.com> <yunfwodyom6.fsf@aiko.keithp.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 17 May 2011 16:39:28 -0700
Message-ID: <yuntycs7v7z.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 17 May 2011 15:00:01 -0700, Keith Packard <keithp@keithp.com> wrote:
>=20
> I've pushed four more patches to this branch for your merging pleasure.

And, one more which fixes non-eDP displays on Ironlake systems after the
Ivybridge merge. Sorry for not catching that in our testing...

The following changes since commit a51f7a66fb5e4af5ec4286baef940d06594b59d2:

  drm/i915: enable rc6 by default (2011-05-17 14:33:38 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-next

Keith Packard (1):
      drm/i915: FDI link training broken on Ironlake by Ivybridge integrati=
on

 drivers/gpu/drm/i915/intel_display.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN0wcxQp8BWwlsTdMRAkxSAJ9lav9p0ajdKVmbGzan3TRgnQsJWQCfZaNf
9MdnEX1xyyRJnv+Dh0UxbYs=
=QA6S
-----END PGP SIGNATURE-----
--=-=-=--
