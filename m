Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1LKPja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 10:39:30 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:3096 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1LKPj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 10:39:26 -0500
Date: Sun, 11 Dec 2011 16:16:20 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20111211151620.GC28756@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111122200414.GA28205@alea.gnuu.de>
 <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
> On 22.11.2011, at 21:04, J=C3=B6rg Sommer wrote:
> > J=C3=B6rg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
> >> I'm trying to build the kernel with the git commit-id
> >> 31555213f03bca37d2c02e10946296052f4ecfcd, but it fails
> >>=20
> >>  CHK     include/linux/version.h
> >>  HOSTCC  scripts/mod/modpost.o
> >>  CHK     include/generated/utsrelease.h
> >>  UPD     include/generated/utsrelease.h
> >>  HOSTLD  scripts/mod/modpost
> >>  GEN     include/generated/bounds.h
> >>  CC      arch/powerpc/kernel/asm-offsets.s
> >> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In functi=
on =E2=80=98compute_tlbie_rb=E2=80=99:
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: er=
ror: =E2=80=98HPTE_V_SECONDARY=E2=80=99 undeclared (first use in this funct=
ion)
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: no=
te: each undeclared identifier is reported only once for each function it a=
ppears in
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: er=
ror: =E2=80=98HPTE_V_1TB_SEG=E2=80=99 undeclared (first use in this functio=
n)
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: er=
ror: =E2=80=98HPTE_V_LARGE=E2=80=99 undeclared (first use in this function)
> >> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: war=
ning: right shift count >=3D width of type [enabled by default]
> >> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
> >> make[2]: *** [prepare0] Fehler 2
> >> make[1]: *** [deb-pkg] Fehler 2
> >> make: *** [deb-pkg] Fehler 2
> >=20
> > I'm still having this problem. I can' build
> > 6fe4c6d466e95d31164f14b1ac4aefb51f0f4f82. Are there any patches to
> > make the kernel builds and do not oops [1] on PowerPC?
>=20
> The failures above should be fixed by now.

I've pulled git://git.kernel.org/pub/scm/virt/kvm/kvm.git
(a41d08d13f903da5c633fc58ee074156f05ab3ce), but this tree doesn't contain
a suitable commit. Where can I find it?

Bye, J=C3=B6rg.
--=20
> Ich kenn mich mit OpenBSD kaum aus, was sind denn da so die
> Vorteile gegenueber Linux und iptables?
Der Fuchsschwanzeffekt ist gr=C3=B6=C3=9Fer. :->
Message-ID: <slrnb11064.54g.hschlen@humbert.ddns.org>

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7kyUQACgkQwe0mZwH1VICL5wCgkD+I2Tuc/SYIeDTlgi+QAGXK
b8YAmgN+p7WBmpoVoQ2EJIROrZd72+IE
=8ymh
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
