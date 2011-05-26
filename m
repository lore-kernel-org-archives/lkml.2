Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab1EZEOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:14:11 -0400
Received: from home.keithp.com ([63.227.221.253]:37299 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1EZEOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:14:10 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-next
In-Reply-To: <yuntycs7v7z.fsf@aiko.keithp.com>
References: <yunr57z3b58.fsf@aiko.keithp.com> <yunfwodyom6.fsf@aiko.keithp.com> <yuntycs7v7z.fsf@aiko.keithp.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 25 May 2011 22:13:55 -0600
Message-ID: <yun39k2gku4.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


This fixes a simple typo in the Ivybridge code -- an extra semicolon.

The following changes since commit 9e3c256d7d56a12a3242222945ce8e6347f93fa0:

  drm/i915: initialize gen6 rps work queue on Sandy Bridge and Ivy Bridge (=
2011-05-18 15:14:39 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-next

Dan Carpenter (1):
      drm/i915: fix if statement in ivybridge irq handler

 drivers/gpu/drm/i915/i915_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN3dODQp8BWwlsTdMRAp0yAKC5Ws/B4Ab/8gCMxiMovtcvOtcLowCfd25w
sOwWQQSdbSDo4ln13JdVeec=
=Gk2q
-----END PGP SIGNATURE-----
--=-=-=--
