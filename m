Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1GJUqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:46:49 -0400
Received: from home.keithp.com ([63.227.221.253]:48164 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1GJUqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:46:45 -0400
From: Keith Packard <keithp@keithp.com>
To: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Robse <rob-se@live.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #37472] Lenovo U160 (i915 black screen)
In-Reply-To: <CAOJsxLGkWX61TLqwgL19tN5ZQuB2cUibPsNSvCB+Ydihtus__w@mail.gmail.com>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.NJ.7lYGOB@chimera> <CAOJsxLGkWX61TLqwgL19tN5ZQuB2cUibPsNSvCB+Ydihtus__w@mail.gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 10 Jul 2011 13:46:40 -0700
Message-ID: <yun7h7pg8y7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Jul 2011 14:56:19 +0300, Pekka Enberg <penberg@kernel.org> wrote:

> There's no mention that the i915 developers know about this problem so
> I'm CC'ing Keith and Chris.

Thanks. I've added a comment to the bug:

First off, of course you are encouraged to re-test with 3.0-rc6 just to
make sure it hasn't changed in some way. I don't think anything has
changed enough to affect this, but it's always good to be sure.

I note a long sequence of patches that are supposed to help with the
U160:

448f53a1ede54eb854d036abf54573281412d650 drm/i915/bios: Reverse order of 10=
0/120 Mhz SSC clocks
bcfbbce822d219eb587acaba8a6e062bbeae4761 Revert "drm/i915/bios: Reverse ord=
er of 100/120 Mhz SSC clocks"
a76150302d6e7ebc43e1a1ddaee7fd51db8da3b3 drm/i915: Add a module option to o=
verride the use of SSC

I'm not sure why a quirk wasn't added for this hardware; it's clearly
'non-standard' in some mystic way.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOGg+wQp8BWwlsTdMRAlJ9AJ0aysob1rpLhcgLgHLmaSPOpKbTPQCdE9sg
wS4P4BsoGtzL9Vj1SuYP2lA=
=UXgp
-----END PGP SIGNATURE-----
--=-=-=--
