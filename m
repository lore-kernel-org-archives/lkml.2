Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0LCFcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:32:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0LCFcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:32:17 -0500
Date: Fri, 3 Dec 2010 16:32:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>
Subject: linux-next: build failure after merge of the final tree (powerpc
 tree related)
Message-Id: <20101203163206.72258fb8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Dec_2010_16_32_06_+1100_JvS_ZedO9wo0axYP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Dec_2010_16_32_06_+1100_JvS_ZedO9wo0axYP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the  tree, today's linux-next build (powerpc allmodconfig)
failed like this:

arch/powerpc/lib/hweight_64.S: Assembler messages:
arch/powerpc/lib/hweight_64.S:52: Error: Unrecognized opcode: `popcntw'
arch/powerpc/lib/hweight_64.S:77: Error: Unrecognized opcode: `popcntw'
arch/powerpc/lib/hweight_64.S:106: Error: Unrecognized opcode: `popcntd'

This is with:

powerpc64-linux-gcc (GCC) 4.4.0
GNU assembler (GNU Binutils) 2.19.1

Caused by commit 64ff31287693c1f325cb9cb049569c1611438ef1 ("powerpc: Add
support for popcnt instructions").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Dec_2010_16_32_06_+1100_JvS_ZedO9wo0axYP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM+IDWAAoJEDMEi1NhKgbs2XAIAJTA+BUvwNsjdlodJArkTfm0
PvvbZszO+UF0RYZyXyKGMunEYxk+eG4EGjee9HQ7mG0I7ErMRI4KR+XuL9xUDOtp
8TX7QQri9LVotQQnH/iTYxhLVF8aFxdszq9f6tQEe4pQ3zg9iMLawiEiu3H/pAbb
LUz0CizeGQg4xo3JG2A0Rs8oT1Rd3giw0ClquxaqNTH1YaTIO+Vf1JvQT4MLQoCb
YO+kSgx1Z0cIPA0K5jNQexX1/4jKzqv/HGp8afNgoGII0+qt1ArTTHFC4kCrgPMk
wC5K9WzhfXWn3LbX1Q0LVuqLTY5zI0JchuXIjVADAkgfZ7EJ8ek4RDcq3bt3Mes=
=vqjs
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Dec_2010_16_32_06_+1100_JvS_ZedO9wo0axYP--
