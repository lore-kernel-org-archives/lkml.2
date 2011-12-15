Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab1LOC3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:29:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53295 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1LOC3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:29:12 -0500
Date: Thu, 15 Dec 2011 13:29:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: linux-next: build failure after merge of the target-merge tree
Message-Id: <20111215132902.d0a90a93696702e09b0c60bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_13_29_02_+1100_HXTn+6Gah25Ftrjk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_13_29_02_+1100_HXTn+6Gah25Ftrjk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-merge tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/infiniband/ulp/srpt/ib_srpt.c:48:39: fatal error: target/target_cor=
e_device.h: No such file or directory

Caused by commit e0d85e515640 ("ib_srpt: Initial SRP Target merge for
v3.2-rc1") interacting with commit c4795fb20edf ("target: header
reshuffle, part2") from the target-updates tree which removed
include/target/target_core_device.h.

I tried to figure out what set of include files is now needed, but
couldn't easily, so I have dropped the target-merge tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_13_29_02_+1100_HXTn+6Gah25Ftrjk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6VtuAAoJEECxmPOUX5FE+awP/0BK60Sa3X830mTQrczL0caW
kEwTSII3jjV0/PgnAA5Wl0L6e4eEqtCsrAzqY1rdvWJx/tYScbW+RFSSGmJfU8oN
W6b9DLzjdXVMjVYaHrA/sZ7/Y6s0Uyq14tsGvJ8XhSwIhbhsWFvKPTdYKSUodb46
dgCtja2xwcQ7YEpwW6UBXrXWVkrvK2/WhhNo5hrbHsj7wRGvBUIDUWyAsD0DydW/
BOfzj5c6oXzOeNDi1jL2uFEqoALIQJWWDN32ANhLM9wO3U92oQ6e/K8eOZcykNpa
HSw5Ze8hqxRCKs114iFqGFE6Qk++yIHRAyBI+Ux8CbNsh7aSW3XZzcDahxKTUo5k
K/TaTppvfjPTIqS4WVU/AmLQBwYeAdZyFbgn6ievOhBpSFhV54EPESl1iK/BuBvx
LibP1HGG2gGDLTXTZELyS9WYcBVlHuAUm8IY9JTvxfzJ3bclsUhi6RsMr6eSJDeF
398zr0rb0PtX6FnipzThxNVX0/1FunPVaJRf6VwjL4L5rIEEu3fplJq9DLT9MwZH
VZrwCjb1y4D+C00GYnmcjszoHydANP+rZK7yPxUIhCXaWc39Lg4Oay5o9AOEaCDc
CNx7lp+ZduFef5yAr38kBacloq5HW726CI2rODVW1bV+Eexm3EHEBZlCZ8abDMGV
eUzzSF4cRCDi/C/XpSK2
=Nyev
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_13_29_02_+1100_HXTn+6Gah25Ftrjk--
