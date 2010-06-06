Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0FFWxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 18:53:30 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:35505 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0FFWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 18:53:29 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel changes for 2.6.35-rc1
In-Reply-To: <alpine.LFD.2.00.1006052048430.3515@i5.linux-foundation.org>
References: <871vcqihj2.fsf@pollan.anholt.net> <alpine.LFD.2.00.1006050902160.3593@i5.linux-foundation.org> <alpine.LFD.2.00.1006052048430.3515@i5.linux-foundation.org>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Sun, 06 Jun 2010 15:53:20 -0700
Message-ID: <87fx0zg4db.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Jun 2010 20:49:53 -0700 (PDT), Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>=20
>=20
> On Sat, 5 Jun 2010, Linus Torvalds wrote:
> >=20
> > Eric - I want to do an -rc2 later today, and the current intel graphics=
=20
> > code has the known problems with cursors not changing right. Can you se=
nd=20
> > me the patch/pull request so that we can get that particular regression=
=20
> > fixed before I release -rc2?
>=20
> Oh well. I didn't hear back, so I just took the patch from the bugzilla=20
> entry, since I see (saw) the problem myself, and refuse to do an -rc that=
=20
> has some bug that affects me and that I can verify personally.
>=20
> It's commit e7b526bb85.

Sorry about that, I was offline yesterday, and had been intending to
pull-request on Monday.  Here's 3 more changes I had queued:

The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh=
/powerpc (2010-06-01 14:13:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Adam Jackson (1):
      drm/i915/gen4: Fix interrupt setup ordering

Carl Worth (1):
      Revert "drm/i915: Don't enable pipe/plane/VCO early (wait for DPMS on=
)."

Chris Wilson (1):
      drm/i915: Move non-phys cursors into the GTT

Dave M=C3=BCller (1):
      drm/i915: Use RSEN instead of HTPLG for tfp410 monitor detection.

 drivers/gpu/drm/i915/dvo_tfp410.c    |    2 +-
 drivers/gpu/drm/i915/i915_irq.c      |   50 +++++++++++++++---------------=
---
 drivers/gpu/drm/i915/intel_display.c |   14 +++++++++
 3 files changed, 38 insertions(+), 28 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwMJuAACgkQHUdvYGzw6vcc3gCeNMtAOhjLcw7zQ2N5SHnYbSbX
BkYAn015arI+bKtKHb04yxaYnd/q0iNo
=g6LS
-----END PGP SIGNATURE-----
--=-=-=--
