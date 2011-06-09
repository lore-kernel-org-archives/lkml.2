Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1FIBQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:16:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51026 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1FIBQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:16:19 -0400
Date: Thu, 9 Jun 2011 11:16:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sedat.dilek@gmail.com
Subject: Re: [PATCH 00/15] writeback fixes and cleanups for 3.0 (v5)
Message-Id: <20110609111609.45848768.sfr@canb.auug.org.au>
In-Reply-To: <20110608134510.GA10273@localhost>
References: <20110607213236.634026193@intel.com>
	<20110607160441.db475211.akpm@linux-foundation.org>
	<20110608020102.GA29239@localhost>
	<20110608134510.GA10273@localhost>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Jun_2011_11_16_09_+1000_Yo7ZUi3wVK+QsYcg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jun_2011_11_16_09_+1000_Yo7ZUi3wVK+QsYcg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 8 Jun 2011 21:45:10 +0800 Wu Fengguang <fengguang.wu@intel.com> wro=
te:
>
> > git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git#fs-writ=
eback
>=20
> Will you include this branch instead? It looks more reasonable as
> suggested by Sedat:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git  next

I have added that tree starting today with just you as the contact
(please let me know if others should be added as contacts as well).

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

--Signature=_Thu__9_Jun_2011_11_16_09_+1000_Yo7ZUi3wVK+QsYcg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8B7ZAAoJEDMEi1NhKgbsoC0H/0TWANrsu6NqCtB5ETG1w4Bs
S9f1xkoU8dw4l78OqRbWPMtDeYA7B5YPrYesCEIADKur/ujVoyHCl8FJMdrL4U1y
g5rduBaYHqhypdk7sJVxgf+gaUqu3nl/tE8emYSUcEuh6j0yz6/uhNZWv6mt8/Y9
8KAFLmALIy/VkxM8XmbBqEFpWpAMfukiWFetbHc8GctG8uNj8KnTtU8vNh8r7yqw
EAW/NoAxk9ZcUou7KFjZPTqHbRi1K+FhREzVwJuVMNglUzTl2Du/LqI57a71RrqS
2s6A5YVv3Ts0Wkm6PaRqcnDLdwUs+27f28kdCQx0V9ilYLBVFyZ4ub8lwT8BRPQ=
=4urk
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jun_2011_11_16_09_+1000_Yo7ZUi3wVK+QsYcg--
