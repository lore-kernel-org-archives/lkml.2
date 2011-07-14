Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1GNQCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:02:13 -0400
Received: from home.keithp.com ([63.227.221.253]:37121 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1GNQCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:02:12 -0400
From: Keith Packard <keithp@keithp.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Francesco Allertsen <fallertsen@gmail.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reverting rc6 by default
In-Reply-To: <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com>
References: <20110621142133.GA3652@fujiko> <yunhb7jxkz2.fsf@aiko.keithp.com> <20110621155205.GA2488@fujiko> <yunboxrxiz2.fsf@aiko.keithp.com> <20110621164209.GA2155@fujiko> <yun8vsvxdr4.fsf@aiko.keithp.com> <20110621184757.GA2185@fujiko> <yunzklb9fg1.fsf@aiko.keithp.com> <20110705230101.GD2852@fujiko> <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com> <yunhb6rec97.fsf@aiko.keithp.com> <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 14 Jul 2011 09:02:07 -0700
Message-ID: <yunwrfkhmv4.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Jul 2011 10:37:15 +0300, Pekka Enberg <penberg@kernel.org> wrote:

> This if fixed in mainline as of commit
> a94919eaddaa3fede1df8563ce4d761a75374645 ("Revert "drm/i915: enable
> rc6 by default"). Keith, it would have been nice to include a
> 'Reported-by' and/or a link to this discussion in the changelog for
> future reference.

Yes, I'm sorry I didn't remember to include a link.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHxL/Qp8BWwlsTdMRAjwdAJ0aqMeGSIPJRIoNETqmVZwSoH5zIACgsJ+d
uuNJFty3W27UDKiFeRXNd/k=
=X54v
-----END PGP SIGNATURE-----
--=-=-=--
