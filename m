Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1KUQ4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:56:38 -0500
Received: from home.keithp.com ([63.227.221.253]:59236 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab1KUQ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:56:36 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Cc: "Wang\, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio driver
In-Reply-To: <20111121110538.GB6519@localhost>
References: <20111116132004.299754849@intel.com> <20111116132221.374839261@intel.com> <20111116133548.GA23804@localhost> <20111118093740.GA2799@localhost> <86aa7tmigr.fsf@sumi.keithp.com> <20111121015809.GA25148@localhost> <s5haa7plv4l.wl%tiwai@suse.de> <20111121110538.GB6519@localhost>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 21 Nov 2011 08:56:30 -0800
Message-ID: <86ehx1ifcx.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011 19:05:38 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:

> Ah I got it. I'm running debian+fluxbox w/o those fancy features...

Then you can manually run the 'xrandr' command to configure the new
monitor as desired, at which point the kernel mode_set function will be
called.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsqCvjYtFsjWk68qAQggKRAAteIvOKUwISbuG74URp5jGyzr2T/KM4E7
eUezwMUekmGnXJhEvc5JumkMBZmdkSPQQmi/HVVP4rqYfQxLScrWJMh4lRl9aS3k
oKy3VAqNb8Fxx35jFqTIwlMYm3bdfW7Yykx6HDUx8NtaGukuONPo7yZHykJ1hR9x
6XTpxhkgV63Nq/7wMJAbYRev9H1wd+XOcxBvAcaec8psXXrklCU6J5+qzAeZZmQi
x8RcRtdthTBflZYNzj8ZZ21+Cf/IS7oePWgbAU2oBu6a0euhnwKUH2gyo8vwrAdT
nl82l4ySOifB/YI2R0NCtunF7En3REHMIfYdwFS2sWLJo6zgC6eztKVUDT86FAxz
ps59Xv4yn9YT53AgXkKB3D3f9/KwD2KExFA4RNVSPtqTNxPQoLJE2WEPV43+vWL0
UUl95bBsSBzxe/IHwuAAfMBaWyMy/5BkZnQgI4c6Q4rTFH9nZWkQXpstELfAtA/e
/GAt62nuviBKL+Kc/hmB3ne9u4jbQIigSq4CK+JbQqtE4XKOXn7wDVp2ezsbIULq
HkSWqWmHMLsQrmjGrMGnK0QXA5d89cWH+be+tl/RYxEwc+ygoX2jV9iRyg5ppyNT
9LZ873HHwcoMDyqMGUxZDjfZ9pNd8OSneLIiDlNjkYuddqfEiC8X7H5ToSRbLw3c
MdIAVC5mJb8=
=myDT
-----END PGP SIGNATURE-----
--=-=-=--
