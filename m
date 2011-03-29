Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1C2XOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:14:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36345 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1C2XOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:14:01 -0400
Date: Wed, 30 Mar 2011 10:13:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Linn <John.Linn@xilinx.com>
Cc: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: xilinx linux-next tree addition request
Message-Id: <20110330101353.40d40776.sfr@canb.auug.org.au>
In-Reply-To: <58f8b399-ac49-484c-9e99-d23bcda08a8b@VA3EHSMHS024.ehs.local>
References: <58f8b399-ac49-484c-9e99-d23bcda08a8b@VA3EHSMHS024.ehs.local>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Mar_2011_10_13_53_+1100_uzNSrhc5Ug=lSXfR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Mar_2011_10_13_53_+1100_uzNSrhc5Ug=lSXfR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Fri, 25 Mar 2011 14:35:12 -0600 John Linn <John.Linn@xilinx.com> wrote:
>
> I have a tree I'd like to see show up in linux-next:=20
>=20
> git://git.xilinx.com/linux-2.6-xlnx.git arm-next=20
>=20
> After v2.6.39-rc1 is released, it will contain Xilinx ARM work intended
> for the 2.6.40 merge window.  Everything in there has been posted,
> reviewed, fixed, etc...
>=20
> If order makes a difference, it would be best if it's after Russell's
> tree as it could have dependencies on stuff in his tree.

This will be added from today (I was waiting for -rc1).  I have put you
down as the contact, if you want any additional people/lists, then just
let me know.

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

--Signature=_Wed__30_Mar_2011_10_13_53_+1100_uzNSrhc5Ug=lSXfR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkmexAAoJEDMEi1NhKgbsbeIH/RAZGsKmiNCaMAX+S/Ku+oaV
0frlaWhGgrJQNTc9H/dhsQ4FR/TZeQ8wu2Hz1dfFXqO9ACATiDu60xueHUlm1i1t
7GgMDXYiwntr13tj4Pw6EtNetZFpASuQSshTAQCwfYtNBvKEI8Ang0kqygbxcqZ9
TeZ2I7zp9hGYNH8Ym8EG4A1+O+0n5LZKnDVhMywHvfjuf/7PUhnzXxgwZIUU1wdn
9LEc4qEHQOdFQAU+Fny0Sm8Yh74dokLVQrKJZa8Zsj1R44mEykFO/SMvmUDY8EVS
2MMjKq/ubpkjqu4jwAXhk9AJclqBSze5hyZyygQBmVC/itFUIz5uS9Exepw+G2I=
=5//b
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Mar_2011_10_13_53_+1100_uzNSrhc5Ug=lSXfR--
