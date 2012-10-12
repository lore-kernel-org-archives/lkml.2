Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2JLFLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:11:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49345 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2JLFLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:11:14 -0400
Date: Fri, 12 Oct 2012 16:11:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the tip tree
Message-Id: <20121012161108.7e97dea0942f681a0ee9f564@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_16_11_08_+1100_17N=dBvZAv7YWF92"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_16_11_08_+1100_17N=dBvZAv7YWF92
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc allnoconfig)
produced these warnings:

kernel/sched/fair.c:801:22: warning: 'task_h_load' declared 'static' but ne=
ver defined [-Wunused-function]
kernel/sched/fair.c:1013:13: warning: 'account_offnode_enqueue' defined but=
 not used [-Wunused-function]

Introduced by commit 4ae834f767c5 ("sched/numa: Implement NUMA home-node
selection code").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_16_11_08_+1100_17N=dBvZAv7YWF92
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd6ZsAAoJEECxmPOUX5FEs8MP/R94XRsbWrERXFzEV8Ouvi9T
06qBbOYNSReTUNc+wWKdqJp6MJRcW5vNfUSlG7Dxmp7148VDzWYpR1vrA9crnQSu
DpDEXoYTzmmwfdInLzfUpAkvF7D/OZf+HKLWuJra4bGUl1hgQT5Wk5UANs4QxyeS
4FiSkOO/mPPRSMIER6UF8zqGMr+ksDMv4c7QLFFnz9Z80OAlLwe+oMHFrWaEMsKI
w2uRpgnCvf+/441bvDgfmbi2yS58VjDj5KC7FBg/SehrSIUOcMkLzZZQT59TtFZZ
cs+5V590SeLpgimLF8egztY+fNXjKqYVBVnqYZM8Lh17c2ajLLYWdO+EikMLf4su
X1Q4FXQsRNDETsKCcAgAArXFG/FRWbXjSKSZ5yEzUYMcKRB0mAHHxUNrRreY/x7T
N0E8QJXPbNYQUJJdoEMZnDOGKHwRJsbtSzNHArk9Z4iTSkOqO6ObBLqnTPqa+Zd1
FoebMq6l1rH5Fl+KNtgND9NOURhi7dJ/LgXauPTrn5mHH6YrE6haENvXBWn8zXeN
d6kn1VEgNwkGG+P42ILn4gwXxCeMzolN89InYmYtA9HmDUQDlzZuWNXoYfNwbOzn
BMbhPgZbSCRrm7/yPup13z07tdSibwCNFEDMI9UQQJiH6oR1nLmlZqjxmpn7mk1b
wLmwu/6Y1ae33Sanvc6D
=ZlJS
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_16_11_08_+1100_17N=dBvZAv7YWF92--
