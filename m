Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0D0DTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:19:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab0D0DTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:19:40 -0400
Date: Tue, 27 Apr 2010 13:19:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can you include a new git tree in linux-next, the staging-next
 tree?
Message-Id: <20100427131935.9d48a17b.sfr@canb.auug.org.au>
In-Reply-To: <20100427000104.GA31358@kroah.com>
References: <20100427000104.GA31358@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_13_19_35_+1000_AQ7dPr.sCW1CCgNP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_13_19_35_+1000_AQ7dPr.sCW1CCgNP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 26 Apr 2010 17:01:04 -0700 Greg KH <greg@kroah.com> wrote:
>
> Welcome back from your break :)

Thanks - I was nice and refreshed until about 9am this morning :-)

> Could you include a new git tree in linux-next, the staging-next tree
> at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>=20
> the branch is "staging-next" to pull from.

OK, I will add it at the end today.  I assume that this will be based off
Linus' tree?

> I'm trying to do the -next work for staging in a git tree to keep my
> development quilt trees smaller, and make it a bit easier for others to
> work off of if they want to.

Should I drop the "staging" quilt tree?

> If I've messed anything up, please let me know.

You'll hear the screams :-)

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

--Signature=_Tue__27_Apr_2010_13_19_35_+1000_AQ7dPr.sCW1CCgNP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWV8cACgkQjjKRsyhoI8wu7ACfZZa48GvAAaxVw5ZXR4xKSKN3
D+8AnA9aQnlmJzrgJXFA7FLbQ8YwfLQ6
=Y9NW
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_13_19_35_+1000_AQ7dPr.sCW1CCgNP--
