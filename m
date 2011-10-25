Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab1JYNor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:44:47 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38040 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466Ab1JYNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:44:46 -0400
Date: Wed, 26 Oct 2011 00:44:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>, Myron Stowe <mstowe@redhat.com>
Subject: linux-next: build failure after merge of the pci tree
Message-Id: <20111026004430.6725033af543cb336a786a3e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Oct_2011_00_44_30_+1100_Qb3FBRpQzJ8VL+69"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Oct_2011_00_44_30_+1100_Qb3FBRpQzJ8VL+69
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci tree, today's linux-next build (powerpc
pseries_defconfig) failed like this:

drivers/pci/pci.c:2605: error: redefinition of 'pcibios_set_master'
arch/powerpc/include/asm/pci.h:49: note: previous definition of 'pcibios_se=
t_master' was here

Presumably caused by commit 481da3e3d53e ("PCI: Pull PCI 'latency timer'
setup up into the core").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_Oct_2011_00_44_30_+1100_Qb3FBRpQzJ8VL+69
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpr0+AAoJEECxmPOUX5FEn7AP/ikwUHYcJKsW1Gc4pFvt0iZc
No1t9LFBhEeyAmQWcMkvgDOFMF2cFJZOu6FTryRMVH96oInvY//F7VKflHFZyat+
DEG9jr4j8/YqLR8CeyhtAo/c6CMU+22T6zohSFms3q7YftlYx5pHssnCMgE5e/2i
Mtlyg7h5DUy6xwLU86bMT8P6Z4oBglIsX3uV9LJNwg/1COtLGppVcNVjsgpvglFw
wXer4t3QYB18MrRi6fwHuOU2muYRH236B7H762Nn2NUcYn/g0NMDG7l5K52q2irN
djk5/fkv/b1V+HvT1USS0JJiZ3Cs8yNDHHtWcELMdfU3kVjaJXbd7AoROt5NWtKX
F+UrvbPEQTz3C9HkQk4mmQBfsSsJqnW1OAkSLJ8PHN51ENk6yYVWZXcbx6krpCXc
9PzATbNBRdD27vrNXYYKbbfuB6sFg8B3ijizD7YxXWXdvOdl1j9GBKyLIYhytSmX
s8Hq6CLdd8ay8NvbVkGykByp9XVyQbJMmy10T91+QXFV99xAE5OebEQSW+yJ+h0g
VGxQIkJNTTZhm/mpH8wvc/2lxt4s0YdbMsDEIQS60NglU4TrXOy+LEmONQ+Drxcw
pb6bJSHqa0V5bxq2BPSnz0DvadO+4uvSXEGV757hpcsKpZIuqhtkhGh0ACKhCY4x
X8YdDGwxWfUnktcNqQBH
=x8wz
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Oct_2011_00_44_30_+1100_Qb3FBRpQzJ8VL+69--
