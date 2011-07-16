Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab1GPEB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 00:01:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35077 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1GPEBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 00:01:25 -0400
Date: Sat, 16 Jul 2011 14:01:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Bonn <jonas@southpole.se>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: arm-soc tree inclusion
Message-Id: <20110716140117.084315e1977e88b9bd6949cf@canb.auug.org.au>
In-Reply-To: <201107071305.02061.arnd@arndb.de>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
	<1309967491.3393.41.camel@jerome>
	<20110707163231.ebc75eef6be02f5490c949d7@canb.auug.org.au>
	<201107071305.02061.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_14_01_17_+1000_NwWoleV.8g23U.i1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_14_01_17_+1000_NwWoleV.8g23U.i1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Thu, 7 Jul 2011 13:05:01 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> Ok, I guess that means you also won't be able to merge the arm-soc tree
> before the merge window, right?
>=20
> I meant to ask you to include the master branch of
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git
>=20
> but we first had to move it into the right location. Can you add
> that when you get back?

I will add this tree in the next linux-next release.

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

--Signature=_Sat__16_Jul_2011_14_01_17_+1000_NwWoleV.8g23U.i1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIQ0NAAoJEDMEi1NhKgbsKvoH/3Df18OUIZG5bOMcMEEpc9KJ
4jSWaDarHCUtf/CPaYcYpzhoe3w81WeDmGvC06XendxukejK0QXOBRMoXK5g9WkC
V11YXT4YkWHuFvsRN333dxIhvWei/4Lj5wdoSf0m1MhYpk0QLu4EAyYSCgyYN8CV
0zxKc2422kiJoqiXN4l2RdJ1gI7625yRMZND0HtWOFCdLXiCsWyyO9aHmllT3Uhs
J1QDLztLbbMVNil8Yrj2tIiYqMezSic+Alnxk0UTerh8atdeXWVardZGw9OE6bKp
5/1obv/OQfddW8jBD+wYjNgvfCgYh88bqT2Ot5JgzI6J6oaoGTxwWNxo7mWwWuo=
=DlmJ
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_14_01_17_+1000_NwWoleV.8g23U.i1--
