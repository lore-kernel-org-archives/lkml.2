Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2IEEAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:00:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57631 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2IED76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:59:58 -0400
Date: Wed, 5 Sep 2012 13:59:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the rcu tree with the tip tree
Message-Id: <20120905135947.34ba1c8356cbfe374c6c4ea8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Sep_2012_13_59_47_+1000_q0ExDkzWagak61nU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Sep_2012_13_59_47_+1000_q0ExDkzWagak61nU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in
kernel/sched/core.c between commit f319da0c6894 ("sched: Fix load avg vs
cpu-hotplug") from the tip tree and commit ead504e5600e ("sched: Fix load
avg vs cpu-hotplug") from the rcu tree.

These are 2 slightly different versions of the same patch :-( Same author
time, different commit times ...  The rcu tree version contains this
extra bit in the commit message:

"    [ paulmck: Move call to calc_load_migration to CPU_DEAD to avoid
     miscounting noted by Rakib. ]"

So I used it.  Let me know if this is not correct.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Sep_2012_13_59_47_+1000_q0ExDkzWagak61nU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRs4zAAoJEECxmPOUX5FEALYP/i0Btufm3wCmw72Su2ohR2YL
75XIL3I+cogGw68Owf9Iu1bxI61JGfb1mrDk+V8rRyeIm+BjakddWGrCNB6oykKK
rzxY2SyZeQxULHrG52Oru+MZZ0YePurnHr95o/zQFLgw2wGY5w58isP31NoPrC4a
uI/Kmy1IUbPqLNmwLa+13VzdL06Ny/iKXLEhd3jE9MsJwzNKvJaSowE68d72R8IW
BFA9uaynnDx5fzfCkvnawODXRuhAmB0ea/2X5dZY04d5Lmknun1oQ/9XrIMbl1ib
LBHzMHls/sQ5neHRr0wi87NYmoojrOtHurbx+egVg7cg4nFtgWKvYbmCzGy03xT2
scDfPAPbyXDPY71yqANgkhOWC/9jDLZ+5KEmxkRcXDPe/ilPmyhSds0vGZBlCPe3
JqPXiG1rKv4ChvraWTHZH0OKtSqK0EWDxZlT0dzAFajdtr4JvwfEVY0q6GlzY/nv
adY9GGf6l3Pgxk/+h+rcRz6oG2otJPNYX20Zpjycl9LjNM44sYfjZtqtyAwd8h3S
62S8KWlJq6C/vWDa3DOr1y6qo9KqoVcl0PuqgfRPLlxfY7FzSaQ+AtGKcRiUyFNV
PIeZg/hst3VEIXO5d5xsivsUcFdELrCxr6ZqupMnFFdZdOhvbM1YBHhMpMDUZFj7
lijEjJ76C7Rgw93jQY+t
=O3qe
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Sep_2012_13_59_47_+1000_q0ExDkzWagak61nU--
