Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2KILuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:50:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2KILuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:50:50 -0500
Date: Fri, 9 Nov 2012 22:50:25 +1100
From: NeilBrown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Menzel <pm.debian@googlemail.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Message-ID: <20121109225025.13a846ca@notabene.brown>
In-Reply-To: <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
	<1352460945.4387.7.camel@mattotaupa>
	<ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HWX=XfW+x3w2Kmowvi6l6xk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HWX=XfW+x3w2Kmowvi6l6xk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Nov 2012 12:39:05 +0100 "H. Peter Anvin" <hpa@zytor.com> wrote:

> Sorry, we cannot share those at this time since the hardwarenis not yet r=
eleased.

Can I take that to imply "Acked-by: "H. Peter Anvin" <hpa@zytor.com>" ??

It would be nice to have at least a statement like:
 These patches have been tested both with the user-space testing tool and i=
n=20
 a RAID6 md array and the pass all test.  While we cannot release performan=
ce
 numbers as the hardwere is not released, we can confirm that on that hardw=
are
 the performance with these patches is faster than without.

I guess I should be able to assume that - surely the patches would not be
posted if it were not true...  But I like to avoid assuming when I can.

Thanks,
NeilBrown


>=20
> Paul Menzel <pm.debian@googlemail.com> wrote:
>=20
> >Dear Jim,
> >
> >
> >Am Donnerstag, den 08.11.2012, 13:47 -0800 schrieb Jim Kukunas:
> >> Optimize RAID6 recovery functions to take advantage of
> >> the 256-bit YMM integer instructions introduced in AVX2.
> >
> >in my experiencing optimizations always have to be back up by
> >benchmarks. Could you add those to the commit message please.
> >
> >> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> >
> >[=E2=80=A6]
> >
> >
> >Thanks,
> >
> >Paul
>=20


--Sig_/HWX=XfW+x3w2Kmowvi6l6xk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJzuCjnsnt1WYoG5AQKyyBAAk4ZOtaUmdZPIYv0+U5p+CfH3vZjAn+kE
iBtuPLmvzJNNAXjCGSmzwCMmYyWtC2C6zOPjiGmzEyU84O6Mu1ugl+DrlqoUJ2IQ
b0m05I2bbOno59a7DYT/JTjbesss3Enz7Iw2DRoYv6dQbd599wAEQiiEb3cPNGr3
NTk5PF+pp/qfE50FsNan8jDkoP8qE7tqgAGCmgqiguTnklpuApbcZLoyAfpwDKfr
Rp5bErm5jW1QKAW6y0bqROLPmM6Q2yJB8oUEg7l5+bpRYm/lrE8U5FOVlXA5zSac
kiPZZb/CDgdhrUgVEv40GeJtG4hbOep9wY+HhoHcfOPB9NqJRtOtfgxTKv/w4AEo
auxUfoZEp6EjEQo95qb2GhBNoMHt4KZVkthW+RhPMB1EojareNx3KbcMJQUtURw4
BhfIfpGEGRDQW7C7+vCYO9/5xT1s6oxz3hQ+QIugRdLLEG0sErtqDXvpB8sQyJKM
wgCL/bLuuePoEriKmPyWIDSdau8CyghCynV+fGha9w8Ia01FfCCJ3o5hAgIY4eeS
BVnFuROs13NboB7dAMi611vSmDYFqj2jTxnTfXtrg6Pmx3mLhA5uUe1YY2gAT/Cf
eQn69zUKMAp4slsyBjRHjRHm1ijQugULrgWHI/klZ/MlCp3uWdVkywH/cJPDw3ew
FGE37HjZjwo=
=aC85
-----END PGP SIGNATURE-----

--Sig_/HWX=XfW+x3w2Kmowvi6l6xk--
