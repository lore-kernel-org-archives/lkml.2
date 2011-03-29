Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1C2XMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:12:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36301 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1C2XMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:12:13 -0400
Date: Wed, 30 Mar 2011 10:12:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-next@vger.kernel.org
Subject: Re: ptrace pull request for linux-next
Message-Id: <20110330101204.7a5459c3.sfr@canb.auug.org.au>
In-Reply-To: <20110329090248.GJ6736@htj.dyndns.org>
References: <20110329090248.GJ6736@htj.dyndns.org>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Mar_2011_10_12_04_+1100_q.pu3QgOC+cdrFl="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Mar_2011_10_12_04_+1100_q.pu3QgOC+cdrFl=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 29 Mar 2011 11:02:48 +0200 Tejun Heo <tj@kernel.org> wrote:
>
> Can you please pull from the following tree into linux-next?
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace
>=20
> The tree hosts ongoing ptrace/group stop improvements.  Oleg is in the
> process of getting a korg account and setting up a dedicated tree and
> it has been agreed that I maintain a temporary tree to be tested in
> linux-next until things are properly setup.  The branch is stable and
> will be pulled verbatim into Oleg's tree once it's up and running.

This will be added from today (I was waiting for -rc1).  I have put you
and Oleg as contacts for this tree.

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

--Signature=_Wed__30_Mar_2011_10_12_04_+1100_q.pu3QgOC+cdrFl=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkmdEAAoJEDMEi1NhKgbs4AEIAJchpI5Jkf2gHqdRy2ZdkKXA
+u6cDv3NZNrWcr33MyJcwoObqUfJn3e+YGV8469s/x6aSNlVpuJGbEvbPgsL/sFH
fSVqISjIqETMVVFvKOInHevZKWCr6QOn8KtjSOXieFQQjofL6ZVn43SIUKGP7u8B
xUE3sH8j4M/EZ5ltgs26g3Tx47kgibwj5iQvjtIZ+44tkrApzj2smjYFABz9IIwZ
2FVzvh5Xn7SjnczLHaKcC59B4YHLjvJlCOCrh5jJW1Yx2Lyim3BXav3+mOc8lcmH
xiee00VYFO1kxLXmrGRoG5swFf2LVvdYlyeGP2PyK//k1nFedceRfMdxPftaTl8=
=I/NK
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Mar_2011_10_12_04_+1100_q.pu3QgOC+cdrFl=--
