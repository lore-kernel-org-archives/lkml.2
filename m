Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0GWBKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:10:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50627 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab0GWBKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:10:24 -0400
Date: Fri, 23 Jul 2010 11:10:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: New branches for linux-next
Message-Id: <20100723111018.f250c0f5.sfr@canb.auug.org.au>
In-Reply-To: <4C48D9C8.3090701@goop.org>
References: <4C48D9C8.3090701@goop.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_11_10_18_+1000_2jUSn7mR7S.MF0wb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_11_10_18_+1000_2jUSn7mR7S.MF0wb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Thu, 22 Jul 2010 16:52:40 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
> Could you add:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
>     upstream/xen

Added starting today.  I put just you as the contact - I can add more
people/lists if you like.

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

--Signature=_Fri__23_Jul_2010_11_10_18_+1000_2jUSn7mR7S.MF0wb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSOv6AAoJEDMEi1NhKgbsZ2EH/11bhTEFe+ZbikLcooqS2zmf
Fmgv0XppQc4ylLQGX7ptioP2F8jSHAms9qe+moR4HU0vBx8AtaAaaVXSI/8SOVKu
yHoPupkN6XF6QLvC301mYwMrpKYMdh5tKDnCsfiR5IaN7TEi2M+FpiZdn8wbJPbO
jPqhfZ+VwVUdzXdtadFN5TOX3h54k+IoleH74LMCjdAEFrtRTu3qVDuUB2IIaSjA
wDnpaz4Q/v8TT8e8isSZ2KGa0Lfq9AiVElXGtUJssroCIWFHWkm0T/BUODt+M4Ow
OI6fmpy7MIC2PJkVdtJubSgp5rL4QZ6hSW2VcPxGcSoLSJqr98mwSoC+ndasvqI=
=t/DU
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_11_10_18_+1000_2jUSn7mR7S.MF0wb--
