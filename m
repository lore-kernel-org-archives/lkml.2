Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0DLXq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:46:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34187 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab0DLXqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:46:25 -0400
Date: Tue, 13 Apr 2010 09:46:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Next <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: A few tree inclusion update requests
Message-Id: <20100413094618.76ac20a8.sfr@canb.auug.org.au>
In-Reply-To: <20100410134221.GC5204@nowhere>
References: <20100410134221.GC5204@nowhere>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Apr_2010_09_46_18_+1000_WFlh5uhfpE=jns12"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Apr_2010_09_46_18_+1000_WFlh5uhfpE=jns12
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Sat, 10 Apr 2010 15:42:23 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> I have some requests for you about tree inclusions for linux-next.
>=20
> My reiserfs/kill-bkl branch had no updates for a next release
> for some time now. You can safely remove it from -next. If
> I get updates for it later, I'll tell you. But for now it's
> only here to host fixes for the current release.

There is some value to having "fixes for the current release" trees in
linux-next - it means that while such fixes are waiting for Linus to
merge them, people testing linux-next don't have to worry about bugs that
already have fixes pending.  However, I have removed that tree - I will
put it back if you ask me to.

> Also I have two new branches aimed for .35
>=20
> Could you please integrate the two following?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	bkl/core
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	bkl/procfs

Both added from today.

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

--Signature=_Tue__13_Apr_2010_09_46_18_+1000_WFlh5uhfpE=jns12
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvDsMoACgkQjjKRsyhoI8xHigCdHFccN2bTDkvrmM610suD86xl
sa4An0YViXfQN+1qutsfa7m/fZ1gbuEF
=MIKf
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Apr_2010_09_46_18_+1000_WFlh5uhfpE=jns12--
