Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1AaG0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 01:26:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47809 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1AaG0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 01:26:18 -0500
Date: Mon, 31 Jan 2011 17:26:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110131172609.1d5e1695.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_17_26_09_+1100_VtEdLlAbZiOJDFgJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_17_26_09_+1100_VtEdLlAbZiOJDFgJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:989: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:999: Error: attempt to move .org backw=
ards
arch/powerpc/kernel/exceptions-64s.S:1008: Error: attempt to move .org back=
wards

So something has added a bit of bloat in there.  I have left this broken
for now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_17_26_09_+1100_VtEdLlAbZiOJDFgJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRlYCAAoJEDMEi1NhKgbsSTwH/Rzop6pyZMJaVHLc9CSB1SQA
kZBm8uSuhPZqzeQsdGb3N8CbBPLI7u13Nha6stWkVKf1SVBaK+MezI6T2Jsnrqgm
1Oq6RJY2UaV07RoC2iZJxWGIvgQFVeuG432cP6057BKMdO1Sd0qM98676k2JJ5eF
U4373R7Q/hYuoRrHdAZpovd6vyrs8w1hdUEGMqV7eU7jNAfTYbFEYRuuggf2RaQ2
iUeKYQ2cvdftllZG4m1npiv9hrDkMGjCifvdP+NZ1ryaJID6bQjN8zvaG+4XglEM
HwUNDNDHuFFjGgIl5BQGtr+pP144+7Q4JXIhnpwWqYsb6dZyEdMEckljsJ1ecUM=
=YC3W
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_17_26_09_+1100_VtEdLlAbZiOJDFgJ--
