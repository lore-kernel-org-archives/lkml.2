Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0I1QvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:51:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37845 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0I1QvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:51:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-ports@sourceware.org
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Tue, 28 Sep 2010 12:50:45 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, "Joseph S. Myers" <joseph@codesourcery.com>,
        Chris Metcalf <cmetcalf@tilera.com>, linasvepstas@gmail.com,
        linux-kernel@vger.kernel.org, andrew@codesourcery.com
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <Pine.LNX.4.64.1009281537400.22692@digraph.polyomino.org.uk> <201009281813.56443.arnd@arndb.de>
In-Reply-To: <201009281813.56443.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12991478.74sYa6kY2B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009281250.47196.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12991478.74sYa6kY2B
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday, September 28, 2010 12:13:56 Arnd Bergmann wrote:
> On Tuesday 28 September 2010, Joseph S. Myers wrote:
> > C6X has no MMU so a glibc port isn't a possibility.  There are indeed
> > uClibc and GCC ports we will be contributing in due course - but the
> > linker support for shared objects is still in development (I contributed
> > the static linking binutils support upstream earlier this year) and is
> > required for building anything for uClinux userspace for this platform.
>=20
> Right. Obviously the same question exists for uClibc though: The C6X
> syscall ABI will need to be rewritten (as in deleted and replaced by
> generic code) in the kernel in order to get merged, so the uClibc port
> will have to gain the same kind of generic API that we need for glibc.

i dont think uClibc needs nearly as much work as glibc.  it already goes ou=
t=20
of its way to avoid code duplication whenever possible (and then some).  th=
e=20
position glibc takes wrt copy & paste at the file level makes me ill and so=
 i=20
tend to double down in my uClibc efforts there.
=2Dmike

--nextPart12991478.74sYa6kY2B
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJMohznAAoJEEFjO5/oN/WBmK4QAI3J/somjazSRcxDJh8G6YWn
KgqwOIfUaGxChBFm3Mocn9fbI/+AU9AXoEIq5SVUNt3hPuZP8C1Pvm35L+p7EVwb
Jj+wB2km48v2eVkalFpfTWPpyte7du9t1k7JJSZ/1M1p1TniePN9Lm0YW+TN6B+b
cpQN+DGdzg5FMyc8vj3jwoJ3yvDA2QoDiLTM1HDqgnsUzRtT7OAmbJQvKYaZROUJ
sA1QZ8zcks5uEVv6FwJh6SF04XsyF1JmyAvnwVAcFRn9QfCerRi3FTQF8rMq3r6O
bwLcoWu+s3YU1is4gPK1/M2YcCacAFHUzsaa93ZIifHx9lYq8Q8JzQ7XPL01ZUna
mkuJdTqYdRXZhpaVc9aH8COBu5bVxPgfnyD7293Llq1jINiFfk2Y1CMFDc/TGboN
9aQF5UicQNJfKQMPDnT9w+xmhXE9gOHEwhPWl+5VoLMHkU5EXwpdVjvpgHLZHCuY
Q15Ts5gHnKUQjk9L9gWwL6PvjB0L10q0vtEhRoccpo83NGUUI7HGv7dZxenc9Ux4
u1Cc60fYvWSbhlw/0uqD3xrx152cPstvHvj7feZyTIPtFQqBSNqDfacSro2QmW0j
grlIAs/iDseHoXq5CZbjG2Khs8ZDEq/EaSP8mCOcTuG0RN8mM5OMh0YVJbYUfwrV
2uMQ+eOIYCQ1daUpCTDI
=2B5t
-----END PGP SIGNATURE-----

--nextPart12991478.74sYa6kY2B--
