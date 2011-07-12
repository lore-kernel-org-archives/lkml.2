Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1GLPrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:47:25 -0400
Received: from home.keithp.com ([63.227.221.253]:48242 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1GLPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:47:23 -0400
From: Keith Packard <keithp@keithp.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Robse <rob-se@live.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #37472] Lenovo U160 (i915 black screen)
In-Reply-To: <gioc0z6gn2.fsf@karga.hank.lab>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.NJ.7lYGOB@chimera> <CAOJsxLGkWX61TLqwgL19tN5ZQuB2cUibPsNSvCB+Ydihtus__w@mail.gmail.com> <yun7h7pg8y7.fsf@aiko.keithp.com> <gisjqb6h0q.fsf@karga.hank.lab> <gioc0z6gn2.fsf@karga.hank.lab>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 12 Jul 2011 08:47:19 -0700
Message-ID: <yunei1vec1k.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Jul 2011 10:35:13 +0200, Dirk Gouders <gouders@et.bocholt.fh-gel=
senkirchen.de> wrote:

> I'm sorry for the noise, I did not check new comments in the bug report
> where Robse noted that the workaround works for him.  I'm not sure if
> that means the bug can be closed.

A kernel commandline workaround isn't ideal; we should at least provide
a quirk that does this automatically for this hardware. Can we get the
PCI information for the graphics device on this hardware (lspci -v -n)?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOHGyHQp8BWwlsTdMRAkNEAJ9mp2xyLUl1Pvd/taJez7H3GtnR4wCgrne7
b9hOIxlNuT0L6/89rxhwl+g=
=IVWY
-----END PGP SIGNATURE-----
--=-=-=--
