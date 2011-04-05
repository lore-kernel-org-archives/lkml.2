Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1DEUSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 16:18:41 -0400
Received: from home.keithp.com ([63.227.221.253]:33116 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1DEUSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 16:18:38 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: i915 fixes for VGA and LVDS DDC probing
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
cc: "Torvalds, Linus" <torvalds@linux-foundation.org>
Date: Tue, 05 Apr 2011 13:18:34 -0700
Message-ID: <yunsjtwfo4l.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Hi Dave,

Please pull two fixes from

        git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6 drm-=
intel-fixes

The first resolves a regression https://bugzilla.kernel.org/show_bug.cgi?id=
=3D32612
with VGA detection.

The second removes the same bogus code from the LVDS detection path.

Changelog:
=2D--------

Chris Wilson (2):
      drm/i915/crt: Remove 0xa0 probe for VGA
      drm/i915/lvds: Remove 0xa0 DDC probe for LVDS

Diffstat
=2D-------

 intel_crt.c  |   20 --------------------
 intel_lvds.c |   24 ------------------------
 2 files changed, 44 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNm3kaQp8BWwlsTdMRApFkAKCpwjRNR2e54E5g/rwqlGTJlmdKXgCg1F3l
ah9Ecj+u9mGTaSoCNdkT+6c=
=naF+
-----END PGP SIGNATURE-----
--=-=-=--
