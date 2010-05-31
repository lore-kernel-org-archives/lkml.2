Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0EaQE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:04:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50232 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab0EaQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:04:26 -0400
Date: Tue, 1 Jun 2010 02:04:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [NEXT] add x86 platform driver tree
Message-Id: <20100601020418.e1853324.sfr@canb.auug.org.au>
In-Reply-To: <20100531150450.GB19134@srcf.ucam.org>
References: <20100531150450.GB19134@srcf.ucam.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jun_2010_02_04_18_+1000_logAsG.Tmc94WEfp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jun_2010_02_04_18_+1000_logAsG.Tmc94WEfp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

On Mon, 31 May 2010 16:04:50 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wr=
ote:
>
> Could you please add=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.=
git=20
> linux-next to the -next tree? This consists of x86-specific platform=20
> drivers and is relatively quiet.

I will add it from (later) today.

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

--Signature=_Tue__1_Jun_2010_02_04_18_+1000_logAsG.Tmc94WEfp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwD3gIACgkQjjKRsyhoI8yVzQCdEJ37e+kxSu3IAO3yxisMyMwq
SocAoKfTaaY046Gw1uWmKxsHj/RlBLoA
=6ASq
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jun_2010_02_04_18_+1000_logAsG.Tmc94WEfp--
