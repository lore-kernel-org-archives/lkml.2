Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab2JaLxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:53:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36668 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2JaLxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:53:16 -0400
Date: Wed, 31 Oct 2012 22:53:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        kvm-devel <kvm@vger.kernel.org>
Subject: Re: Linux-next changes for module and virtio trees.
Message-Id: <20121031225304.5a1f3885dcb1cae725f77a81@canb.auug.org.au>
In-Reply-To: <87pq3z5nhs.fsf@rustcorp.com.au>
References: <871uhh4cen.fsf@rustcorp.com.au>
	<20121003011239.3445171ec17e422a289d2997@canb.auug.org.au>
	<87pq3z5nhs.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__31_Oct_2012_22_53_04_+1100_h=LAw3Q5AxjsGdIf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Oct_2012_22_53_04_+1100_h=LAw3Q5AxjsGdIf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Wed, 31 Oct 2012 13:58:15 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> >
> > On Tue, 02 Oct 2012 15:56:56 +0930 Rusty Russell <rusty@rustcorp.com.au=
> wrote:
> >>
> >>         Please remove my quilt tree
> >> http://ozlabs.org/~rusty/kernel/rr-latest/ from linux-next, and use my
> >> git trees from now on:
> >>=20
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git
> >> Branches:
> >>         modules-next
> >>         virtio-next
> >
> > Done.
>=20
> And please add my 'fixes' branch from the same tree.

Done.

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

--Signature=_Wed__31_Oct_2012_22_53_04_+1100_h=LAw3Q5AxjsGdIf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkREgAAoJEECxmPOUX5FEOWwP/00/8OX7xHd8xHVgWMQU0cXm
2WfLo+hT5wGyFNOPRemfOSrd407mRmP8SlMdcH/PrvNlBRHYlC+p0OyNyBBTvc8y
1Inn6FKDMkp6sYcyEtfeIuiga+FuzY/kBtWm6VO1mQedSslJbh96WgJkustC5dz+
lpHYrX6pnFWJtt4lg3Sng8hewcHrhutW6OtidIagZ8UN+pK21qT0jLIk/DW23ffK
7PltalQUzB4F/2RUGLzy8q+HN+CpWeGxXBMLak0Q7au2ZnqUzE7PRajYqpMQcHhO
vLPv6PjBvah0euR+D0h7cf0hhX8ba0wv16beANHF39QinDrWDLCxnm1uMuYFyfqi
/8lAYd/SXh29Nh6lDaVaicZ5wajG1R2haDLmkmmrZD5cPMmQGdY7po6n/MOC9gkj
jiFc0Qyg3agc9M3pDLYY4nMqE6L8mqP+a7T0s4zo/IpklAqOrBF7+0K71hAKojq6
06i3EdUpZ4kgi3YxJQNngspiMFLS6INKSqllFef4klqoJz6DYT0bAJxFDFs1I9m6
aguJkP/wFTVLKmjed2y+eowKA4MuN25q/BvygL0W+Gdb3OpftzbzFNkGr1uqMxMy
hINOLWVcBBR57hFWB4g1sfLMAkQFGMh+O8AP7PJjIYItgzY0TXGsIDhJ6PQ6wAe3
G3rRVHHzuOjfURdWirMi
=n8gR
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Oct_2012_22_53_04_+1100_h=LAw3Q5AxjsGdIf--
