Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab1I3SGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:06:30 -0400
Received: from home.keithp.com ([63.227.221.253]:46724 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab1I3SG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:06:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 18/21] drm/i915: Disable eDP VDD in a delayed work proc instead of synchronously
In-Reply-To: <d08817$1mllv9@azsmga001.ch.intel.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-19-git-send-email-keithp@keithp.com> <d08817$1mllv9@azsmga001.ch.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:06:25 -0700
Message-ID: <yunsjnd7vmm.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 11:31:45 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> I think you want the dev->mode_config.mutex here.

oops. good catch.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgUhQp8BWwlsTdMRAltqAJ4/t+ZoA3zrdiZJaVY/as+ut6khSQCgyCR0
VhTi2Sufw33atQJ+/DdXscA=
=XrPN
-----END PGP SIGNATURE-----
--=-=-=--
