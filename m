Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1H2GRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 02:17:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1H2GRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 02:17:35 -0400
Date: Mon, 29 Aug 2011 16:17:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Trond.Myklebust@netapp.com
Subject: Re: undefined reference to `sys_nfsservctl'
Message-Id: <20110829161726.c980a80258fe714db49b425b@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.01.1108282138020.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1108282138020.9183@trent.utfs.org>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Aug_2011_16_17_26_+1000_bX2rX3gsH_/ONG8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Aug_2011_16_17_26_+1000_bX2rX3gsH_/ONG8D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christian,

On Sun, 28 Aug 2011 21:44:50 -0700 (PDT) Christian Kujau <lists@nerdbynatur=
e.de> wrote:
>
> When trying to compile 3.1-rc3 (git -c11a7e2), this happens after MODPOST:
>=20
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> (.text+0x5be0): undefined reference to `sys_nfsservctl'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

I posted a patch to Linus earlier today (subject of lkml message:
"linux-next: build failure in Linus' tree").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Aug_2011_16_17_26_+1000_bX2rX3gsH_/ONG8D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOWy72AAoJEDMEi1NhKgbsMO0H/0d+chFbP6e12qMX8mZFERVc
+1i/hMLWD9O0SW1Fn3GQLwwVozvigmfHTOdGoBuGTDA1uQE1me1Ar797FFzttsmB
cRX7LtHiKV9a4ZwXLewhhL2TVi4mPdwHw1nSqUNm8m8bXUcYeHgwM4YsPAO5p0St
lplLX2rRPUcpBz5PduamIQ9/j723vfCXIoGNAHjLYWBnYjIjj+dZ3WDvSApxHOBL
zxeSn6gFiAKVa25gFE7u3GKCZCxj93r9SCnQR+I2L/Qk4JOI/K5YQ7YKfVBYrl0+
oWvvs1uXKgk+3BnSLgI1vg9IJ49hSSn7vbIzXukVeueg1b8Oz2UXKCfhLN2YJ5k=
=nG4/
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Aug_2011_16_17_26_+1000_bX2rX3gsH_/ONG8D--
