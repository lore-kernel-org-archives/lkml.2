Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0LOWAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:00:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50388 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0LOWAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:00:30 -0500
Date: Thu, 16 Dec 2010 09:00:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, John Reiser <jreiser@bitwagon.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ftrace/MIPS related x86_64 build failure on in Linus' tree
Message-Id: <20101216090019.639191a1.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimgNVUaQcRdva_usq1XX=vp1xwHM3rUeT_hNCZd@mail.gmail.com>
References: <20101215160440.bafbe38c.sfr@canb.auug.org.au>
	<AANLkTimgNVUaQcRdva_usq1XX=vp1xwHM3rUeT_hNCZd@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Dec_2010_09_00_19_+1100_o8ilcfpFRmi+Be0F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Dec_2010_09_00_19_+1100_o8ilcfpFRmi+Be0F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnaud,

On Wed, 15 Dec 2010 01:45:45 -0500 Arnaud Lacombe <lacombar@gmail.com> wrot=
e:
>
> On Wed, Dec 15, 2010 at 12:04 AM, Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > Since October 31 our x86_64 allmodconfig builds have been failing like =
this:
> >
> > /opt/crosstool/gcc-4.4.3-nolibc/x86_64-linux/bin/x86_64-linux-ld: arch/=
x86/ia32/sys_ia32.o: bad reloc symbol index (0x1000000 >=3D 0x6b) for offse=
t 0x808080 in section `__mcount_loc'
> > arch/x86/ia32/sys_ia32.o: could not read symbols: Bad value
> >
> I got the same on mips, target was BE, toolchain's host was LE.
> Doesn't https://lkml.org/lkml/2010/12/2/224 address the issue ? This
> patch does not seem to have reached Linus tree yet.

Thanks for pointing that out.  I wonder how we can push that along.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Dec_2010_09_00_19_+1100_o8ilcfpFRmi+Be0F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCTpzAAoJEDMEi1NhKgbsa2AH/3IZwKd4yPRsxe2f2KemSwN0
Hi45pZjTWfVAMbDZXVzk9R6gkQoQjy4fMJLO3vjrqzOA7diETdoeaX9xhINqtMRY
B3ZcWmo8R5hCgovaOxS2Z1eMi8fW3uXDiw/Tn8LXYHwdoJXbIoWIZdCA37vOEZPs
kQ9GNKUaGSuN4s9HGv7lddxvRABSe+YAtCT77e4+N6ThmRMR7PzwBVdzHkcZi7md
lZmUVpVahTjLlVdZIlssT9jVY3ahhF/bsO6YW9RcJiOuQxggHL6yngyNegSqXdR8
KLQTSZKW1YM8i9U6Rwqjkz93M6n1oVGMvWHG0TREJ4kyR3+NeKyp0kFt2XW6OYU=
=pZtt
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Dec_2010_09_00_19_+1100_o8ilcfpFRmi+Be0F--
