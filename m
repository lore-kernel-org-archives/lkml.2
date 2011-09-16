Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1IPDcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 23:32:04 -0400
Received: from home.keithp.com ([63.227.221.253]:43694 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1IPDcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 23:32:01 -0400
From: "Keith Packard" <keithp@keithp.com>
To: airlied@gmail.com, Akshay Joshi <me@akshayjoshi.com>
Subject: Whitespace cleanups in drm/i915
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Thu, 15 Sep 2011 18:37:33 -0700
Message-ID: <yun8vppw9lu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


I've got this nice patch from Akshay Joshi that removes almost all of
the checkpatch.pl warnings from drm/i915. If I don't merge it now, it's
going to go stale and be useless; if I merge it only to drm-intel-next,
it will be the source of endless conflicts.

However, it's a huge patch (yes, the code was rather sloppy), and
doesn't exactly fit into the "critical patches only please" mode of the
current stage of 3.1 development.

I've checked the patch very carefully, using the obvious git diff -b to
make sure it really doesn't touch anything but whitespace, but also
using objdump -s to compare the output of the compiler. There were no
differences found with git-diff -b. The only differences found by
objdump are two whitespace changes in some debug output messages in
intel_bios.c.

I think I have three choices:

 1) merge the patch and expect complaints from upstream

 2) thank Akshay for his good intentions, discard the patch and hope
    that he feels motivated enough to do it all over again in time for
    the 3.2 merge window.

 3) thank Akshay for his good intentions and leave the code as-is,
    forever to ease back-porting of fixes to older kernel versions.

Frankly, if we're ever going to merge whitespace fixups, this would be a
pretty darn good time; drm-intel-fixes and drm-intel-next are in-sync as
I haven't started pulling 3.2 code into -next.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOcqhdQp8BWwlsTdMRAiPHAJ9t7DwJ4O1UzslZJfUwUBUutbjuNgCfcyLJ
E2OJAjcJvPBtMsod9IjW+Y4=
=BOZP
-----END PGP SIGNATURE-----
--=-=-=--
