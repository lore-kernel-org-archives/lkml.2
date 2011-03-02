Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1CBFy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:54:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46237 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab1CBFy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:54:57 -0500
Date: Wed, 2 Mar 2011 16:54:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joe Perches <joe@perches.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: RFC: Removing old tags, reducing the git size of -next.
Message-Id: <20110302165447.f47fd4b2.sfr@canb.auug.org.au>
In-Reply-To: <1299039746.4208.28.camel@Joe-Laptop>
References: <1299039746.4208.28.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Mar_2011_16_54_47_+1100_2zG=GXfy1khGFtK."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Mar_2011_16_54_47_+1100_2zG=GXfy1khGFtK.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Tue, 01 Mar 2011 20:22:26 -0800 Joe Perches <joe@perches.com> wrote:
>
> I personally do not find git history to be very useful
> for the next tree.  The collected next tree history
> also makes the repository fairly large and unwieldy to
> use on smaller development systems.

Yeah, I have been thinking about this again recently.

> Would it be reasonable to create a separate history tree
> for -next every once in awhile and have say a maximum of
> a few weeks of next history in the current tree?

I could easily have a tree that is historical and contains what the
current linux-next tree contains while also removing old stuff from the
normal linux-next tree (I could push into both each day).  The only
connection between the daily releases is the "history" branch which,
frankly, does not serve any purpose and I will remove.

The main thing stopping me from doing this right now is that there are
several git repositories on master.kernel.org that use the linux-next
tree as an alternate.   They should not be doing this, but it has been
safe up until now since nothing has ever been removed from the linux-next
tree.  If I did the clean up right now, those trees would be severely
broken.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Mar_2011_16_54_47_+1100_2zG=GXfy1khGFtK.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbdunAAoJEDMEi1NhKgbsKZ4H/0UYWgHj7bWUDjUX4XhvOCOW
O/AiNwd21E6gXwOJMzYFKo6I5Uscii4t1E1jpF16P/+lYsMeOMkojnx0anoPlOsW
crYNr8eGcam+NqppbRFlBqCBg/JVry2gHp07EMAcWkUpGrXhpzQuh07U/hCq0nqX
NVHy5k2ZDBQntG2mvlbuqZxqizu5SODO8l/OHvCJOp2YdkDfkKNLR4rEtZf7AXtr
qgyKBqzG+SeWsoQrs0v8hTxg3Pf61e4NrvbR7TbS1PVpiIxJVZztcLQS3McL0Htw
RIcG44IHBIgmXIf6Vu3KxcRD0crIBJ+f5D6Lfc/8oKCflFaBYluZLwygWRyPiDI=
=x5uy
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Mar_2011_16_54_47_+1100_2zG=GXfy1khGFtK.--
