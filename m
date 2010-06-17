Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab0FQXJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:09:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38659 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab0FQXJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:09:10 -0400
Date: Fri, 18 Jun 2010 09:08:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Erik Gilling <konkers@android.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
       Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [GIT PULL linux-next] tegra
Message-Id: <20100618090857.057e0a7a.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikXH_UtE95ZGHp5AAm5IRD6dN8cnrNK9A3-MRwY@mail.gmail.com>
References: <AANLkTikXH_UtE95ZGHp5AAm5IRD6dN8cnrNK9A3-MRwY@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Jun_2010_09_08_57_+1000_q7bRba6C7fkj+HVS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jun_2010_09_08_57_+1000_q7bRba6C7fkj+HVS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 17 Jun 2010 15:38:19 -0700 Erik Gilling <konkers@android.com> wrote:
>
> Can you please pull the following into linux-next?
>=20
> git://android.git.kernel.org/kernel/tegra.git for-next
>=20
> This tree adds support for the Nvidia Tegra ARM SOCs.  It's received
> review on linux-arm-kernel.

Added from today.  Should the contact be just you or should I add others
as well.

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

--Signature=_Fri__18_Jun_2010_09_08_57_+1000_q7bRba6C7fkj+HVS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwaqwkACgkQjjKRsyhoI8ygygCcDEHB5CpYn61pjABIVsmdB+ha
esAAnjkfBKhJ3AGaVjXkEwZOaR/j7XRH
=ozcT
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jun_2010_09_08_57_+1000_q7bRba6C7fkj+HVS--
