Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863Ab0KRXdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:33:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59668 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720Ab0KRXdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:33:07 -0500
Date: Fri, 19 Nov 2010 10:33:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 18
Message-Id: <20101119103300.243b17c8.sfr@canb.auug.org.au>
In-Reply-To: <4CE54562.9030603@panasas.com>
References: <20101118134256.fe132215.sfr@canb.auug.org.au>
	<4CE54562.9030603@panasas.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Nov_2010_10_33_00_+1100_QC1JR4QL57UBmiNz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Nov_2010_10_33_00_+1100_QC1JR4QL57UBmiNz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Thu, 18 Nov 2010 17:25:22 +0200 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> The uml build from:
>         http://kisskb.ellerman.id.au/kisskb/target/2979/
>=20
> is failing compilation like:
>   LD      .tmp_vmlinux1
> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/lib/gcc/i386-=
unknown-linux-gnu/4.2.3/../../../../i386-unknown-linux-gnu/bin/ld:arch/um/k=
ernel/vmlinux.lds:231: parse error
> collect2: ld returned 1 exit status
>   KSYM    .tmp_kallsyms1.S
> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/bin/i386-unkn=
own-linux-gnu-nm: '.tmp_vmlinux1': No such file
> No valid symbol.
> make[1]: *** [.tmp_kallsyms1.S] Error 1
> make: *** [sub-make] Error 2
> make failed, trying to bisect ..
>=20
> It looks like a build environment setup problem because it's fine here
> (for x86_64 at least.) Who is the person responsible for the above URL
> compilation please?

I am (at least partially) responsible for that build environment.

We only started getting that build failure with next-20101115 (it may
have been present before then but masked by other build failures), and
our build system hasn't changed in quite some time ...  In fact, before
next-20100915, the um i386 build used to succeed.

The build we are doing is 32 bit (not 64 bit).  We are in the process of
getting a newer tool chain, but I am not sure when that will happen.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Nov_2010_10_33_00_+1100_QC1JR4QL57UBmiNz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM5besAAoJEDMEi1NhKgbsgUcH/2S/OFXupKF6D6LOIN7s1vKK
ARiKGIxWDZXozjdPANM+UIfep1fwfc7/2zhfFb+Zg7fFUcDC2clXeL4xcICNB1BS
OuT8s1RzkpEQzFkj9LnNrOOlMCzS8o2B/HqNi+RKcpXg3Ts1syhaF3SEUqrDbPD3
4nXAUvbi0YKRKbySGTVisOY4KESfdwjfSKlVTpOFjwqDUXIkuXXpbQSs0jeL4U2Y
FzuDAXgx+97RQPNu0vMQrxn1GnDmSumEFW0XjPgkUvp0TbBYl2oNA0ZzWy8BUyD3
2UhKEHMncWFZTPXfcBDcezW8pZTFZONy0VOo4guZIvqy7A5hPHtNzlmxf+mz6+E=
=dFVr
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Nov_2010_10_33_00_+1100_QC1JR4QL57UBmiNz--
