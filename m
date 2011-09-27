Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1I0FPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 01:15:07 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33209 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1I0FPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 01:15:05 -0400
Date: Tue, 27 Sep 2011 15:14:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the rcu tree with Linus' tree
Message-Id: <20110927151454.9892b23391f20bea20741c21@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Sep_2011_15_14_54_+1000_S6wOs8v5xOY.Jx8w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Sep_2011_15_14_54_+1000_S6wOs8v5xOY.Jx8w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in
arch/x86/kernel/cpu/mcheck/mce.c between commit b77e70bf3535 ("x86, mce:
Replace MCE_SELF_VECTOR by irq_work") from Linus' tree and commit
ef14aea88fee ("x86: Call idle notifier after irq_enter()") from the rcu
tree.

The commit in Linus' tree seem to superced the need for the rcu tree
patch ... so I effectively dropped the rcu tree change to this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Sep_2011_15_14_54_+1000_S6wOs8v5xOY.Jx8w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgVvOAAoJEDMEi1NhKgbs9ckIAICoUjk3DwhxLXFZ2iw0yYaJ
E0HpZc7EtVj9a+WEH3i6tvK3Vk0w8BPJluQJRfjRKErCcEORwHCljip/9TlMnS8l
8fZR5VwS5jIjuK0kAC1gcUW4y33s/0BYWbVkE6MTNLbI7VU7HmCA/oUxrhldhOpx
MowvSqofRqdm/O/ii1nskKz3RZLqgIqlMPCI0C0QJZl6NLjbzyLtSkLYYX5QfPiX
Ags7A1ahaoTrWoAOgAs68C6s44o3hEQw9r14YRoRJhaSlbMKhdf3TJzzrqtXUkhu
d39KIuz1YryAU0nY7YUHSS0Y8HT+swOox9+Vp0H+qCLrEGYMhEnzBUzopiA3y1Q=
=FtR4
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Sep_2011_15_14_54_+1000_S6wOs8v5xOY.Jx8w--
