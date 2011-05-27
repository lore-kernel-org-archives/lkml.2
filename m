Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab1E0BO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:14:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37592 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1E0BO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:14:56 -0400
Date: Fri, 27 May 2011 11:14:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [git pull] gpio changes for $NEXT_KERNEL
Message-Id: <20110527111449.c3255407.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTi=S2quduA7-8Emqw7vE0J1eto6bgA@mail.gmail.com>
References: <BANLkTi=S2quduA7-8Emqw7vE0J1eto6bgA@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_May_2011_11_14_49_+1000_yV75yB2o3VegHMUs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_May_2011_11_14_49_+1000_yV75yB2o3VegHMUs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 26 May 2011 12:12:02 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> Due to my own stupidity, this branch as /not/ been tested through
> linux-next.  I put it in a branch that I negelcted to ask Stephen to
> include.  :-(  I'm asking him to add it for tonight.  At the very
> least, it has been build tested on various x86, powerpc, mips, sparc
> and arm defconfigs.
>=20
> You'll probably want to hold off on actually pulling this one, but I
> wanted to give you a heads up that I have it still pending.  If you've
> not picked it up, then I can resend the pull req tomorrow afternoon
> after confirming it hasn't messed up anything in linux-next.
>=20
> There's nothing earth shattering here.  Just a bunch of driver updates
> and some faltering steps towards unifying a bunch of the mmio gpio
> logic.
>=20
> g.
>=20
> The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7db=
b5:
>=20
>   tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)
>=20
> are available in the git repository at:
>   git://git.secretlab.ca/git/linux-2.6 gpio/next

I have added this tree even though it looks like Linus took it - just in
case there is more stuff.

If you think it is unnecessary, let me know.

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

--Signature=_Fri__27_May_2011_11_14_49_+1000_yV75yB2o3VegHMUs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3vsJAAoJEDMEi1NhKgbsqccH/24ZvnD+Abb0pff/IhsVC0EP
gchT9f9DJTbZ1FyV8UTPpmdnJcvOh+l9Rv316+uQOOBM/EzCCIrVYtm7Gn/1j85o
N6rBHESW0hArXCA/DEjLvrBovgdOOH7TWPkHsata8Dpzuj8tbpT63HJ6dJmUsxn3
VMke92ZxySvOg5iojl9PlH+yG4+qIOaVnSE2rFdOzJKnkXLyeCBhGC/qEpeEeVCN
x2juSe+xVme2pH89/SkAUhf5pByaVOJCpTs2Lb9y1yJYNuIlBfYeD5ve5CZ89cMX
VhDQK/Pt2MuVhKhqMIkJsLDXYj4akD/3dLOh2kTpDIpaUYjbFLPGH3Y6MRlKFZM=
=uzNB
-----END PGP SIGNATURE-----

--Signature=_Fri__27_May_2011_11_14_49_+1000_yV75yB2o3VegHMUs--
