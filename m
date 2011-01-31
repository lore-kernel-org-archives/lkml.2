Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1AaEhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:37:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48698 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1AaEhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:37:39 -0500
Date: Mon, 31 Jan 2011 15:37:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the idle-test tree
Message-Id: <20110131153732.4df2f066.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_15_37_32_+1100_CwhWlqi2cRzXu2UG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_15_37_32_+1100_CwhWlqi2cRzXu2UG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the idle-test tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/idle/intel_idle.c: In function 'intel_idle_cpuidle_devices_init':
drivers/idle/intel_idle.c:467: warning: passing argument 1 of 'smp_call_fun=
ction' from incompatible pointer type
include/linux/smp.h:73: note: expected 'smp_call_func_t' but argument is of=
 type 'long int (*)(void *)'

Introduced by commit 080c9ff973b4f3683293abf8e8bf66b4f082fe65
("intel_idle: disable HW auto-demotion by default").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__31_Jan_2011_15_37_32_+1100_CwhWlqi2cRzXu2UG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRjyMAAoJEDMEi1NhKgbs33wH/RSBQa8nwUwMvM9VIe/PayMc
BeS4dpuPazRHA3N27Y37MCEAlxkk8WlO8c48RBZ4p69xdDit20tXwqXa10DaIuaR
hdUk6EmjNorFOJ6GaDWznhd7p8SrpRn6Gw6WTdz9/f7SBElF1evkeh7e1gVXjoyq
+sX2/T51yjrNQ++meFj9c5jvj0Z2chiJEahzyoXQCui7jMNFmdgk7ysMAFeYzGgt
f74qTZbxYMySFlYatgL3dbXX7FcR9+wkrB4vb568nhvkFWZ0DBfapCGZb0HoBQc8
pQNSSkalw+1KZs2mocMLwGA6mQT5ooJuRTPGvur8PH4mDsFT8SZsTEX1BsSgL2Y=
=Rs5H
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_15_37_32_+1100_CwhWlqi2cRzXu2UG--
