Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2JQXia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:38:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35940 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2JQXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:38:29 -0400
Date: Thu, 18 Oct 2012 10:38:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the  tree
Message-Id: <20121018103826.c8e1312904747b31caa376f6@canb.auug.org.au>
In-Reply-To: <20121018103713.0ccb63374964501c3d8d99a5@canb.auug.org.au>
References: <20121018103713.0ccb63374964501c3d8d99a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Oct_2012_10_38_26_+1100_lte5KU8sS+xUIgr0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Oct_2012_10_38_26_+1100_lte5KU8sS+xUIgr0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just cc'ing Geert]

On Thu, 18 Oct 2012 10:37:13 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Greg,
>=20
> Today's linux-next merge of the m68knommu tree got conflicts in
> arch/m68k/include/asm/termios.h, arch/m68k/include/uapi/asm/auxvec.h,
> arch/m68k/include/uapi/asm/msgbuf.h, arch/m68k/include/uapi/asm/sembuf.h,
> arch/m68k/include/uapi/asm/shmbuf.h, arch/m68k/include/uapi/asm/socket.h,
> arch/m68k/include/uapi/asm/sockios.h and
> arch/m68k/include/uapi/asm/termbits.h between commit 10b3a979347d ("UAPI:
> (Scripted) Disintegrate arch/m68k/include/asm") from the m68k-current
> tree and various commits from the m68knommu tree that use the asm-generic
> versions.
>=20
> I just deleted all those files and added the following merge fix patch
> and can carry the fix as necessary.
>=20
> I think that this is the correct thing to do ...
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 18 Oct 2012 10:32:20 +1100
> Subject: [PATCH] m68k: fix up for UAPI changes
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/m68k/include/uapi/asm/Kbuild |    8 --------
>  1 file changed, 8 deletions(-)
>=20
> diff --git a/arch/m68k/include/uapi/asm/Kbuild b/arch/m68k/include/uapi/a=
sm/Kbuild
> index 972bce1..aebdbf5 100644
> --- a/arch/m68k/include/uapi/asm/Kbuild
> +++ b/arch/m68k/include/uapi/asm/Kbuild
> @@ -2,25 +2,17 @@
>  include include/uapi/asm-generic/Kbuild.asm
> =20
>  header-y +=3D a.out.h
> -header-y +=3D auxvec.h
>  header-y +=3D byteorder.h
>  header-y +=3D cachectl.h
>  header-y +=3D fcntl.h
>  header-y +=3D ioctls.h
> -header-y +=3D msgbuf.h
>  header-y +=3D param.h
>  header-y +=3D poll.h
>  header-y +=3D posix_types.h
>  header-y +=3D ptrace.h
> -header-y +=3D sembuf.h
>  header-y +=3D setup.h
> -header-y +=3D shmbuf.h
>  header-y +=3D sigcontext.h
>  header-y +=3D signal.h
> -header-y +=3D socket.h
> -header-y +=3D sockios.h
>  header-y +=3D stat.h
>  header-y +=3D swab.h
> -header-y +=3D termbits.h
> -header-y +=3D termios.h
>  header-y +=3D unistd.h
> --=20
> 1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Oct_2012_10_38_26_+1100_lte5KU8sS+xUIgr0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQf0FyAAoJEECxmPOUX5FE3qMP/00Q8feuStfBPM7Wd1kZnOwF
ueRuENmG3lIgzcRECz1rzPSezTBi9/KRxDYFDxzINP5Hemf35j+g8LNt05BnejKi
oL96eOcJkZUtbgczrd3o6/dviHH11IdPtER7XoWUzXuawXbalpTVEumDP/Y1fOdu
VdT7I6K062VDJP9kRbIeYymP/0a9lRb3brlgI8UrbaB/hWN3aErvy4q28I29GBad
7VSn3MIwS2MpkiWI/cxlRfBoL9JIQbDu5BMWu2d65Y7Ktx3+5V8Oy+Fw2K9Q6Ryw
+37evG7+yF8LvzUR5WRjjOVFKFjSCB2zrtbHhNW1jzzQ8AI8Mqghhp7l+7u199to
YSs6iiziML+vd467Mwrhot+Y1JKv8dmEchX91vKLt5w9k0wlLwxgBdKv67uprv06
D9qbiXQ0AkA/Jxg7T4n/TVrMTzMorcObhw6bLAzS6GBPJ+hgv7b2OK1U1cZea2CK
QUf1dFSGepZU1MJ9i13msNsusG0AmYhveHwn6wJrjPgdExnpNvrg/Lzy/5tOyrCu
bvDTAZwYZJ/Ex9bYFh3uIaVELWb/qdIZRGQttb5witW1GENAIg5Qmyr078h/n3SM
lBccUu5VFTGvYe2dprlQWB2TfYI381G5OU0rKgK68uUwYCi7ix7b7AlJMWo5wGqE
DNtt/y8kN1sVuh4paqUM
=uv0L
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Oct_2012_10_38_26_+1100_lte5KU8sS+xUIgr0--
