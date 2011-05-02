Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1EBFGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:06:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37121 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1EBFGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:06:19 -0400
Date: Mon, 2 May 2011 15:06:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the cpufreq tree
Message-Id: <20110502150615.f174d0d7.sfr@canb.auug.org.au>
In-Reply-To: <20110429201241.GA12256@redhat.com>
References: <20110427111024.eb26b6f5.sfr@canb.auug.org.au>
	<20110427013217.GA30804@redhat.com>
	<20110427115427.f5a4fac7.sfr@canb.auug.org.au>
	<20110429201241.GA12256@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_May_2011_15_06_15_+1000_+7_bjr4kSBKftA+6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_May_2011_15_06_15_+1000_+7_bjr4kSBKftA+6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 29 Apr 2011 16:12:42 -0400 Dave Jones <davej@redhat.com> wrote:
>
> I've moved this work onto a separate move-drivers branch. Could you track=
 that in next too please?
> (Apply after fixes & next)
>=20
> I'm hoping this branch will be fairly short-lived, but it depends how qui=
ckly
> other architecture maintainers move their drivers over too.

I have added that new branch starting today.  I called it cpufreq-move.

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

--Signature=_Mon__2_May_2011_15_06_15_+1000_+7_bjr4kSBKftA+6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNvjvHAAoJEDMEi1NhKgbscooH/2lezgHdL/ucbcxg8em8lYUx
ULRPco52fklpwuVw1h9wiuijVTbhfMyBhOZnTbTuX4EE3R97u6joecl7dpfDkeqE
UM56oDcxNG+cjuIveD0oE24wpRNWH+JTuJ0vsansFl1mCP0+QEx2Fw1A1CxH98qi
Y4zLojtn3hyzNFdbfUm+GXBQjFXxSVd0eWT4ch3vg+I+SzIpxwT+TXqal7aNFWdi
N5drJ2byQQwMCFEv/RjeQLPbaX+wBGIQlBmWRq1l1dBcoZSUWcC9ja6VeEzeM5aD
yCvzY0W4wp7STgMKqGXbsLd3SjeB07aTr3ycS/nf0pNFgUHgTgOPaXkKgY4eoLE=
=H6gI
-----END PGP SIGNATURE-----

--Signature=_Mon__2_May_2011_15_06_15_+1000_+7_bjr4kSBKftA+6--
