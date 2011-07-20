Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1GTFdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:33:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53047 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1GTFdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:33:31 -0400
Date: Wed, 20 Jul 2011 15:33:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the ptrace tree with the s390 tree
Message-Id: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_15_33_20_+1000_xuuPNZvdYBcEo.Ne"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_15_33_20_+1000_xuuPNZvdYBcEo.Ne
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ptrace tree got a conflict in
arch/s390/kernel/traps.c between commit 248bed4b0f3c ("[S390] use siginfo
for sigtrap signals") from the s390 tree and commit a288eecce525
("ptrace: kill trivial tracehooks") from the ptrace tree.

It looks like the former is a superset of the latter, so I used the
former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_15_33_20_+1000_xuuPNZvdYBcEo.Ne
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJmigAAoJEDMEi1NhKgbsEeMIAIgubmwwhnLlhqLGH0Yx9kqy
am+Adh8Lx2Se8Upk7NpJoBs2WqFPKzcRD9ysQAhXzfgwXYbNlK8tNlz8mE/YDhFu
oajvUNisL1abhSwN2ywpUwXQQhspJQaJluKtzcWJBlNLaQ7Rot6bHxv7WviZKMNq
ZHksNZl0mEXpXzpcoqwZpEiPud1RKm3cbBpFYcGdZSQPBy5sriTS+0MBD5yuHQ8l
i1w5qKdd1OAjwngkbbrytJRyu1+Edw3RVgW/bEv4eC9XGjG1NM426yxEfdlxsc57
HS4wGXOcFTxZZP+G/zPVeyT8h/lHuHsB2sxgk20TkUVorVG0ylN5TXXS31V82Fw=
=ypDU
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_15_33_20_+1000_xuuPNZvdYBcEo.Ne--
