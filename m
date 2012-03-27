Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2C0IaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:30:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:42441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab2C0IaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="122098261"
Message-ID: <1332837188.31549.14.camel@sauron.fi.intel.com>
Subject: Re: [patch] Add cryptographic functionality when a key is passed to
 the compress / decompress functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Tue, 27 Mar 2012 11:33:08 +0300
In-Reply-To: <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	    <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
	   <1330531826.3545.128.camel@sauron.fi.intel.com>
	   <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
	  <1332511796.18717.72.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>
	 <1332521515.22278.2.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gzZ1T2oxsNFNO5R/zIE5"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gzZ1T2oxsNFNO5R/zIE5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I guess you'll need to amend this patch if you change the previous one.
Also 2 nit-picks.

On Sun, 2012-03-25 at 23:38 +0200, Joel Reardon wrote:
> +	if (err) {
> +		ubifs_err("setkey() failed  flags=3D%x",
Please, use %#x instead.
> +			  crypto_blkcipher_get_flags(tfm));
> +	return err;
> +	}

Indentation.


> +	if (key) {
> +		u8 iv[UBIFS_CRYPTO_KEYSIZE];
> +		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);

Please to the same convention we use globally in UBIFS - put a blank
like between "iv" declaration and the "memset" invocation..

--=20
Best Regards,
Artem Bityutskiy

--=-gzZ1T2oxsNFNO5R/zIE5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPcXtEAAoJECmIfjd9wqK0WCYP/3Lf+/iKaxxKVC60iQlmrYtP
NRwEegw10g9fatk7l/MDULtRQ1BIzbiJ65Td2JVvLvONzrTM2NGSwUQG6GzHhsW9
7nt2MLKQKPGUwZIGofL6eU6hFuTQcloTGwrGUy7naSOoknGZ3SS50t2BcCtC9kq7
gYN66jajxvc4gjhQ+pavYF7QXA7iOmjw8LgYdnJVj+lERLk+mjP05Q9jszI4X/3u
Sh/AD0Im6VhbGC2+kRh/8a7FbSTKlmc7VTzBe7BpF2jv8ub8BNUEth2RtPxnykbJ
Rgx4ESz0K0OVhrWzS6I3IR1NMUM8E8JX/KYn7DaiO8weOmn0tQCTDlU1vQIvb2JC
vOtgF1IAwtETARBq0lDinVih1uOIcqvKGNzVs+0e9BVvdDYBgZnwWojpWZl3KQDV
zUzbqr316L5B1sQnHnhsnDtoma4suTjZ4k1ZE3p+BnQZTjpOHVV2b1yYNKi4dwF2
eaiM2bIItflwJXoKe4tTfopMLclQupGIEA0Mw1lwC8d5v+Ch5IP60Vp2uHZqhPcX
+4Pkuoft11u0sbrn2y/vesu/usERKb2sWayTQO5Y5uu2gzf0ZVArIR4MvYDyIi6Q
pZR93qGS+d0AtYLZpfmlaxwwwOmHQHYQGoDnW8EzFmuc289QcTJ0ILzILPotvby2
NO/XIeMmFSQK9j76G7cE
=dCSy
-----END PGP SIGNATURE-----

--=-gzZ1T2oxsNFNO5R/zIE5--

