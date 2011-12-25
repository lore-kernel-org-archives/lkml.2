Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1LYLDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 06:03:11 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:1116 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1LYLDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 06:03:08 -0500
Date: Sun, 25 Dec 2011 12:01:09 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20111225110109.GA28757@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111220202711.GD6830@alea.gnuu.de>
 <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de>
 <20111224103108.GA19586@alea.gnuu.de>
 <20111224111359.GB3938@alea.gnuu.de>
 <C40CA3A1-2397-423B-96B3-CBEE4EA7EA30@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <C40CA3A1-2397-423B-96B3-CBEE4EA7EA30@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Alexander Graf hat am Sat 24. Dec, 18:05 (+0100) geschrieben:
> On 24.12.2011, at 12:13, J=C3=B6rg Sommer wrote:
> > J=C3=B6rg Sommer hat am Sat 24. Dec, 11:31 (+0100) geschrieben:
> >> Alexander Graf hat am Fri 23. Dec, 14:50 (+0100) geschrieben:
> >>> On 20.12.2011, at 21:27, J=C3=B6rg Sommer wrote:
> >>>>=20
> >>>> I'm so sorry to have to report a new bug in one of your patches. It =
was
> >>>> covered by the one above. I've picked the commit for it from your git
> >>>> repository and now, the kernel build fails with this error:
> >>>>=20
> >>>> BOOTCC  arch/powerpc/boot/fdt_strerror.o
> >>>> BOOTAR  arch/powerpc/boot/wrapper.a
> >>>> WRAP    arch/powerpc/boot/zImage.pmac
> >>>> WRAP    arch/powerpc/boot/zImage.coff
> >>>> ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
> >>>> make[3]: *** [__modpost] Fehler 1
> >>>> make[2]: *** [modules] Fehler 2
> >>>> make[2]: *** Warte auf noch nicht beendete Prozesse...
> >>>> WRAP    arch/powerpc/boot/zImage.miboot
> >>>> make[1]: *** [deb-pkg] Fehler 2
> >>>> make: *** [deb-pkg] Fehler 2

> I was actually thinking of:
>=20
> commit dfc209648daf8ba4197e71376b76c95fd26fd272
> Author: Andreas Schwab <schwab@linux-m68k.org>
> Date:   Tue Nov 8 07:17:39 2011 +0000

> But yes :). I guess we need to make sure this commit also lands in 3.2 :(.

So there are at least two commits they must go into 3.2 to make the
kernel build again, from my point of view:

=E2=80=A2 KVM: PPC: protect use of kvmppc_h_pr
=E2=80=A2 KVM: PPC: move compute_tlbie_rb to book3s_64 common header

Bye, J=C3=B6rg.
--=20
And 1.1.81 is officially BugFree(tm), so if you receive any bug-reports
on it, you know they are just evil lies.
            (Linus Torvalds)

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk73AnUACgkQwe0mZwH1VIBUjACfRdFXMLvoD+iT1YMGsL5rmotO
PCAAoLu6xF7o2YjkccxEoEK/NG1hFzdw
=SSNV
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
