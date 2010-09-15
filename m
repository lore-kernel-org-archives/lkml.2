Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0IOJka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:40:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42294 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0IOJk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:40:29 -0400
Date: Wed, 15 Sep 2010 19:40:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        Jan Blunck <jblunck@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [NEXT] Remove the BKL from file systems
Message-Id: <20100915194021.edd9caea.sfr@canb.auug.org.au>
In-Reply-To: <201009142314.49625.arnd@arndb.de>
References: <201009142314.49625.arnd@arndb.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Sep_2010_19_40_21_+1000_J_1=+pn=KthIfU2g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Sep_2010_19_40_21_+1000_J_1=+pn=KthIfU2g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, 14 Sep 2010 23:14:49 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> Stephen, please add this to next:
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git vfs

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

--Signature=_Wed__15_Sep_2010_19_40_21_+1000_J_1=+pn=KthIfU2g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkJSFAAoJEDMEi1NhKgbsaBcIAI2mVs5MA4e9yrd7dxMfYybU
svpI9Taak1DqzO1OfEfiHKE/hDtFupqWVJgH0l8vT0hEkGp9vrJ/eE7euA7INCUu
js96lH1/uS5Doo7tTw0711CfI7rhEYM9WofyY+EJG3NQXL0DbQSdKcSyWFRgr+Q0
Z/eZPsHSCCR6KAhxasV9a4C4EISNPFM+LwpBbw5nRvcTmId3KqRrbtXCNbNiezmu
Y7PJ8x361liew96lhByCQMUziPaAiTQ71e6OPQ/MAurunegacvwvH5EKg/rndVCA
O5XPF7wzke8NIGaLbl+T1fngt53533PwXZQwklgKQwMAMwrYJdPBlftcZFIOT7Y=
=hDHm
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Sep_2010_19_40_21_+1000_J_1=+pn=KthIfU2g--
