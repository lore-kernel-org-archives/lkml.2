Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1EQWAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:00:11 -0400
Received: from home.keithp.com ([63.227.221.253]:43917 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab1EQWAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:00:09 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-next
In-Reply-To: <yunr57z3b58.fsf@aiko.keithp.com>
References: <yunr57z3b58.fsf@aiko.keithp.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 17 May 2011 15:00:01 -0700
Message-ID: <yunfwodyom6.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


I've pushed four more patches to this branch for your merging pleasure.

>  * Disabling FBC on Ironlake to enable RC6 instead

Two patches for this are included.

The following changes since commit 645c62a5e95a5f9a8e0d0627446bbda4ee042024:

  drm/i915: split PCH clock gating init (2011-05-13 18:12:53 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-next

Feng, Boqun (2):
      drm/i915: fix user irq miss in BSD ring on g4x
      drm/i915: clean up unused ring_get_irq/ring_put_irq functions

Jesse Barnes (2):
      drm/i915: add fbc enable flag, but disable by default
      drm/i915: enable rc6 by default

 drivers/gpu/drm/i915/i915_debugfs.c     |    3 ++
 drivers/gpu/drm/i915/i915_drv.c         |    7 +++-
 drivers/gpu/drm/i915/i915_drv.h         |    2 +
 drivers/gpu/drm/i915/intel_display.c    |    5 +++
 drivers/gpu/drm/i915/intel_ringbuffer.c |   50 ++++++++++++++-------------=
---
 5 files changed, 38 insertions(+), 29 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN0u/hQp8BWwlsTdMRAoVKAJ9L3eTfYGKPfce2rDGb5PxyLY7xYwCgzeG2
BAZ3b8xhljFGFBTnosOLZAE=
=x9by
-----END PGP SIGNATURE-----
--=-=-=--
