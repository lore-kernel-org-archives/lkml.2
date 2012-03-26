Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2CZDWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 23:22:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab2CZDWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 23:22:07 -0400
Date: Mon, 26 Mar 2012 14:21:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-next <linux-next@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jamie Lokier <jamie@shareable.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Mike Frysinger <vapier@gentoo.org>,
        Oleg Nesterov <oleg@redhat.com>, Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] -mm/linux-next: procfs: Mark thread stack correctly in
 proc/<pid>/maps
Message-Id: <20120326142141.57f76bc005cdb4c1656df83a@canb.auug.org.au>
In-Reply-To: <CAAHN_R1_DordNLDjBfWMHyMJ1yhgwiuQfPvtwQzUKpGMkrJ0jw@mail.gmail.com>
References: <4F57A3EC.7070101@gmail.com>
	<1331660076-32766-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120313131616.f66dbdad.akpm@linux-foundation.org>
	<CAAHN_R3mFzmtCey_0JEHp=EAGh1sb87szpsKD_JkFwwYLCnKug@mail.gmail.com>
	<CAP=VYLpUzuom-HUS-LYSuQmMZSRvC_Qjgyy9hnKqBowh-95YPQ@mail.gmail.com>
	<CAAHN_R1_DordNLDjBfWMHyMJ1yhgwiuQfPvtwQzUKpGMkrJ0jw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Mar_2012_14_21_41_+1100_/O3qS8hLz6qvR.=i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Mar_2012_14_21_41_+1100_/O3qS8hLz6qvR.=i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Siddhesh,

On Mon, 26 Mar 2012 08:32:35 +0530 Siddhesh Poyarekar <siddhesh.poyarekar@g=
mail.com> wrote:
>
> On Sun, Mar 25, 2012 at 11:35 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > Now it is:
> >
> > mm/nommu.o: In function `vm_is_stack':
> > nommu.c:(.text+0x2178): multiple definition of `vm_is_stack'
> > mm/util.o:util.c:(.text+0x2bc): first defined here
> > make[2]: *** [mm/built-in.o] Error 1
> >
> > http://kisskb.ellerman.id.au/kisskb/buildresult/5941188/
>=20
> Looks like the problem is because this patch got included in
> linux-next 2 days ago:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dcommi=
tdiff;h=3D47d1ab583408e5b8e900c5080aec9bbcf210df22

I will remove that patch today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Mar_2012_14_21_41_+1100_/O3qS8hLz6qvR.=i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPb+DFAAoJEECxmPOUX5FEa9wP/2LmAYwomiwL/+YGLqHmxcZi
IR4lbRBXY5jheMtxC2J1KdyddHc1KJ1VeHUiSGwa7uDgPi5ap6m6X4BNd+C0QRSA
HGCcu2VqDv9L2mBMPLiTE3y0ZRey7Krw9rIyvD3at+Fw+arncscfu6CoiD5Nv32q
g6YiVexmKFVs9rRBGWmB2JdNC6/nQNuyyfvIplw8nb49HzMMS0m+Vx0onMEeCYlF
N0LgrJI81hk8+eANyPihM9aNwZ56qox0OEl2Li9v880p2JyIYt2E3TAJQFLW6DUR
GW1uof4Yd2xO1JK83/puZZbHyPYe/q1m6Ahj9J6aOKZ1SNIypIYPhkVOu+ZeNB6T
RtNz5xRbTw/D4mTpeHYAAp23uJfRRs0rXKMGPIwf1MTd4BeP9Nbx7r11Eoi+yqng
/dKPX2cIMorkTIzAKRgsxYy7foK4w8SX6q2iDOZciaMeq0SusCdpBCVL5k/sx9jP
CZ52NtBwDjuK1l57DONhAwdmGs2LrNxxBXGdblWfryTas7wXIIz5Qj1s9O03qWuH
pYcOdX0jvPp2vgEC1wtvXe0g7ajr8DAjC3e+k4zFJlThBQrE+fj4PZbDkU9leFDL
y0gJUjixwnntNQFpoCwH76cr5u7KXqRYKxnBaiRwqk/OMESrFGmYCoYEhsEIyCh4
VpFa+qLndV9V3CxB2kVU
=0gXA
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Mar_2012_14_21_41_+1100_/O3qS8hLz6qvR.=i--
