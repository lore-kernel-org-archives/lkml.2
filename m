Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2FRWha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:37:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35003 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2FRWh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:37:28 -0400
Date: Tue, 19 Jun 2012 08:37:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>
Subject: Re: linux-next: Tree for Jun 18 (kmsg problems)
Message-Id: <20120619083720.996b2d743cff619a58e1de97@canb.auug.org.au>
In-Reply-To: <20120618221535.GA13037@kroah.com>
References: <20120618165336.48345227c6b64c314326ae57@canb.auug.org.au>
	<4FDF61A7.3050601@xenotime.net>
	<20120619080109.b28055c1b32fb81027a9562b@canb.auug.org.au>
	<20120618221535.GA13037@kroah.com>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_08_37_20_+1000_EvTYklEFPTibH6OS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_08_37_20_+1000_EvTYklEFPTibH6OS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 18 Jun 2012 15:15:35 -0700 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> > Caused by commit e2ae715d66bf ("kmsg - kmsg_dump() use iterator to
> > receive log buffer content") from the driver-core.current tree.
>=20
> I'm building my tree right now, and I can't seem to hit this.

You need CONFIG_PRINTK turned off ...

> > This was reported a few days ago.  Why is it not fixed yet?
>=20
> It was reported Friday evening, on a holiday weekend for some of us, we
> are trying the best we can :)

Ah ha, another of those pesky holiday things :-)

> > Especially since it is in a branch that is supposedly "bug fixes"?
>=20
> It fixes up a reported problem, and we had 3 people test it and said it
> resolved the issue for them, no build problems reported.

My usual mantra is that if your patch is modifying code that clearly
depends on a CONFIG option, you must test with that option both on and
off. I see build problems in linux-next all the time where this has not
been done.  :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Jun_2012_08_37_20_+1000_EvTYklEFPTibH6OS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP362gAAoJEECxmPOUX5FEhZUP/1nE5c2zYwXlz/rQAR0SmSYr
Jm7y+xRx51oTcfP+nS0EKt1/IWk2cZ12jHsv86c5SmP4CPICWSWtXv6Gz/b7xEkd
GrAnbvtWHP2JW0ndU555RxS3mEkcC75piahZtFfc3OdDaKQrkO6LT3Ct8bLYx6Kj
YFWufQ1Uk9nskLt823FRvsQzcoEIXdF8olFmPbGskTeg8osQ3eo8dAamIwPX8tNd
51yFJtOnync1y/qFlvD/F0PIGxPg47iIyGTSK0IleTsdLl2izbSzVsoX9pSWbBXL
lHyR9Amfj7JQbGLAMQwbbHOFqFpIjUi1yAMt8Q434RSqSdbfj0nIHLgWvwDvOWs5
OI9whRtqH1XFPiB4e3jGG/3OWGo1fUd9gCoqRpMmf0rVJBIGZZCyjj8G/rTXDugR
iOF6ceA5zSYTtmSg1BdzDL8jg7x6X4l5UXZNeactlirIQcXr48ciZQumF7Qsyywi
C/qenyAVFM7z11ihOqknLEupLyWb+AUGRY69eqlsj58TQT7ubhOfnFIIK5LdkD28
LKPum3DVBmyQ8W1IakkNGiGdzfvjK7oolXPpaV098xtuO6cMNpW8JiAOLMeUCWf+
f7/EI4GiMin6W8pdT9IX/x1mlBH/dvuSL2tPLnUiZLZUOOuxXG9O+gFeQxAVkddw
TVenshmzlNMNpkdgTSlf
=PQrg
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_08_37_20_+1000_EvTYklEFPTibH6OS--
