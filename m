Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2KLVr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:47:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55880 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2KLVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:47:58 -0500
Date: Tue, 13 Nov 2012 08:47:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: ftrace next tree request
Message-Id: <20121113084749.a1c6f250556e28100f870e29@canb.auug.org.au>
In-Reply-To: <1352745934.18025.8.camel@gandalf.local.home>
References: <1352745934.18025.8.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_08_47_49_+1100_soP1g5Tkxz5qqz89"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_08_47_49_+1100_soP1g5Tkxz5qqz89
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 12 Nov 2012 13:45:34 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> Here's my request for getting the ftrace tree into next.
>=20
> Git repo:=20
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
>=20
> Branch: for-next
>=20
> Name: ftrace
>=20
> Contact: rostedt@goodmis.org

As this seems to be based on things in the tip tree, I have positioned it
after that tree.

Added from today.

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

--Signature=_Tue__13_Nov_2012_08_47_49_+1100_soP1g5Tkxz5qqz89
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoW6FAAoJEECxmPOUX5FEKnEP/iH2J+1uvXvUlOIMhm84dsq/
36Rxci7mgO524rmaHrDx5mppeI4DPt6cKWfv/JQz8eP7ManFDdoh5IFnqPBuiuAR
AWLnUZjQZhPBfGycPSii5x9NWlQ2LE/sDcxl5oKdOMn2NaSHrby+lbBOF1xVvKCP
IaxUmEw+yG//P53zJbBhD2AoWqk0vdIzcbk9bu8mRqBZm2kVkT6mzFEoT3JAzC8u
9qm2VFhsKvKnL3pQwruKfBniTEDpkQkWzeMaDHc7U9Kr62cRoBp0j+jQPNVOVwoa
Ld7dnLBpMCAgFp+MWo+mYuH/Wvdcab1NsmTLxs3qBZsPTMlV2pLYWqvh51fVq0UU
2XjeRYO/4CB8NonD707PFBoDYaPyWEmBuAGe6jbe84S71vJ0VyM+qlURtVAMC+Z7
4Uh6ut16OqedDsL83o34AOSWxzaXyyeQDrHISZeyq2r5ncRUm0wqEeXtPWWUkjmc
pdUjGQ+11G9E53FJG2QmKuKwr5nATj0GV3/jH5LHnHHXll/HMTvI1BL/UxvmNLPM
J/IIAW8nWOI7seyX3slRymixb9UVaR4zCrl72evRgp3Xbe4GYylaTvg18t4aO37E
Z0HBTwLU9phadZcxEds9fJEstp1Tp6cohg/aDDUupBXNf30imjJP6arpziv/t/Zv
x3hWRn1XtbLD6VqCMb+x
=Nvq8
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_08_47_49_+1100_soP1g5Tkxz5qqz89--
