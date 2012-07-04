Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2GDXTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 19:19:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56091 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab2GDXTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 19:19:50 -0400
Date: Thu, 5 Jul 2012 09:19:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Please add the random tree to linux-next
Message-Id: <20120705091941.248e87ecdb43493ff203f3ce@canb.auug.org.au>
In-Reply-To: <nsxbojvqqdh.fsf@closure.thunk.org>
References: <nsxbojvqqdh.fsf@closure.thunk.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_09_19_41_+1000_7kjB1PQbYqp6VG7i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_09_19_41_+1000_7kjB1PQbYqp6VG7i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Wed, 04 Jul 2012 15:26:50 -0400 Theodore Ts'o <tytso@mit.edu> wrote:
>
> I would appreicate it if you could add
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git dev
>=20
> to the linux-next tree.

I have added that from today.

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

--Signature=_Thu__5_Jul_2012_09_19_41_+1000_7kjB1PQbYqp6VG7i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9M+NAAoJEECxmPOUX5FErocP/RcnGbr3a0dMhMVT9Vn6sHDX
Ed76sGia32gYtJeqbKESDS94mPTPRQ8eNyc+8jS/BRLtybgLfa9gaLgz+iVYU0+0
sKy4OPYFuC51CzENLgOCW/BFGfsryd2gwzMW0XIj9qAQRqbJEC+7+7sHmaWd1wba
VaYpJ0qzb9ICphAq9LVTZu1V5vIt76/PRoPf1xemCuN0+4VbSDlS+hLFAj8UpmV+
iKPCvg/nmtwo/2qxfSukEzi0SgsvqNXHrh1FpHS1Pggw51vQAdmDGiqdVKA5Yv+W
yT+bDOfrZc+2tAIURBGF4QdwpnVuUNVmiA2LzOUbR3hbnnD/1a6hGymW84Rxjkw7
uoaytvzeN47UKIBGPUPVQy5K/3hXtqWQNqiRvm//ArJJPWzs+mCJFZcnsTAo+lZy
1MDNWQ6tY947X446qIyUoZm1rtKJeTFFeLo34JR3Vt9iIVp5NzSUPNchZX6tu2E5
pEkOfs5L/UsTcvr7YmXKT3WoKeYFhwcoarqXTvrs8I/RA2M+yteMqTLs7WQMFFW2
lGb+cBmKdifevcKGKBSKumZ6ecjAwzYReUFZTfh4F02pddn1qD7uhOoR3+qHfFdf
T2aBQf6VgVeyKT0XhgB56ziofNtWZsJP1fozPGmzKrSX787N+hSfBGmvmjjyeE7g
fKqD+vWY+s+kPmK9YqXY
=0az8
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_09_19_41_+1000_7kjB1PQbYqp6VG7i--
