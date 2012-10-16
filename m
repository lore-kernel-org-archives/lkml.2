Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2JPCl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:41:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39603 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2JPCl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:41:56 -0400
Date: Tue, 16 Oct 2012 13:41:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-Id: <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Oct_2012_13_41_29_+1100_Xetdj=4rn0ma2Ztr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Oct_2012_13_41_29_+1100_Xetdj=4rn0ma2Ztr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Fri, 12 Oct 2012 14:34:33 +0300 (EEST) Pekka Enberg <penberg@kernel.org>=
 wrote:
>
> Please consider pulling the latest LKVM tree from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool=
/for-linus

So you have not taken this in the v3.7 merge window.

Will you ever merge this?   If not, it should be removed from linux-next
(where it has been sitting since before v3.1) and turned into an
independent (to the kernel) project.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Oct_2012_13_41_29_+1100_Xetdj=4rn0ma2Ztr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfMlZAAoJEECxmPOUX5FETgwQAIJAKWXu0t7ivnst3jBTKm7x
AwCyQtwhJ+F5JIBWTAX5ZagN23GxPRKS1oedUBPH19OvMym2a+Yubi1Y+2iQVZqc
6XbODhtGXhnE9u1qMia8M0Q5Getw4CifGmHMl1sku2XAbN1gw6+vlB8iBhHMzieZ
f5up2IQ8j16OVqRAH2sUYiWXDssQ5Qjm7BeGw2Jmueax8gL5NxYZxpQwvXyBqrK/
R2f5n3W4c8MEX6MNOmrdcZTRcAsyYa59TR40+1/Zdn82F7iV8AcD3yonFiLrAIt5
TImJQ9dEzyhzMPkP3AkvzD8qAc3Wuk7tqhH6usX/0SeUrzeSanSUaivIA5QqIIk0
cFnrZydox/Ts0aozjKSbvphTtF4sLFohFyU7+gTQkhI/1VmoRg5l/tX4McTqOatv
ZHi2gu+OQTlis25ft1ksw2HYrL+t98Jr4UMPZk5Dgbpi87ZBNIudypPsvDd9pSk1
W9EXKuGZhAKDr0l3sqFkBbJ7dK6t4Dk8FpeRXO/KFZx2MOjBru3c2EHuOZFKpIfU
qaLiayZNbHCup10/1CBxwKpBWkETIbjHaZxqw+uM+EoISNbCArXgk1KevxsNbVeR
JKdS0dA3NRehbd5jzrARq9ZUgMshhtYNnZIwtqgBazebaySCJbWTXqDbmpqjSib5
gKCdN02HU6c5K5tguqNY
=dEF0
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Oct_2012_13_41_29_+1100_Xetdj=4rn0ma2Ztr--
