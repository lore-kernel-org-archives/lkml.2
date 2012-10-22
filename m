Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2JVVIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:08:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37913 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2JVVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:08:04 -0400
Date: Tue, 23 Oct 2012 08:07:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kees Cook <keescook@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Tree for linux-next
Message-Id: <20121023080753.bc1fc8b0982d72594653ca69@canb.auug.org.au>
In-Reply-To: <CAGXu5j+D+pFort3RPLnXsrX5MB6sn1NYnkbx6=nj3NgRkpRirQ@mail.gmail.com>
References: <CAGXu5j+D+pFort3RPLnXsrX5MB6sn1NYnkbx6=nj3NgRkpRirQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Oct_2012_08_07_53_+1100_7oDEXA62s./aNV2Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Oct_2012_08_07_53_+1100_7oDEXA62s./aNV2Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kees,

On Mon, 22 Oct 2012 08:44:26 -0700 Kees Cook <keescook@google.com> wrote:
>
> Now that we're past rc1, can you please add my tree to your linux-next pu=
lls?
>=20
> drop-experimental  git
> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git#linux-next

Thanks for the reminder.  It will be included from today.

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

--Signature=_Tue__23_Oct_2012_08_07_53_+1100_7oDEXA62s./aNV2Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhbWpAAoJEECxmPOUX5FEPToP/jPW00UYmpVNorVKCW1kPBdg
mH+nGyS8TPALDEUnE2Z6wxXrX2NrsaNvCE6DflirZXX45phHQ79AGVbjH+z6xZfR
NoDtO33PvlAOyR996swLL6g9Soh0jePA4W1NSwA7tG6H596LONKJ0m7CR9Vp2xx3
sxu3YzFuaSHR0Bd8Wtw2YcaDbJP2fOgaqU57+1nCUovopjvKLczmDj9129mwqB2y
9TBwZLPURHU/ketf14eOTWW6dY/klmzRfaPpCVBZmJHXYgEWVK2MBilJbuWAGb4z
h4wYR646O/C/k41UHmBWoOulOvCuDUfYmQzcgEz+10BojPZRY1oeR9PwnNZrEGlB
hfxjTM0v+R6JJsUtPQX9vLJzkB/rLzFjGhs423oFfl1zlCiYSyLGxqRw84WJADk1
XB5ZRWpDbZkYKcraCoVbfChV09yWq8nP+FDiZBM+XTNTGnvf+sTRJr7BO3hPgAKo
YQtUHLdgeSTmuiS8/zH8X9O2N0mGyOthyJKC8mYIdqJVvDdOVgQFdcgKR4kdCSWq
8ZzBkp2GvZAfRRB6/9Ihq6+2RTa0cxVkt38jIXhN9fgVC/DUXZMZzgwCwLBLDq42
KgMUQ2aHtsFRn+nGhb7CxTpQHsfVbBCALZd1ERyLCoF5M+X2iDBNC6ky6iU1MnW+
M+ZgnfyCPi//UELLrMEK
=jgQ/
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Oct_2012_08_07_53_+1100_7oDEXA62s./aNV2Z--
