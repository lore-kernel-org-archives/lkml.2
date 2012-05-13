Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2EMXfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:35:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33447 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2EMXf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:35:29 -0400
Date: Mon, 14 May 2012 09:35:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Please include user-namespace.git in linux-next
Message-Id: <20120514093516.2d567677f1ab1d02c3a9cc69@canb.auug.org.au>
In-Reply-To: <m1likyz4mh.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<m1likyz4mh.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_09_35_16_+1000_pI/tG/LMiPoB66fO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_09_35_16_+1000_pI/tG/LMiPoB66fO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Eric,

On Fri, 11 May 2012 16:20:54 -0700 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> In linux-next please include git://pub/scm/linux/kernel/git/ebiederm/user=
-namespace.git for-next

I assume you left out "git.kernel.org/"  :-)

Included from today.

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

--Signature=_Mon__14_May_2012_09_35_16_+1000_pI/tG/LMiPoB66fO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsEU0AAoJEECxmPOUX5FELhwQAIXFMZAJcYwjEbc7C6MmP3PN
DDw090H9SdsSscDnFUSBfLP4vwIm+Cvt1uqP2TgBhRvoMUhfMvGWlZW6okfkjg4D
b6A9RI7Uldd8RxYTuTyEI7QkN37/QaC1scoJ0qhlO5vmVi4EhTp1Mpt1O2/pGeIV
EIEBqKDlfkydLI+9rxVrvWnR/D3N0u0m2NQifqshl0KQOW4GG0OssXTbLsvcS0th
rhxnhtjq3a6kxQLeqoeqWDTu7VWcQmkVEfsdyLYguSPYlN6Ga17pcRN7mECYLHgv
nuyfp0MI0cX3GQTccuq3A7MdNixnuagUOtv/KByGRtNsLVoKaJKH/CU3U6sruODV
IH5SkJnGhjA7z2C76y6zTsqZXlt4WBFNOjG8HcvEryHfF+EbiLvEfsPpazCddA0g
DAA1W8S8hY/9qbR6bL4X9tKHW2y+bT/326b2yfdIj/x7n6MlnsnAzQm0bvmTOZKf
6au7+bNSxjPHoCk5TVsVf9IWKc0pgcxjkJrF0yIh2G7eS1ripX7UMfNatTXQuz4d
qXTVQejMf1O3Dt+Iu6BnAwzX9YUEEpJRw2zv5UlDk9V7Rez9oFnWq+Oypt291TjM
6m+ieY21oT7fN547jYGUJcUvangKrQBUCo7HX1xgxan8lka8c0rc3ss5cASYtcts
Fpr1hvjuteS2DTH9dB9Z
=0vcQ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_09_35_16_+1000_pI/tG/LMiPoB66fO--
