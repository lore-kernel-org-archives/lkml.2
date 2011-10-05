Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935527Ab1JEXBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 19:01:36 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41220 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935484Ab1JEXBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 19:01:34 -0400
Date: Thu, 6 Oct 2011 10:01:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: new location for writeback-for-next
Message-Id: <20111006100125.c73e2de988eab6c14773ef6e@canb.auug.org.au>
In-Reply-To: <20111005151546.GA5472@localhost>
References: <20111005151546.GA5472@localhost>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_10_01_25_+1100_0Ga/ZR.8M2mtB/Gf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_10_01_25_+1100_0Ga/ZR.8M2mtB/Gf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 5 Oct 2011 23:15:46 +0800 Wu Fengguang <fengguang.wu@intel.com> wro=
te:
>
> Since the kernel.org git tree is still not accessible, would you pull
> from this tree instead of the old writeback.git?
>=20
>         git://github.com/fengguang/linux.git  writeback-for-next

I have switched to that from today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Oct_2011_10_01_25_+1100_0Ga/ZR.8M2mtB/Gf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjOHFAAoJEECxmPOUX5FE+J4QAJfHVzrO+1/Pa5XG0EoTbzUn
QWxEGuu56SVeAmffdydRCX106GVAV6sc4wi53fgi8H1CymwjvuD5VYlySbJLLkU5
TAlHh5DSn3C+0SKUXNahJyGdvNXeHM6SeMGVX0rr75JFXtX2ikB7lt+sUza4gDK7
n+nvf0MKjNNV4mx+Bwjp3Cd+oOcClSxJLoWi3QLNNob69oDgqvtnrbzgUk/cndTa
zv3OmqIYM5gFZzBmj5h/d4pa3CtV6wZxyWZ2jy44GJ7zdKgzyHrLlj+7aCIYXW9X
79Lhm7lpkFOAjw/Hy+lDZ4h/auVZvgwJE/et9jUzMgKrzthUSvsF6wguSq/VNZ3s
pwzuPUarkYYIaHYj05/o+Ztd5Dx3/onNA3UP4E9v1HxTbLK7ozitrPTzsvWq1/l5
Obqc5h1Lz56+287ub0HnFRNAbKOipyb2YIwSSDa7DDdBufAfe1Lg1RdcCyL2oSgj
oFIJ7f46XOLG3Y72nyj62dVACjiEhlE6DDzp6wat9Tas26FrBeExnwrhhLvdIzYV
m+Chg23oOFjVp8yqiUi9GoEmKucp1er9t1Y40HF9ZRGp0ghcylCyeliGa0dPrtwD
zX++sgRzkvpOyNieAYS5ndCUzup2+JlOCMb/UTsD27cj0eTt18unnVuO68dV2Nqo
M+ytRhTSSgjl0k3ShUd5
=nt7Y
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_10_01_25_+1100_0Ga/ZR.8M2mtB/Gf--
