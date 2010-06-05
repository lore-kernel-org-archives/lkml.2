Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab0FEMHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 08:07:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34066 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033Ab0FEMHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 08:07:41 -0400
Date: Sat, 5 Jun 2010 22:07:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, albert_herranz@yahoo.es,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       jeremy@goop.org, iommu@lists.linux-foundation.org,
       linux@arm.linux.org.uk, dwmw2@infradead.org, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH] swiotlb-0.8.2^H3: seperation of physical/virtual
 address translation and core memory allocation.
Message-Id: <20100605220727.4138e85f.sfr@canb.auug.org.au>
In-Reply-To: <20100604200604.GA17645@phenom.dumpdata.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
	<20100604114250.b28f288a.akpm@linux-foundation.org>
	<20100604200604.GA17645@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Jun_2010_22_07_27_+1000_kRzbT+CjTYhwtap8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Jun_2010_22_07_27_+1000_kRzbT+CjTYhwtap8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Fri, 4 Jun 2010 16:06:04 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> I was wondering if you wouldn't mind including the following git tree
> in your linux-next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git
>=20
> The patches are in the MAIN branch (and also in swiotlb-0.8.3).

OK, I have added the master branch of that tree.  It will appear in
linux-next from Monday.

> They have the Tested-by, Signed-off-by, and Acked-by signatures.

Could you move the Signed-off-by etc lines to the bottom of the commit
message if that first commit, please?

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

--Signature=_Sat__5_Jun_2010_22_07_27_+1000_kRzbT+CjTYhwtap8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwKPf8ACgkQjjKRsyhoI8wbfQCfRSCMdnocpPSjUPB6varhpc6A
1jIAn0lj6jwIulITj/k0UsA/kdSneMo8
=MCF1
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Jun_2010_22_07_27_+1000_kRzbT+CjTYhwtap8--
