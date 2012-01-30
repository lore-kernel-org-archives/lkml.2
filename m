Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2A3Nrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:47:48 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:62764 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2A3Nrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:47:47 -0500
Date: Mon, 30 Jan 2012 16:49:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysctl: register only tables of sysctl files
Message-ID: <20120130134918.GG3356@mwanda>
References: <20120130133933.GA5926@elgon.mountain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hy6Wd/+xmQCqA1QQ"
Content-Disposition: inline
In-Reply-To: <20120130133933.GA5926@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F269F83.008B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hy6Wd/+xmQCqA1QQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2012 at 04:39:33PM +0300, Dan Carpenter wrote:
> +       /* Register everything except a directory full of subdirectories */
> +       if (nr_files || !nr_dirs) {

Crap... Forget about this.  For some reason I missed that his was an
OR, not an AND.  Sorry for the noise.

regards,
dan carpenter


--Hy6Wd/+xmQCqA1QQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJp/dAAoJEOnZkXI/YHqRuGEP/R0aDozKsBnDX4nQb7TOxg1T
qo9BSJp9ZKY1dYAMBPaU621/f//JOCHocKMWsgYtPCuJYgY1Y8x3GWRFFQEgRARW
t0lVzvbUqcOS4BO1W4NU8eTz0Avk8a06yBSQd6DQ0ij3C59t1Ch/MTdRHmJ7MneG
LoOdgS9YvZB8DutpBQFdmoh72t+AA8a/vl57Zzvx5/6k5g7KMEIGcyJeG2a2jk6+
r2di1W1bi0rqAnHu0sUuwWmCfj8Tusbyp2MVrICKGyQhvrVUPLR7ubggOAo1dM3u
yAHgSQg6nYEWddirEQBH2xgv7jIeuDl9deSl/wE+HcAr2U1ijg6Rz6CPvrKXvDLr
W2qtI99hc7piIktoBb32dg/K5iR0sEXE65c5I7jl8ouwDwf+mysbZCb5BhoAjhcu
gWhIrdAjYD2osJneCzyHKEQfm+g5+FFqs86ABG4SZT22H53kwvzWYIk7ka8niUsX
8EVFPDe9b4Nu8CavCTBEvT30QkwC44j6XhzoOnhj/XXl6HFfiLatCg5sG3kI7d+v
Tj82Rctlu03/W6Jlgd1TDnjV9zij42A52EpiZIGZQ7r2u0LBIHynFeoPP28oVUzi
TB8dt3xY/2gobBXR3q7p46TFOmyjZWqKW+Af/CqpwYRxGAnXb83oyxIznW+kjs33
STHTEPgb0riYvwOrVp2+
=zu1c
-----END PGP SIGNATURE-----

--Hy6Wd/+xmQCqA1QQ--
