Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2JHAt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:49:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45491 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2JHAtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:49:23 -0400
Date: Mon, 8 Oct 2012 10:11:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the ia64 tree with the asm-generic tree
Message-Id: <20121008101131.a99cc80086482d0b1fc2c230@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Oct_2012_10_11_31_+1100_GKxfQq+Mp5xvujJY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Oct_2012_10_11_31_+1100_GKxfQq+Mp5xvujJY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ia64 tree got a conflict in
arch/ia64/include/asm/Kbuild between commit e7a570ff7dff ("asm-generic:
Add default clkdev.h") from the asm-generic tree and commit f68301fee715
("UAPI: (Scripted) Disintegrate arch/ia64/include/asm") from the ia64
tree.

I fixed it up (see below - I am not sure if this is the correct fix) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/include/asm/Kbuild
index 58f3d14,e69de29..0000000
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@@ -1,16 -1,0 +1,1 @@@
- include include/asm-generic/Kbuild.asm
-=20
- header-y +=3D break.h
- header-y +=3D cmpxchg.h
- header-y +=3D fpu.h
- header-y +=3D gcc_intrin.h
- header-y +=3D ia64regs.h
- header-y +=3D intel_intrin.h
- header-y +=3D intrinsics.h
- header-y +=3D perfmon.h
- header-y +=3D perfmon_default_smpl.h
- header-y +=3D ptrace_offsets.h
- header-y +=3D rse.h
- header-y +=3D ucontext.h
- header-y +=3D ustack.h
 +generic-y +=3D clkdev.h

--Signature=_Mon__8_Oct_2012_10_11_31_+1100_GKxfQq+Mp5xvujJY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQcgwjAAoJEECxmPOUX5FEj+UQAKa1RzvHgnAJdew0rikEgWjc
lrvb3wy6TxgqdvnySJPrAN6z/wJOr4Hjw04c5JZNVcNzaq7dzsZ7pR4Mz6hdLPe9
vnR2mvNDG4e9QsD5wNhbip9vLnrwnMCFxkzrO5MBCi61rSnQq78KFE3jWFS4Wx2q
F7ab1Ny9Ej3l2bbKQNeoj2gyNXYOe19ugdtwWpPmDIivufEpqVULeapGFCjYW9gu
LUg1XjWlJ7YuPINsB48ZKeGjJLtWyZkzV+2L0Zydzd321w4+d1BnRHuSLGSUETsT
JatEA3F4c7zw9xfrriqkIbSIzYWL/Bjcu72S9WWvSYN/wlkPFffEYawi16bbiTTR
9blLI7aUuwKR1powC9m6ipbNLsBmDebiRXGgE1DdyooolUUfLaEyEZaA8UKfx2bW
3QRoPilZlHvNQ0x9O+fNVulVRPk8ACQHMBGFWAUw19Aj8qkcW6XboIESs76PBVfs
Y1RbrU5tI6VynXylmpTSSqm7lG1tjTG5AKPrAIuI3GgBJS6zsj0aPMbOPm5Rxhd2
c1hwNQeqti5WtaHWBu3lNV9ppUDiHVkSm2PeGJWoID1EYmlFZ+K/jrqtWShxZ0Dr
afqQMbYkEeRC5NuwWdTilMbTZC0zHY0PvbBxiZLY+IsJUw8fUg5d6aK4NfXYMU5C
s2N0w1aBB0lgB+oXNw3s
=Rij1
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Oct_2012_10_11_31_+1100_GKxfQq+Mp5xvujJY--
