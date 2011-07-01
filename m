Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1GAHIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:08:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37779 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab1GAHIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:08:51 -0400
Date: Fri, 1 Jul 2011 17:08:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20110701170843.bd60e326.sfr@canb.auug.org.au>
In-Reply-To: <4E0D5BD4.6080403@redhat.com>
References: <20110701151931.4c2d78b5.sfr@canb.auug.org.au>
	<4E0D5BD4.6080403@redhat.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jul_2011_17_08_43_+1000_Af9PKRt3LOIo8huU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jul_2011_17_08_43_+1000_Af9PKRt3LOIo8huU
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 01 Jul 2011 13:32:04 +0800 Cong Wang <amwang@redhat.com> wrote:
>
> =E4=BA=8E 2011=E5=B9=B407=E6=9C=8801=E6=97=A5 13:19, Stephen Rothwell =E5=
=86=99=E9=81=93:
> >
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > arch/powerpc/kernel/rtas.c: In function 'rtas_restart':
> > arch/powerpc/kernel/rtas.c:655:24: error: 'SYS_RESTART' undeclared (fir=
st use in this function)
> > arch/powerpc/kernel/rtas.c: In function 'rtas_power_off':
> > arch/powerpc/kernel/rtas.c:664:24: error: 'SYS_POWER_OFF' undeclared (f=
irst use in this function)
> > arch/powerpc/kernel/rtas.c: In function 'rtas_halt':
> > arch/powerpc/kernel/rtas.c:674:24: error: 'SYS_HALT' undeclared (first =
use in this function)
> >
> > Caused by commit ac050ff2a176 ("It is not necessary to share the same
> > notifier.h").
>=20
> I think the following patch will fix this.

Please find all the other files that need that include as well (there is
at least one more).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jul_2011_17_08_43_+1000_Af9PKRt3LOIo8huU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODXJ7AAoJEDMEi1NhKgbsI30IAJiGt53g2r/qzxCiCOfAAAUY
z01GoMuWbMFsm3yEREh2xnI08cYQj+AtcWHoKHeKU9w2l8iDOISW/DQw2irv3drR
opDcwl0pMNZREdo7/15p7FJTqJ3tlLndnDMq8rq0YFQSekTMQUuYt7Od9mLjFTh7
4i2qUUEToTq9P7mQ4Fuo0YGgCwDYcewbYoCaNOgAJU2AB5dxXeQBKEsYtr5iASHu
UMPnV/8Ybwls0loGKnnh1v5MH9eHmS0R0c2WSw7sinDvigmcM/P/YqO4M+2y+hFX
qdPGspvKjZXaGH5b+AUZldVcv5gM/bxrsR1Xcsllv7B7oDkhXyG/YvC4R2JKLzE=
=CV8c
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jul_2011_17_08_43_+1000_Af9PKRt3LOIo8huU--
