Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab2AFMF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:05:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60891 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab2AFMFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:05:55 -0500
Date: Fri, 6 Jan 2012 23:05:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/syscall changes for v3.3
Message-Id: <20120106230526.088cb77546022ecda34aaae5@canb.auug.org.au>
In-Reply-To: <20120105152918.GA12838@elte.hu>
References: <20120105152918.GA12838@elte.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_23_05_26_+1100_hT0A7XFmbZrEHG6Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_23_05_26_+1100_hT0A7XFmbZrEHG6Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Thu, 5 Jan 2012 16:29:18 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest x86-syscall-for-linus git tree from:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-syscall-=
for-linus
>=20
>=20
> out-of-topic modifications in x86-syscall-for-linus:
> ----------------------------------------------------
> Makefile                           # 052ad27: kbuild: Add support for an =
"archh
> arch/um/Makefile                   # 79320bc: um: Use $(srctree) not $(KB=
UILD_S
>                                    # 392f4b7: um: Generate headers before=
 gener
>                                    # c9b284b: um: Run host archheaders, a=
llow u
> kernel/trace/trace_syscalls.c      # d5e553d: trace: Include <asm/asm-off=
sets.h

HPA has a pending fix for this patch as it causes warnings on PowerPC at
least.  The idea was to move this include of asm/asm-offsets.h into
asm/ftrace.h so it only affects x86.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_23_05_26_+1100_hT0A7XFmbZrEHG6Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBuOGAAoJEECxmPOUX5FEHEwP/1B655BhtWPcsZOvjWSai8Eb
BE52AOoD9ca3o5ILB0BlCmc/u/vJaGOajzKrb0jZh2VgiIJETHQlz5wVn5tkX71e
7BihETwVznAsiHnJVGB1xvTPUVwZS3Gxu8k1Sb5O1YdxPSCx98z6YCla1w20uAEA
V7mNzXjPNHxsEWy4Npl6xvDZu8FijHxfd14+JrgrzrvbdadDir0eV/rM2j/nkUaF
LzIY3MXXfM1HHaQzWMcRh0swq6kSim3tK8RarymE88iA/luzT6hu/w4gz2GDu6ok
XYL3euNotmTuH8wG3lv7ECZaIv7JU0/7XjEe1EJYpD2VcgqifMznodesH2LQBjZ6
kCt/9QRtFj2fB4o8EDLTtES5gub9a02ZemF1Gi/K42PyDP9Nfnv9Nw/J/zecOf28
EC7kMIkmIlNvx6HjLM+3DL38yWzRa7XeurRu9J4QRjYeut/U0n/VhnSvLchNYZav
dfK6hRbbJY3YCJ58Zh29vGKbrizwaT/zsMmGuTXUOTwZb53j+tFL5JMYAXmH5WEp
rs/jDX/BKu66pT1Q6cJiHgXL1PHG6KpwrMns7ETssXNmojyzmQBVcSid4FjI8xQK
RJmVJApj62qj6ZimnmExSaJaNMlEBXhZ6yMAdX2g4dGOx1GZi2Fao0WYrQTTKu5U
Jo7nNF9doxx06CPtWXUV
=gH7+
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_23_05_26_+1100_hT0A7XFmbZrEHG6Q--
