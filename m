Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2EUHaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:30:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51143 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2EUHaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:30:20 -0400
Date: Mon, 21 May 2012 17:30:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the userns tree with the tip tree
Message-Id: <20120521173006.3c10df123692914ab19497b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_17_30_06_+1000_0ObzOsN__.Fu1Ns9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_17_30_06_+1000_0ObzOsN__.Fu1Ns9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
include/linux/sched.h between commit 50954a1f450e ("sched/numa: Provide
sysctl knob to disable numa scheduling and turn it off by default") from
the tip tree and commit 7b44ab978b77 ("userns: Disassociate user_struct
from the user_namespace") from the userns tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/sched.h
index 37a7cd8,5fdc1eb..0000000
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@@ -90,7 -90,7 +90,8 @@@ struct sched_param=20
  #include <linux/latencytop.h>
  #include <linux/cred.h>
  #include <linux/llist.h>
 +#include <linux/jump_label.h>
+ #include <linux/uidgid.h>
 =20
  #include <asm/processor.h>
 =20

--Signature=_Mon__21_May_2012_17_30_06_+1000_0ObzOsN__.Fu1Ns9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPue7+AAoJEECxmPOUX5FEYxsP/iKCPwt3HdulO57p/qTdnTUq
gqPDweZYP/lgKb9YGjX+nbACdT/IXfGY1npj/rQXJSkYTZO1CStkQUjdC5DKjeQd
XoJ7FzqhRoysgqV6JIYcyPMuT7aBKnWDcFNqueF8M4ofcMKQoLxU+g9qSUJOKSmK
8WbQwqop8TfmyxqCfbHCwierdd18PIdt7F0CLNpSVpNBkdDGj0qTrV5BoI/Pl6yc
TZCXNDQ7E/byVGx8p8lbu2h0o9GdGqD5WjYdihvfaOiczLSy5NAZmolVDOQy5TAP
WCHv0/qhg6JGqrtM8DnG7j5XDsoEi/+23re7j+pj50tq2Y6z+lfabYyf3VykAHE5
AzhzP8wLC4LljxCF+CLmm6EWGavSIn3BCLVniR1Eb06YxzHPpMl3cidzzbWAIa3V
7O5hi1ggprzV+LwNZQ4i954DlDHjin8/ztghfknmk4l8ouOf6v6MM55dEaAg+ib4
da0X5QLUm+gH4pjMqBF9O62Jono3VEPaOMT9vf+/AfSKi8h4AeW7ZVLUeLqU3z+5
x4IDle/5e6qnN3RXZzq/MkP0ImXDeN1BfjHP45QXwOFcBX5iTPmWkuUnFI45dFiO
7YFaPob2iX64pox2nUf4BllO2Sni2Dq2Dx5pd/h4p5l7GoWeRSi3ixiXNQGhZaAp
TqWBV85uaKDeQUjle2V/
=ILbH
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_17_30_06_+1000_0ObzOsN__.Fu1Ns9--
