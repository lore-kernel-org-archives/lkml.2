Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1LLRVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:21:14 -0500
Received: from home.keithp.com ([63.227.221.253]:43918 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1LLRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:21:13 -0500
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed address is invalid"
In-Reply-To: <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com> <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com> <86sjkpiw8i.fsf@sumi.keithp.com> <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com>
User-Agent: Notmuch/0.10.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 12 Dec 2011 09:21:51 -0800
Message-ID: <86mxaxiu34.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 08:50:52 -0800, Linus Torvalds <torvalds@linux-foundati=
on.org> wrote:

> Ahh. And the reason it works for me is that I don't even have
> "CONFIG_EFI" enabled, much less EFI debugging. So I never trigger the
> buggy code at all.

I foolishly assumed that an EFI machine required CONFIG_EFI...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTuY4LzYtFsjWk68qAQgnDA/9FFlaNp9b+11QQllnJdRe17R5fiO6dn5s
H3Vn/Nyq/CDcqV1r5Wq/c5Sl1OTPhph9Kf/IWsaXPCvKxYQry5Zamc3jf2TdP/RG
EtIYgp7Pp6hk7F27aGKlPJMISqmscWou5LKHZ5Z8E1Xfh3rBjeTWKLVt3c3lmzXM
JOwYSv80KeYow64jWM6tvPJPJmYhsmPbdUH6PVgn6aiqMIK+VpRXTd0oHuEgqqmN
whHrHiGkV00aEffhTuqG/8DaUSy97EnEGxwyGuM2f/zD4dnHy9ECufCla2dgIxBP
HoVhfi4MoOw+qXzgSM58+HQwkmyQEicJJ1INfkXNriRaZuGIDZkkeCUSxX4qJsNb
LdCTEgwhbNhFI/NmKLL3SUS8LD7OfjvzIfq2zO5ge0KNeWgxJXzaXnQKqe/hPlNL
bwq0q0llvbijZClC/7CzqHU6SYAITCVJxJPuKjeQeXJhW1QwEmGHnzKidPMvRu7i
34Cm2JpylZSTxP4gJ66hX584AlQQtp9ePbpECkIks2gHhI8iDJRVBlLupDvS+kbT
5XUM1p08z3/73w5FW6gtIqiczy0wvvSLl/ol2m64s9C57XVRj9CYS7073sMBfgof
qZuBD61n7hEwQ5PBB3UWYhQzHd+shbCPNWqEY3yJOwjw42icguec9+GAwxJpV93Q
424znuTrSUA=
=WnkT
-----END PGP SIGNATURE-----
--=-=-=--
