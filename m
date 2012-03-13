Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab2CMGJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:09:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42154 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2CMGJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:09:10 -0400
Date: Tue, 13 Mar 2012 17:09:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the uprobes tree
Message-Id: <20120313170901.ba969605b8aba03f3cd92df3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_17_09_01_+1100_6CvWMf8YlA+9Gdec"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_17_09_01_+1100_6CvWMf8YlA+9Gdec
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

After merging the uprobes tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/trace/events/syscalls.h:11:0,
                 from kernel/trace/trace_syscalls.c:2:
arch/x86/include/asm/syscall.h: In function 'syscall_get_arguments':
arch/x86/include/asm/syscall.h:98:2: error: implicit declaration of functio=
n 'is_ia32_compat_task' [-Werror=3Dimplicit-function-declaration]

Caused by commit 1e1e2cddc33d ("x86/trivial: use is_ia32_compat_task").

I have used the uprobes tree from next-20120309 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Mar_2012_17_09_01_+1100_6CvWMf8YlA+9Gdec
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXuR9AAoJEECxmPOUX5FEabMP/36Xcjz+ENAX+hleVRW7cPks
lGzENYSte/b+hVSKydLPvk2/GkUXqNJezOUJMgUM4FsBayLt1fSoNl5AS0HNnhbY
a25UVJkhF9S6E6N91+QxvEDuwpAq+8I3mlEknVJzmHMy9xu6qIyJUYh9pPXKtvoO
lgbCk7T41Kpyr/OuYhfa4LCC1Vw7AXSaGlFwDmTBVEs6KgSYaab+/DtOVNqiSMDf
NGTtlNHH42sRqZp49NPkslOTMDY4MrsulJuY9eKSVO+nbCI1mDNwD0BnB9ngLkqI
gLzzEKIczHZfnlquLvsRSnsY7gIdn9fCvfxbqozsGXSBMk7Fv86y1vFhQxbSIjoX
6+BW0i4gUNx7ytsZsY54NeS9yvrQBvWzkQ9i5EyABOD7XXRpKTRRou2Y5xEHUAhu
XsEWG5HRuVro9rWR9JrhgT/35vbQN+CC0hauFyyXl9ICbPPbvRV8c57vys6I5npv
XVg4Ff4B3jOpmFejVnsEoUxk4/wGTgrRC7R8/EhkYAgdRaBbkIV3KSgcDEs1HKxw
lxJiqehUoLRa8KYi1HVrlVB8ygHMCNJy7upLV8JsTyParT8CEwg+FeNykOu3uk1x
tZFlxoa8IPFv2E5n0yxSCOZwG1RtUe/zBciZHKHfM0pDMp4MGuYmT7bjsEoh2n+b
bxPFYbBbBNxRMRmtyb3o
=ccGH
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_17_09_01_+1100_6CvWMf8YlA+9Gdec--
