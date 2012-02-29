Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966242Ab2B2C37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:29:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55208 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966056Ab2B2C35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:29:57 -0500
Date: Wed, 29 Feb 2012 13:29:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the rr tree with the arm tree
Message-Id: <20120229132946.3683c8a06314a7bd541aaa0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_13_29_46_+1100_1iSN4cdoLszLT873"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_13_29_46_+1100_1iSN4cdoLszLT873
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/arm/kernel/kprobes.c between commit 214f3e7464bc ("ARM: 7332/1:
extract out code patch function from kprobes") from the arm tree and
commit 8dcf0d7856cf ("remove references to cpu_*_map in arch/") from the
rr tree.

The former moved part of the code modified by the latter into another
file and, in doing so, applied the appropriate fixup.  So I just used the
arm version of arch_arm_kprobe() - the patch to arch_disarm_kprobe() is
still required.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_13_29_46_+1100_1iSN4cdoLszLT873
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTY2aAAoJEECxmPOUX5FErCQP/3Kqpuyq4lkClE+t9cxZkuBq
kZJkFO7d9vO7kBo243UA5mNA+z9HtSw7NYqFZHnfjr+rYMyM130zGFluajsA0c9i
71o/3tzSgI2r8pSIXyeQzE0AwkKF5PHHJveZ1DoSSHJwrkV2CuOXrbv1rj2MLWs3
JJtemYKINmSvgSLp+uOtCD/KE7Zq8hUqiXfDyx2B9x/HU17Sp/9G3gWaocO9qeXH
QeRokhk4tzLSxLR1YYjgcMnYrn49/DS4mpPJMuev52Dgo01VBCYIrQNUWr2lOU1F
mPEdoqEvCYa0PDDSxuB+Frq6PQ2I7b1LbQUIOuLBCuDZ1T2F+PpUcYu2LXwJxf3o
hwqKCDQXDmTSytNOfoJ751TpVVMKql282O23Z6YWliIO7t00bAy9MI/NogkAkwuO
e1AQDOxauRpobfwQtn47TcQQSZmpAyN2XkMWWDHFqOHf0OuQ8FNZ66ns9hCZUGji
R1koHfyFWsyd8fvMGv/Knu/DVWdeRzOdn0s73hZ7NMjtZ0mIuv1XCGfjqRJ5BQum
JQMxbjRWM0Xlcw0W4EVKJgkozAoPuRAU0JlcdrRNbJ4dgYiPnsTA7tKlhZLMPtZ7
pGVE+ud9AC3v0X3xtJqpPdL9ZZUT8kcqNQCi0cbNs0moIZ0vCwZLHzjffAHAkdSj
5qJ/3G7EmwWPJFoyev/x
=8bob
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_13_29_46_+1100_1iSN4cdoLszLT873--
