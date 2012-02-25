Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2BYSaN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 13:30:13 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:2836 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385Ab2BYSaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 13:30:10 -0500
Date: Sat, 25 Feb 2012 15:51:16 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20120225145115.GB22460@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111122200414.GA28205@alea.gnuu.de>
 <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
 <20120220173844.GA2546@alea.gnuu.de>
 <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de>
 <20120221083213.GA19059@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <20120221083213.GA19059@alea.gnuu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

J=C3=B6rg Sommer hat am Tue 21. Feb, 09:32 (+0100) geschrieben:
> Alexander Graf hat am Mon 20. Feb, 22:27 (+0100) geschrieben:
> > On 20.02.2012, at 18:38, J=C3=B6rg Sommer wrote:
> > > Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
> > >> On 22.11.2011, at 21:04, J=C3=B6rg Sommer wrote:
> > >>> [1] =C2=BBkernel BUG at include/linux/kvm_host.h:603!=C2=AB
> > >>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
> > >>=20
> > >> This is unfortunately still there. It's because of preemption being
> > >> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
> > >=20
> > > This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm getti=
ng
> > > this Oops, when I start qemu.
> >=20
> > Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git? I
> > fixed a bunch of things with preemption since then and it definitely
> > worked for me. If it still fails in that tree, I can try again to
> > reproduce it :).
>=20
> This kernel (e9badff4b38a3f8b2c20aa8a30db210caf85a497) fails to build:
>=20
>   CC [M]  arch/powerpc/kvm/book3s_pr.o
> arch/powerpc/kvm/book3s_pr.c: In function =E2=80=98kvm_vcpu_ioctl_get_one=
_reg=E2=80=99:
> arch/powerpc/kvm/book3s_pr.c:883:45: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:80: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:284: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:327: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:459: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:748: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:1112: error: cast to pointer from intege=
r of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:1476: error: cast to pointer from intege=
r of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:883:1867: error: cast to pointer from intege=
r of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c: In function =E2=80=98kvm_vcpu_ioctl_set_one=
_reg=E2=80=99:
> arch/powerpc/kvm/book3s_pr.c:898:79: error: cast to pointer from integer =
of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:898:114: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:898:319: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:898:364: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:898:502: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:898:591: error: cast to pointer from integer=
 of different size [-Werror=3Dint-to-pointer-cast]
> arch/powerpc/kvm/book3s_pr.c:898:2061: error: cast to pointer from intege=
r of different size [-Werror=3Dint-to-pointer-cast]
> cc1: all warnings being treated as errors
> make[3]: *** [arch/powerpc/kvm/book3s_pr.o] Fehler 1
> make[2]: *** [arch/powerpc/kvm] Fehler 2
> make[2]: *** Warte auf noch nicht beendete Prozesse...

The culprit is this patch:

commit 784f1782e3c9cab310d6c513df966c547c3f17aa
Author: Alexander Graf <agraf@suse.de>
Date:   Wed Sep 14 21:45:23 2011 +0200

    KVM: PPC: Add support for explicit HIOR setting
   =20
    Until now, we always set HIOR based on the PVR, but this is just wrong.
    Instead, we should be setting HIOR explicitly, so user space can decide
    what the initial HIOR value is - just like on real hardware.
   =20
    We keep the old PVR based way around for backwards compatibility, but
    once user space uses the SET_ONE_REG based method, we drop the PVR logi=
c.
   =20
    Signed-off-by: Alexander Graf <agraf@suse.de>

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 089c61b..5985209 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -212,6 +212,7 @@ int kvm_dev_ioctl_check_extension(long ext)
        case KVM_CAP_PPC_BOOKE_SREGS:
 #else
        case KVM_CAP_PPC_SEGSTATE:
+       case KVM_CAP_PPC_HIOR:
        case KVM_CAP_PPC_PAPR:
 #endif
        case KVM_CAP_PPC_UNSET_IRQ:
@@ -652,6 +653,11 @@ static int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu =
*vcpu,
        int r =3D -EINVAL;
=20
        switch (reg->id) {
+#ifdef CONFIG_PPC_BOOK3S
+       case KVM_REG_PPC_HIOR:
+               r =3D put_user(to_book3s(vcpu)->hior, (u64 __user *)reg->ad=
dr);
+               break;
+#endif
        default:
                break;
        }
@@ -665,6 +671,13 @@ static int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu =
*vcpu,
        int r =3D -EINVAL;
=20
        switch (reg->id) {
+#ifdef CONFIG_PPC_BOOK3S
+       case KVM_ONE_REG_PPC_HIOR:
+               r =3D get_user(to_book3s(vcpu)->hior, (u64 __user *)reg->ad=
dr);
+               if (!r)
+                       to_book3s(vcpu)->hior_explicit =3D true;
+               break;
+#endif
        default:
                break;
        }

Later, this code was moved to arch/powerpc/kvm/book3s_pr.c by

commit c6afb78d175ae6cf99f4191fbb258e54478b0371
Author: Paul Mackerras <paulus@samba.org>
Date:   Mon Dec 12 12:26:50 2011 +0000

    KVM: PPC: Move kvm_vcpu_ioctl_[gs]et_one_reg down to platform-specific =
code

Regards, J=C3=B6rg.
--=20
Es gibt nichts sch=C3=B6neres als dem Schweigen eines Dummkopfes zuzuh=C3=
=B6ren.
                                                        (Helmut Quatlinger)

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9I9WMACgkQwe0mZwH1VID9dgCeKkd+fY505FbwxFhwmndb6o/D
l+0AnR9xUKCc3Wt4/e1NDz61svMZvXFr
=5Eb3
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
