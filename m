Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3AGW2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:28:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47711 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3AGW17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:27:59 -0500
Date: Tue, 8 Jan 2013 09:27:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: please cleanup the cpuidle tree
Message-Id: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_09_27_51_+1100_5AFCty_p_sS0GiKR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_09_27_51_+1100_5AFCty_p_sS0GiKR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

All the commits in the cpuidle tree have been included upstream before
v3.6-rc1.  They were rewritten before being merged upstream and so are
now causing merge conflicts in linux-next.  Could you please reset the
head of your tree
(git://git.linaro.org/people/dlezcano/cpuidle-next.git#cpuidle-next) to
be somewhere in the tree that yours is merged into (pm or Linus').

Alternatively, if you are not using it any more, let me know and I will
remove it from linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_09_27_51_+1100_5AFCty_p_sS0GiKR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ60vnAAoJEECxmPOUX5FEX8sP/juY1hkPuOifPJWxk9Qu+Gfn
bnSasaa1oqvlrWETxB5lLpsCZjRBcQWS1klHNPNAQYofJAwcss1GL5qdgsMxfUqN
oe72yHbRw69gZeywcz+aXYAqkYzEfrz1vpSutiqJRxEwo1scFn6Xvk/5zkUfklcU
9NVCNDAFHrmQpc1t03jcuXEPNl2Ffb6dm6vzqreNcq7iSbc1uzfvhzUgZfAJlM95
TIry1jhtuMjWkZqg0AMincC2PcV+NHKsTUlcPPEshgA0TF3qsUrQAFxuGmT7EVb4
bBB4g9mB90qUNIWjTsOUXSWFLSBF5Vx1r+dWmvvL8XTodOApWFZueUeHZGO14xU8
/1kz269wdXWtBWFhxLRAkn04U/EbgOsXjnOQpZhlKr7f1dvRviWP/wRbrd/u/H1z
nslHDEoMiJoIt0fLLOXX0RXeiPOUyLnYApO050DfTKyrVjYx9T4Y50Sb1AWW8Yx+
o7pOl/cBxIGEE6RYePuId/fSONXfOL3Aq7SSJuWLfVGVSJRCAg5xrupiUz8VrkVL
zJBG+HPlYe9wSXOE9aRn+DpEnaqjTX0VkquKsi+boPFsm/EF91Dp8qDI7PJMvqkT
WmcefV5FaBjk/4GZSNJUbWOvfsVrpyNGWiVhHIeqTMmhdc0tLxATawzmrAKiczN3
cLr9xYLvXT7jOqGg9ko4
=ZfA6
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_09_27_51_+1100_5AFCty_p_sS0GiKR--
