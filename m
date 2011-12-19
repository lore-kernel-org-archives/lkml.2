Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1LSEtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:49:47 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38627 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1LSEto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:49:44 -0500
Date: Mon, 19 Dec 2011 15:49:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: linux-next: manual merge of the tip tree with tLinus' tree
Message-Id: <20111219154938.0375549c381b3d7bce466b50@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_15_49_38_+1100_eOxR310iFltIvumU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_15_49_38_+1100_eOxR310iFltIvumU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/sched/fair.c between commit ab2789213d22 ("sched: Fix
select_idle_sibling() regression in selecting an idle SMT sibling") from
Linus' tree (where this is kernel/sched_fair.c) and commit 77e81365e0b7
("sched: Clean up domain traversal in select_idle_sibling()") from the
tip tree.

OK, I am not sure what to do about this, so I just used the tip tree
version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Dec_2011_15_49_38_+1100_eOxR310iFltIvumU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7sJiAAoJEECxmPOUX5FEDEEP/jz4hqh+QinHHU2yjCpWhxuo
J61V5IjcBIVMOLEdBtxJf31Fgt++IUfEhCRS/MNovtYZcsUCTrsAu6pdW9sXUMwU
/dsCRRA6yYjRRZJ8pbzo/h2naRe7x7DmaK9Cdy972OxlTQbRcePgpOSGTtbpKpZ4
p4vj2RmsKPyg2Z1HjzgsEZjLHqaQj5dpK6EBX9zpR9hfIDhsetd9nAs6jUFKaN/s
bLW2NOJh8Jn9Ukod5eImfkX8karGSZY2OskZcCV+RdLRRqHFuv2JSWJH8Or26N+S
YBuy+f2bNpGwlfRv964XSXobdGhDPRzoEZV8nq6haK0vqd3tXgBd3eX7t8GLV+Nw
FGDiVQ7Y+k84UCKS0Lx4Fzc1V0+AJHQmecKMQ70iQOYlxSxOZV5U0c1Qz7y0gnMI
tM0mF+CViOTHQUe8A94z+ozZnBjG0Kjz3nGQX/nmCwjcqx1PVwKmFM9yPqXXuaYV
Qn/iSxwESOP8itG3g5iQkfzXTDuMgIpaZO/c/MLPENcWmXdsU246gFeJzcSVQAo8
kmazl/pZdqWDujunzHJLbxeN5w1+baEY1LHUO7Kgv/REWBx4dK+F5U5CVpXaD+iS
7rvA1ZBRIuYDPPkWgudw8papqKT0OCzDgieVX9JQOFbSrW4MUl1ezMfUWnfjhOle
IIUwlHKldijmO7YCIfJm
=2FZC
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_15_49_38_+1100_eOxR310iFltIvumU--
