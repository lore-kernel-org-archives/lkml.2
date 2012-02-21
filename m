Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2BUKih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:38:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46160 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2BUKig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:38:36 -0500
Date: Tue, 21 Feb 2012 21:38:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: build failure in Linus' tree with gcc 4.4.3
Message-Id: <20120221213818.34410cc74de633cda0169819@canb.auug.org.au>
In-Reply-To: <1329818517.3639.29.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
	<20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
	<1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
	<1329818517.3639.29.camel@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Feb_2012_21_38_18_+1100_kFpHEhE4JPYLu8dH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Feb_2012_21_38_18_+1100_kFpHEhE4JPYLu8dH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Tue, 21 Feb 2012 10:01:57 +0000 Matt Fleming <matt.fleming@intel.com> wr=
ote:
>
> Looks like the segfault is caused by an unaligned access? How does this
> patch look?

I didn't try it, but it won't work.  PowerPC is big endian, the data you
are copying is little endian ....

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Feb_2012_21_38_18_+1100_kFpHEhE4JPYLu8dH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQ3QaAAoJEECxmPOUX5FEnIYP/jZ1hFHV1etAYvDGG4yJ6eLO
UkdTDxZ+uU7CCIkUHn3Dhr0pSFIePqPc94KLlLXYnYeh7z0TrO75/v8I/stryw14
1Ic/XiGrqXqqcp2DKZCh+/k3ohHbkhBD6p4mRZ+iQPHNacMJ6kFqKM7hvOQx8P/+
eSjo52VaNXqddBJ5r8/cduo0AmAhM9ZWhMS/mjU4c9qy2NSawY1pnrH0Ezi3h5vp
rXvXTm430EXkCRHKrWVaXEya3QqbHuGbQQQ/WjXa9QFvn0J36ScIkQjP6V79BX+r
ItSoUQXm6DUcw2yn6p1dPYphDsbRurnSRW284s4Ov7rPkE2jPi1pWDxW6WL5q87z
/rA+fbNykqul98tYIychBVr5SCBnaxiHxcQRpxcSV1dEw5LHAJqpOZTT+/TKLWws
i2LUb19Yg6UdpwfR+NySawAwWOuyux4mm2XKdDV78/zlBH2L3w9nTZfURIl7Cyb9
smGsD7f2J3cqbRm8iD1JveHv820Wr0J+xE8x+PGIjvj/Ok24gqKi/Sb0UxhGZbuM
Vtq27uyzGY83iFfP8yrnnqvZ4b9znrDQ8uZn7eGNRLtXELV6TwVMPib5y0/x0Wo6
+zmlS702XkiRnYBLtKa34p8bCRqWVpb+isB7G5PjUBFp5GzovY0Taj5tTb91eiEr
pO462zihNxoY3Bt0coTv
=kYsJ
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Feb_2012_21_38_18_+1100_kFpHEhE4JPYLu8dH--
