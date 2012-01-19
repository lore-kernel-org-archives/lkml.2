Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2ASCTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:19:15 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42186 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2ASCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:19:13 -0500
Date: Thu, 19 Jan 2012 13:18:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        Linus <torvalds@linux-foundation.org>, Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: Tree for Jan 19 (uml)
Message-Id: <20120119131854.d1795a461302e72e727e63df@canb.auug.org.au>
In-Reply-To: <4F1788EC.4040901@xenotime.net>
References: <20120119125932.a4c67005cf6a0938558e8b36@canb.auug.org.au>
	<4F1788EC.4040901@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jan_2012_13_18_54_+1100_j9zATWn5u0DBhJm+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jan_2012_13_18_54_+1100_j9zATWn5u0DBhJm+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jan 2012 19:07:24 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> Building uml on x86_64 gives:
>=20
>   CC      arch/um/kernel/asm-offsets.s
> In file included from /next/linux-next-20120119/arch/um/include/shared/re=
gisters.h:9:0,
>                  from /next/linux-next-20120119/arch/um/include/asm/proce=
ssor-generic.h:14,
>                  from /next/linux-next-20120119/arch/x86/um/asm/processor=
.h:20,
>                  from /next/linux-next-20120119/arch/um/include/asm/uacce=
ss.h:16,
>                  from /next/linux-next-20120119/arch/um/include/asm/threa=
d_info.h:13,
>                  from /next/linux-next-20120119/include/linux/thread_info=
.h:53,
>                  from /next/linux-next-20120119/include/linux/preempt.h:9,
>                  from /next/linux-next-20120119/include/linux/spinlock.h:=
50,
>                  from /next/linux-next-20120119/include/linux/seqlock.h:2=
9,
>                  from /next/linux-next-20120119/include/linux/time.h:8,
>                  from /next/linux-next-20120119/include/linux/timex.h:56,
>                  from /next/linux-next-20120119/include/linux/sched.h:57,
>                  from /next/linux-next-20120119/arch/x86/um/shared/sysdep=
/kernel-offsets.h:2,
>                  from /next/linux-next-20120119/arch/um/kernel/asm-offset=
s.c:1:
> /next/linux-next-20120119/arch/x86/um/shared/sysdep/ptrace.h:7:20: error:=
 redefinition of 'regs_return_value'
> /next/linux-next-20120119/arch/x86/um/shared/sysdep/ptrace.h:7:20: note: =
previous definition of 'regs_return_value' was here

Caused by commit d7e7528bcd45 ("Audit: push audit success and retcode
into arch ptrace.h") (another patch that was never in linux-next :-().

This file now needs protection against double inclusion.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Jan_2012_13_18_54_+1100_j9zATWn5u0DBhJm+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPF32OAAoJEECxmPOUX5FE5IgQAJfKFBiT3mwob6cmIHjyqAbe
S9cvyULoNAmya+axITwpQGEJc7PKhbWL4DfHuhGQMDf76T+NBN+GLG6EV9oj3IjY
xKGx8Kzhl1hkt9AjYYHXUhPVt8jJSTTFnmgalUMIsawKOeGafN0F5lQlVM51EIUm
fi9YNNFybaUfISmb2hsQex3N1iKS7jfwrpMNNuCL3eJbY+c5Y94QoAKqrbbcL+5B
Ffkt14u5rEaSQ1cpvaYmtDhVUuBSfvutV9OJn9rtxGZL6JSMBZf/Ru/UwLxripWG
JzBIRGtWPWmxxOFJXSYm4ELiWBX1RNhOVMINKM7GUZhJR3IpGdfBaAdhOMvIOsUZ
KvHe4U4ACn4GueX0RKP2YCr4NRUENmdv0wIAHp8xOCFlyl5SkTI4FnQdD4XD41pZ
XELzp2bQHNX8Y1JCmbpio01Yjg8cj5nHramgNZ2A6HRG8x0IWXMAXs89vW4sfnJc
Vrr3//v8UrEK0CWu01HvDQTd1r+dZuJm+EIUBqa3rN63T9GEBRTv7w068JS0hcs6
1djPcFi8b8UIqTFG1dAnIb+8+XZDhI24Z6kgXOadnZNbOx5C1hCXGwIQ+/+PtaOf
lkNwoaz50zm23DmvcTvV1jbjePl8/AD6c+Gb+g92OjGd9CPn6uV2Zsb36bq30SMO
PYgRABxLqEbWlIGO/NEH
=cBTC
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jan_2012_13_18_54_+1100_j9zATWn5u0DBhJm+--
