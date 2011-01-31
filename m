Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1AaWjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:39:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab1AaWjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:39:06 -0500
Date: Tue, 1 Feb 2011 09:38:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Xuetao Guan <epip.guan@gmail.com>
Cc: dmitry.torokhov@gmail.com, arnd@arndb.de, gregkh@suse.de, dtor@mail.ru,
        jbarnes@virtuousgeek.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Request (2nd) for unicore32 architecture codes to merge into
 linux-next
Message-Id: <20110201093852.32c951b6.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimKUV=RQezzME9qUUQjUjnHt9Qe79hOpK-cFC3i@mail.gmail.com>
References: <AANLkTimKUV=RQezzME9qUUQjUjnHt9Qe79hOpK-cFC3i@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Feb_2011_09_38_52_+1100_5x0QKBzeVl3I55SU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Feb_2011_09_38_52_+1100_5x0QKBzeVl3I55SU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 22 Jan 2011 21:52:11 +0800 Xuetao Guan <epip.guan@gmail.com> wrote:
>
> I want to merge unicore32 repo into linux-next tree, the position is
> (unicore32 branch):
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.=
git

Included from next-20110131.

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

--Signature=_Tue__1_Feb_2011_09_38_52_+1100_5x0QKBzeVl3I55SU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRzn8AAoJEDMEi1NhKgbsqSYH/iBCvpALw34RZ+mzJZX7AO6c
YAzTqvrwGngsyjvtZaz+TOU68qpiYKjy9i6cm7atyWKIHyY4b3gES8FtDD42rKzk
Nl3eJNIA2wL80eU7mUdp0Zq16IZsn7BKJTa1k88udhqs3w1STaxpxt2IxkaYURUH
Sh9yUC5BJnL1NuhWeBZ3O1dqg0hAJRqQ7JbPYR0VFfw34nqLtOouDGPePor9caw/
QdpD+g6w7o3XFG0rmgr+mwxB6W3iu0SOxt1GxqAtzzl/aHpsBiFMXqkqK4doKfLb
AL2iDdFYly9znzkTgJkzpOpUch0kL6ej4pkuauxvJAkj8Yn/X4Eifkcqk24Dazs=
=2khW
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Feb_2011_09_38_52_+1100_5x0QKBzeVl3I55SU--
