Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1G2BVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:21:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42748 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab1G2BVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:21:07 -0400
Date: Fri, 29 Jul 2011 11:20:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
Message-Id: <20110729112054.eaf20e1875990b05e9545d81@canb.auug.org.au>
In-Reply-To: <20110728154229.GA19589@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
	<20110728071556.GA6497@elte.hu>
	<20110728154229.GA19589@windriver.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jul_2011_11_20_54_+1000_6rS6/wEpV7B6inwo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jul_2011_11_20_54_+1000_6rS6/wEpV7B6inwo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 28 Jul 2011 11:42:29 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> [Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 28/07=
/2011 (Thu 09:15) Ingo Molnar wrote:
>=20
> > * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >=20
> > > I don't think there really is any rocket science or contentious=20
> > > stuff here. It is a sensible cleanup that adds organization and=20
> > > speeds up compiles. The RFC I'm hoping for is more about how/when=20
> > > we want to get this in tree.
> >=20
> > I'd suggest to stick it into linux-next ASAP, leave there for a few=20
> > days and after fixing any potential fallout send it Linuswards.
>=20
> Hi Stephen,
>=20
> Would you please add this to linux-next?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git#module.h-sp=
lit

OK, I will add it today.

> It won't need to be there forever, just long enough to shake loose
> anyone who has implicitly been using module.h without asking for it.

Please remind me to remove it again after you are finished with it.
There is no real hurry about that as once Linus' merges it, it has very
little effect on my process (assuming that you get him to merge the
actual commits that are in my tree - hint, hint :-)).

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

--Signature=_Fri__29_Jul_2011_11_20_54_+1000_6rS6/wEpV7B6inwo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMgr2AAoJEDMEi1NhKgbs5R0IAJb3Qw9qopzokZuGvERhIXcM
c5qzTzAphIsC/ciLkeB64gqHmfO3pdo6a6xLQEfyC0OZoNhEeiyhXNNhN/8yEZt8
hRuBTmOFd5FhUF9i4LEZh/MpvohAcEL6QgSMcv0pgZVcILS7Ah2LGwTwsu3Oxte+
tSUs539Utf129p2DFbYMsIRis+G+ZkfdIDkdGgTGHv9vblnAX9QpJvRf7q02rruj
3COdl7sOlSx2VYKL5Q3l4HqSZW9SBpMSaMUmfWS/79bKVMW0wfxNF3dbu/590ana
MWTb9rKoIiwPRjtGGtY8XGrsWLgegW0D+c5FdOWTUezHH4rF1giIopg8asPYuLE=
=2v3R
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jul_2011_11_20_54_+1000_6rS6/wEpV7B6inwo--
