Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126Ab2CNUTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:19:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39431 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2CNUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:19:48 -0400
Date: Thu, 15 Mar 2012 07:19:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: Tree for Mar 14 (printk)
Message-Id: <20120315071934.77f0af64a4c633c545d68ea4@canb.auug.org.au>
In-Reply-To: <4F60BFA6.2030804@xenotime.net>
References: <20120314181921.59451eca117c276461f7dc28@canb.auug.org.au>
	<4F60BFA6.2030804@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_07_19_34_+1100_fhMTTBxpi6gmRjqP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_07_19_34_+1100_fhMTTBxpi6gmRjqP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 08:56:22 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> on x86_64:
>=20
> kernel/printk.c:1230:5: error: redefinition of 'printk_sched'
> include/linux/printk.h:136:5: note: previous definition of 'printk_sched'=
 was here

Caused by commit 3ccf3e830615 ("printk/sched: Introduce special
printk_sched() for those awkward moments") from the tip tree.  The
declaration in include/linux/printk.h has alternatives determined by
CONFIG_PRINTK, but the definition in kernel/printk.c is not so
protected ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
\

--Signature=_Thu__15_Mar_2012_07_19_34_+1100_fhMTTBxpi6gmRjqP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYP1WAAoJEECxmPOUX5FEqBIP/iu2tO45UnLFm04wfqII5NcT
yjc72hhQmQRlhko/n2dOMcfdgMYrSj2s2u6Zh6FGPDibEmYxUcZU/8kxnV4m9p72
IBCMSG9bQ0gvmmy3QqguMErHkkSepWolfKKbM0pKkKjpdD+6fHO9KdI4S7QJlbbO
JWhXvIu4vjuanlJq0XGW3vyFNMaCMqiApmbW7wnscdrgvW7lstQIJf+0FuTJ2gUX
kRlVjTCfgGs8O7Sk9N0ZtiF73Xo8taKGrw1y3u9ruCiOFe8b+Gedt1ogbETfI7GF
C0BlP7HuVQfNunWR8iXClxIwyrWfrawf3YvSePqrcbN1xOwnRed0cJEq+P+opweN
bxgJZT0Q8rHeOOonS5D7HCV9tk8uj6WoT4rjMpBwblOuZCOPoSBuSo3LKOA2U4gO
e2XKNM2VGFwxt0xn2UkqWBV7EyniYGhoghvv4q6Y5AXu7VJeyNf20iCdTUKEsCuP
dglFzRN+OLd72n2ZXQ3G18yjQxU/UeTl9BXzR+518Y56N6ZNCTh2jHGglYMa4UCJ
jgsMkTLOivRg3CcdvAGxrDRBqFVsj2y+szsKpl1V8JFQfCgK6xylpL88wdP5Z8sy
mdp5OsBvTT4+26IbZpBb8sY66yUMfQlfeb5GxdMRJ8+blO0DSC6zPvTh9+u16T5n
QY4UmKdfRegElH50BGSo
=9Aei
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_07_19_34_+1100_fhMTTBxpi6gmRjqP--
