Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1KVVFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:05:12 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:4997 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1KVVFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:05:10 -0500
Date: Tue, 22 Nov 2011 21:04:14 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20111122200414.GA28205@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20111107194838.GA23558@alea.gnuu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

J=C3=B6rg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
> I'm trying to build the kernel with the git commit-id
> 31555213f03bca37d2c02e10946296052f4ecfcd, but it fails
>=20
>   CHK     include/linux/version.h
>   HOSTCC  scripts/mod/modpost.o
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   HOSTLD  scripts/mod/modpost
>   GEN     include/generated/bounds.h
>   CC      arch/powerpc/kernel/asm-offsets.s
> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In function =
=E2=80=98compute_tlbie_rb=E2=80=99:
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: error=
: =E2=80=98HPTE_V_SECONDARY=E2=80=99 undeclared (first use in this function)
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: note:=
 each undeclared identifier is reported only once for each function it appe=
ars in
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: error=
: =E2=80=98HPTE_V_1TB_SEG=E2=80=99 undeclared (first use in this function)
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: error=
: =E2=80=98HPTE_V_LARGE=E2=80=99 undeclared (first use in this function)
> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: warnin=
g: right shift count >=3D width of type [enabled by default]
> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
> make[2]: *** [prepare0] Fehler 2
> make[1]: *** [deb-pkg] Fehler 2
> make: *** [deb-pkg] Fehler 2

I'm still having this problem. I can' build
6fe4c6d466e95d31164f14b1ac4aefb51f0f4f82. Are there any patches to
make the kernel builds and do not oops [1] on PowerPC?

[1] =C2=BBkernel BUG at include/linux/kvm_host.h:603!=C2=AB
  http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html

Bye, J=C3=B6rg.
--=20
Das Recht, seine Meinung zu wechseln, ist eines der wichtigsten
menschlichen Privilegien.
                                                (Robert Peel)

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7MAD4ACgkQwe0mZwH1VID/8QCfVefXdn1DVptP6VC0A+zK9tuy
7UoAn37W37h0CBkkFQyZvEm8SmQFPEty
=Zw5e
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
