Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab2HVXwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:52:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60126 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2HVXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:52:15 -0400
Date: Thu, 23 Aug 2012 09:52:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: New tree -- linux-pstore.git
Message-Id: <20120823095204.a8e288ddb46a9707000ac5c8@canb.auug.org.au>
In-Reply-To: <20120822025037.GA18807@lizard>
References: <20120822025037.GA18807@lizard>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Aug_2012_09_52_04_+1000_s_rlucMAxztMSuMN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Aug_2012_09_52_04_+1000_s_rlucMAxztMSuMN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Tue, 21 Aug 2012 19:50:37 -0700 Anton Vorontsov <cbouatmailru@gmail.com>=
 wrote:
>
> Can you please add linux-pstore.git tree to the linux-next,
> the repository address is as follows:
>=20
>   git://git.infradead.org/users/cbou/linux-pstore.git master
>=20
> This tree is dedicated to track pstore infrastructure fixes and
> enhancements, currently it holds these commits:
>=20
> Anton Vorontsov (3):
>       pstore/ram: Fix possible NULL dereference
>       pstore/ram: Mark ramoops_pstore_write_buf() as notrace
>       MAINTAINERS: Add pstore maintainers
>=20
> Jovi Zhang (1):
>       pstore/ram: Add missing platform_device_unregister
>=20
> Randy Dunlap (1):
>       pstore/ram: Fix printk format warning

I have added this tree from today.  I note that Linus may require you to
GPG sign a tag for him to fetch since your tree is not located on
kernel.org (he likes them anyway).

I have put just you as the contact in case of problems - if anyone else
should also be listed, just let me know.

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

--Signature=_Thu__23_Aug_2012_09_52_04_+1000_s_rlucMAxztMSuMN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNXCkAAoJEECxmPOUX5FE9h8QAJExFxYIhi26ygMBulrhDV5X
5lUL714kjNPb2NnLYZc4PlEt/s9Na3o/Us2eezQnwCkLQDoR4p3+QtXc19PKWN20
/pV40k7C3SFL8Q8z5kHj4QUd8u7oFqbdu4JPYsEsvIsXoQqFsbKqrnBvHXyPgXFL
E8nw/oAlGGiijsyVadcvAmHjDUm6g0beLG2/LVpSLZ1FJBgFdBJFtwmVqDGJqrYJ
xLwvS5OvMy8MPez2p8iYscNYsZNEAgURJzdC0xWrWFOjff04jdsgpA7aMVLLaL9p
HLufo6oBkxZF175WTAI9PqxbCA/K+BL7WHaDCfUX4Gq/pIcpV9rw9+XRZKYY4alV
OAdWX6pLo4aefc+xhrxsV9xsdk53mmfD7CVOnBQL/rSApJ6A9/ZzKBjzK0oVXWk3
5aaS0FU3vUSJFF1OdFxQo/1XR6t1aEG8Z1kCstBeo00aGe5mw17pCPhYgJ5RN3Nu
Uhu5McWCwXsOA2vWSXaNWiv7CnDdSfT6viH7QgK4ZtgnXUH3TJYssKL/HJ/lUgOn
0QQMP1WmCrCYEiFiddu4kYQV0hcpjO5guA8iIpaUXhWixKqt4rZZghwSHUVjGbE9
RW51KXqbXPOMOrBvrNqX0ulWWfPDKMAiKfUB0z/9QkV0ovf1+0HBRuKNPq0CNT6b
lATH0m3+uY26uKIyown5
=899Q
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Aug_2012_09_52_04_+1000_s_rlucMAxztMSuMN--
