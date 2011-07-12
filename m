Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1GLPmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:42:49 -0400
Received: from home.keithp.com ([63.227.221.253]:60327 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1GLPms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:42:48 -0400
From: Keith Packard <keithp@keithp.com>
To: Pekka Enberg <penberg@kernel.org>,
        Francesco Allertsen <fallertsen@gmail.com>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reverting rc6 by default
In-Reply-To: <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com>
References: <20110621142133.GA3652@fujiko> <yunhb7jxkz2.fsf@aiko.keithp.com> <20110621155205.GA2488@fujiko> <yunboxrxiz2.fsf@aiko.keithp.com> <20110621164209.GA2155@fujiko> <yun8vsvxdr4.fsf@aiko.keithp.com> <20110621184757.GA2185@fujiko> <yunzklb9fg1.fsf@aiko.keithp.com> <20110705230101.GD2852@fujiko> <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 12 Jul 2011 08:42:44 -0700
Message-ID: <yunhb6rec97.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Jul 2011 10:33:06 +0300, Pekka Enberg <penberg@kernel.org> wrote:

> AFAICT, this problem is still there in 3.0-rc7. Keith, isn't it time
> to revert commit a51f7a6 ("drm/i915: enable rc6 by default") before
> 3.0 is out?

Yes. I'll put together a few tiny patches including this.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHGt0Qp8BWwlsTdMRAgKuAJwJ7XMa3CbjPvJY9rmBiHE0LogedQCg00Id
dQjpstnzAmqdaBsMSK5obhs=
=8k/a
-----END PGP SIGNATURE-----
--=-=-=--
