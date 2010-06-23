Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0FWXwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:52:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41920 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0FWXwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:52:41 -0400
Date: Thu, 24 Jun 2010 09:52:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
       linux-kernel@vger.kernel.org, ben-linux@fluff.org
Subject: Re: [GIT PULL linux-next] Samsung S5P SoCs
Message-Id: <20100624095233.d2daaa4f.sfr@canb.auug.org.au>
In-Reply-To: <000d01cb126e$fa193690$ee4ba3b0$%kim@samsung.com>
References: <000d01cb126e$fa193690$ee4ba3b0$%kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Jun_2010_09_52_33_+1000_xsbR0yD7eceO01Mc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jun_2010_09_52_33_+1000_xsbR0yD7eceO01Mc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 23 Jun 2010 09:56:52 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> Could you please pull the following into linux-next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git#for=
-ne
> xt
>=20
> This tree is for next- Samsung S5P SoCs such as S5P6440, S5P6442, S5PC100,
> and S5PV210/S5PC110.

I have added this from today.  I have called the tree s5p.  Currently you
alone are the contact for problems to do with this tree - should I add
anyone else (or a mailing list)?

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

--Signature=_Thu__24_Jun_2010_09_52_33_+1000_xsbR0yD7eceO01Mc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwinkEACgkQjjKRsyhoI8zjzwCfWAbQvAWYLYUSfNB6YKyfFRtp
qvgAoKSBFie65bCbdU8N1SfJu1lBXjs+
=Naif
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jun_2010_09_52_33_+1000_xsbR0yD7eceO01Mc--
