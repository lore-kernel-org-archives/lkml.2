Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0D0FKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:10:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60029 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0D0FKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:10:40 -0400
Date: Tue, 27 Apr 2010 15:10:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Next <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: A few tree inclusion update requests
Message-Id: <20100427151035.c727c9e5.sfr@canb.auug.org.au>
In-Reply-To: <20100427025530.GE5695@nowhere>
References: <20100410134221.GC5204@nowhere>
	<20100413094618.76ac20a8.sfr@canb.auug.org.au>
	<20100427025530.GE5695@nowhere>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_15_10_35_+1000_IAw+bK=gSDfag3vj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_15_10_35_+1000_IAw+bK=gSDfag3vj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Tue, 27 Apr 2010 04:55:32 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> Could you please integrate the following new tree in linux-next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	bkl/ioctl

Added from today.

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

--Signature=_Tue__27_Apr_2010_15_10_35_+1000_IAw+bK=gSDfag3vj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWccsACgkQjjKRsyhoI8zNhwCfbRawDnoyQ56GIS/MIoP06RuI
/vAAniQG5n2sNPTOJ/iA0J8NhQjllMKP
=IK0s
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_15_10_35_+1000_IAw+bK=gSDfag3vj--
