Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1HaFMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 01:12:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38152 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1HaFMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 01:12:39 -0400
Date: Wed, 31 Aug 2011 15:12:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>,
        lkml list <linux-kernel@vger.kernel.org>, Trond.Myklebust@netapp.com,
        neilb@suse.de, bfields@redhat.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: undefined reference to `sys_nfsservctl'
Message-Id: <20110831151227.1713621edfc2948b7d4b3223@canb.auug.org.au>
In-Reply-To: <6C86E8D5-E93C-4D37-8D86-03F88309CD44@kernel.crashing.org>
References: <alpine.DEB.2.01.1108282138020.9183@trent.utfs.org>
	<20110829161726.c980a80258fe714db49b425b@canb.auug.org.au>
	<alpine.DEB.2.01.1108290809260.9183@trent.utfs.org>
	<6C86E8D5-E93C-4D37-8D86-03F88309CD44@kernel.crashing.org>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Aug_2011_15_12_27_+1000_Ti+P5I=602hkx=xe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Aug_2011_15_12_27_+1000_Ti+P5I=602hkx=xe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kumar,

On Tue, 30 Aug 2011 23:38:48 -0500 Kumar Gala <galak@kernel.crashing.org> w=
rote:
>=20
> On Aug 29, 2011, at 10:11 AM, Christian Kujau wrote:
>=20
> > On Mon, 29 Aug 2011 at 16:17, Stephen Rothwell wrote:
> >>>  MODPOST vmlinux.o
> >>> WARNING: modpost: Found 1 section mismatch(es).
> >>> To see full details build your kernel with:
> >>> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
> >>>  GEN     .version
> >>>  CHK     include/generated/compile.h
> >>>  UPD     include/generated/compile.h
> >>>  CC      init/version.o
> >>>  LD      init/built-in.o
> >>>  LD      .tmp_vmlinux1
> >>> arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> >>> (.text+0x5be0): undefined reference to `sys_nfsservctl'
> >>> make[1]: *** [.tmp_vmlinux1] Error 1
> >>> make: *** [sub-make] Error 2
> >>=20
> >> I posted a patch to Linus earlier today (subject of lkml message:
> >> "linux-next: build failure in Linus' tree").
> >=20
> > Ah, thanks. Will try. Meanwhile I've just reverted=20
> > f5b940997397229975ea073679b03967932a541b (All Arch: remove linkage for=
=20
> > sys_nfsservctl system call) and it compiled w/o errors too.
>=20
> Posted patch to fix this on PPC.  Hopefully BenH will notice ;)

And Linus took my patch today, so already fixed upstream.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Aug_2011_15_12_27_+1000_Ti+P5I=602hkx=xe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOXcK7AAoJEDMEi1NhKgbsoIEH/RL0a7OlFzIm59Z9Up1eM3qe
jlzLZNiJwcgEZ248C48JjKFVakkA6uz+YLDR6yQsTpe7guGQSeWGjr+MZGXxChnH
no8X6gmT7Cu1LtXgiM5Y1RlSCMmFWGC3iBzxTs+WHdmAUw/WDKFyoJYtpySVxz/g
7mUafqWO8FvvAfLFyCLdXPSd7bd1pkaZmJ/t2Whtow39sePGI61bCoGU0dN1HODV
9gz9rmN0BIaP7BS9yoc5h+aje9NzBu5aRRrd49XNcDgPMUroxoej6TMqffQC/X/k
SBoKL5gsOhphWfMvcByfsJBzqjVFohRpT6YZ4pDxdA2oJfxsPoGNmAGju29QLaQ=
=d/9o
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Aug_2011_15_12_27_+1000_Ti+P5I=602hkx=xe--
