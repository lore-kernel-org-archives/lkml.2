Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2ALWrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:47:22 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50008 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab2ALWrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:47:21 -0500
Date: Fri, 13 Jan 2012 09:47:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Change the oss.oracle.com/git/tmem.git to
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git
Message-Id: <20120113094711.8365f1fcd9a92ffd3902e287@canb.auug.org.au>
In-Reply-To: <d0dc4841-cf58-40a4-8ba2-6919b9587cb5@default>
References: <20120112191554.GA19862@phenom.dumpdata.com>
	<d0dc4841-cf58-40a4-8ba2-6919b9587cb5@default>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Jan_2012_09_47_11_+1100_V26Z1puu2_hqH1m5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Jan_2012_09_47_11_+1100_V26Z1puu2_hqH1m5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

On Thu, 12 Jan 2012 11:20:07 -0800 (PST) Dan Magenheimer <dan.magenheimer@o=
racle.com> wrote:
>
> > From: Konrad Rzeszutek Wilk
> >=20
> > I am taking the role of maintaining the cleancache and working
> > on making the frontswap patches acceptable for the upstream tree.
> >=20
> > As this is merge window season, I've made the #linux-next branch be emp=
ty,
> > but once the v3.3-rc1 branch is tagged I will start cracking on the pat=
ches.
> >=20
> > CC-ing Dan here so he can add his SOB to this.
> >=20
> > Please substitute the git://oss.oracle.com/djm/tmem.git tree
> > with git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git
> >=20
> > The branch to pull from is called #linux-next.
>=20
> Confirmed.

OK, I have switched to that today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__13_Jan_2012_09_47_11_+1100_V26Z1puu2_hqH1m5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPD2LvAAoJEECxmPOUX5FEe7gQAJ00haBRQrNqEJASN2hiOYaH
xibRiv+zt0aLj2V90oYrnoQqhPalYk9tuQqIzOT9CWqBJGfSngPB47GwUlhrsQs8
ApycHsJN/dJJRNIWYM3qVCBCLTLEXa4aLTWgzpUkXArvT7rHns9K9m+pPpW+h33e
bB7o54Oi0xayLFydl7f/SXseYV8AyE2qlakII7fCPVmaRGoIGQj2J6/5soucMLUO
9B+P8T4o78ZFbgwWtb7dJkOGvhP7BvYk2aPUHojm71conUtR70bIJFkbNbIrID5d
JdWjxASP73G1hAocd0SiTuDoabhshZIYNUsAWaQfsDyq5ysq8eUWBhOnk0Cj1U7v
DsebG1RYNqNoTovWXKHnFAo9GPmOpt1Ki7o8xQGDkm44laWtLQjq98dfjkfoF8C2
9lbfuIRk+eroyzgY4TCbqabxC+Rqh3U0SDS0Wx6h7tiASX7jk/ZBNfHOOVsY7Rkw
ircCIRP+HXANRPPWSPPnP6nKo5fiD5zdWje1YA0cfoQsOZtqOf3sUWfkUTJD9G6/
PbmelyeWUA/DExQCe/1rjdUMh/St7qDzhDZt1Z0nokyiLatb+32MyovJKxVZ3JZ5
y08goj5r4h6mL/Ms9qkjoAh2NhHTvm1HuT0h/DH3bTAeE4wzdo7iUYPPTGtK336A
9W00JeTyvh3wNd9RzSVj
=17I3
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Jan_2012_09_47_11_+1100_V26Z1puu2_hqH1m5--
