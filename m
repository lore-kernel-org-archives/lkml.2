Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2GUX1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 19:27:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46501 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2GUX1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 19:27:18 -0400
Date: Sun, 22 Jul 2012 09:26:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.5 released
Message-Id: <20120722092659.bdb3a60678eeb3701574ba81@canb.auug.org.au>
In-Reply-To: <CA+55aFwkH4k5vrHZzoSk7aZmKXkieZBh1UogBsH=YZRye0_4fQ@mail.gmail.com>
References: <CA+55aFwkH4k5vrHZzoSk7aZmKXkieZBh1UogBsH=YZRye0_4fQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__22_Jul_2012_09_26_59_+1000_IrIwGhm.m1DDcavF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2012_09_26_59_+1000_IrIwGhm.m1DDcavF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 21 Jul 2012 15:16:00 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> And as usual, this obviously means that the merge window for 3.6 is
> open, although I hope people will spend a little bit of time testing
> and beating on 3.5 before pushing on with the merge window.

Well, you could force the issue by reserving the first couple of days of
the merge window for bug fixes only ... that may cover the first flush
of "Linus has done a release, let check it out" bugs and get those fixes
much closer (bisection-wise) to their causes.  Just an idea.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__22_Jul_2012_09_26_59_+1000_IrIwGhm.m1DDcavF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCzrDAAoJEECxmPOUX5FEwroP/iop3L0hdAwaHcvB6T9WyEwk
mAWfmLO9cS1zNlpi+mkNkINDa3MZsIS/KUPX5M03YCshconMxEQfGnINXPAFfWOA
cOm/HA4UkPksfHpb3lLjbw57a76xwivOlPbZpJXgS37p04JB1w2O6z9fKDtgUVyo
vqOnN2kXOHUbnaoDieK2RvSFX4jJj3vCCYceLolEPRPrQDa+TBjnH8hUKChrIbTT
IzP+4PNLlPrSev7pJF7p6+hms/YkCqfuVueJ/AHAwAh1oxbkIct0OKT00sga5Kff
rC/1mViVgGqLz2YrMwYe0BamZgEl+0XRuQZ0HdEOyhNnUAqko77klTaK3g0JIvxX
KM9tBA6JbiBbVCFypsSFuZu5vTGoWO5w9HniQtoIl5BmDuwF6zxyNS6wBW4Ibx9S
B/L1na39H4/parC4MOTUrCsB8dsvv9lu3ljwqo6vD3lj88Mb/BcaKRaTCM900B93
VDMNAtW8B+yZri7hICC2hWLxQryoq49TLB8u7816MVE/P/CSi+FEs59ATEu6kHQG
8ArxjpmgHSgJKCQiKBxYgMemWFPTvR9msVygw6ivgmsjZs7Afqq6CNq6wQ6rKBY+
+eJWeg3jcCu5+88OCGEdEtUYZPQ0tdFcIye3Qy/ucgoGCqCrg5DUCy3oa/4fd+7w
QRWmucTgtRbaECVDqVYt
=0mv1
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2012_09_26_59_+1000_IrIwGhm.m1DDcavF--
