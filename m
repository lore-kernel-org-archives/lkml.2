Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1GNQG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:06:28 -0400
Received: from home.keithp.com ([63.227.221.253]:38081 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1GNQG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:06:27 -0400
From: Keith Packard <keithp@keithp.com>
To: Francesco Allertsen <fallertsen@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reverting rc6 by default
In-Reply-To: <20110714075007.GB2949@fujiko>
References: <20110621155205.GA2488@fujiko> <yunboxrxiz2.fsf@aiko.keithp.com> <20110621164209.GA2155@fujiko> <yun8vsvxdr4.fsf@aiko.keithp.com> <20110621184757.GA2185@fujiko> <yunzklb9fg1.fsf@aiko.keithp.com> <20110705230101.GD2852@fujiko> <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com> <yunhb6rec97.fsf@aiko.keithp.com> <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com> <20110714075007.GB2949@fujiko>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 14 Jul 2011 09:06:20 -0700
Message-ID: <yuntyaohmo3.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Jul 2011 09:50:07 +0200, Francesco Allertsen <fallertsen@gmail.c=
om> wrote:

> The correct commit is 05bd42688dbc066d4e2689b6f73c0470601f788b, the one
> you mentioned is "Idling requires waiting for the ring to be empty".

We mentioned the 'Idling' fix as it may make RC6 work. Have you tried
that with RC6 enabled on the command line (or with
05bd42688dbc066d4e2689b6f73c0470601f788b not applied)? Obviously, not
enabling RC6 by default will 'fix' things, but only with a huge hit to
power consumption.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHxP8Qp8BWwlsTdMRAposAJ9Vc3y22ZPAWnAlX5CVktJKjpXWPwCcCp6c
yTMAtee8glaf20t++iHWWOk=
=HxIK
-----END PGP SIGNATURE-----
--=-=-=--
