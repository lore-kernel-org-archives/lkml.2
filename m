Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2ASMVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:21:13 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:36795 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2ASMVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:21:10 -0500
Date: Thu, 19 Jan 2012 15:22:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] [media] ds3000: off by one in ds3000_read_snr()
Message-ID: <20120119122202.GJ3294@mwanda>
References: <20120117073021.GB11358@elgon.mountain>
 <4F16FC26.80306@bfs.de>
 <20120119093327.GI3356@mwanda>
 <4F17EFE1.3060804@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlxN1C6awaFNesUv"
Content-Disposition: inline
In-Reply-To: <4F17EFE1.3060804@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F180AAF.004E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlxN1C6awaFNesUv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 19, 2012 at 11:26:41AM +0100, walter harms wrote:
> >> perhaps it is more useful to do it in the check above ?
> >=20
> > It looks like the check is correct but we need to shift all the
> > values by one.  Again, I don't have this hardware, I'm just going by
> > the context.
> >=20
> I do not have the hardware either so this is pure theoretical.
>=20
> Access to the data field depends on the value of dvbs2_noise_reading/tmp
> even when the data are reasonable like 50/100 snr_reading would become 0
> and the index suddenly is -1.
>=20

It's a good point.  I will redo the patch.

regards,
dan carpenter


--UlxN1C6awaFNesUv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGArpAAoJEOnZkXI/YHqRwskP/j9aQf1pbxNH68xqOf+Cm1ze
gBOj1sjE8ErJ5eS5+OmL0NrN6+Brc8Hm32/Lq77yM0KrjrBnYtI5XeFKqppEKZUp
BJ9b8XypMNGGsv/Q83v/c/Fl2Bl0vnMxmelzvzZzMitcjfWuxUQLyJA6+kTlzMz/
Cdg9LreevLRRt+g0efGRrvdUqxUmtwgJEl8VXCsoVY1gAIl8yl4GY+RVPUYVHLbn
je9lTJKi1SjNhSY2v5bPptqkT777LAF4Wxpy0qw20ZJbuTMejrTN67F83nxWl45G
+rgUo59THtYlaZrgx0NFXq3YCPfu2TEM2IX1zz/3rwTJgI82Imyk2vJI+H5xmbmd
+w3SM29/wN4EPHk4eJ4CTDiv3Qq1+5+UdNpst38X4646H/PG9nQeMgzmgnVgo2Vn
AouSq8YFVVQpgLqFFBa3UgTIf7OfkQIf3W4vhEwNCrx4LzIpIHsLX0Qt6/0NJNtD
srNjoKir3XzXA6Q5OhdcMJmh26n3mRzrPnvRSGHQLCn26rR05EGmxxFyT5U75JV6
FyLnOxfps05KzAwllffrSXeAi+E3aKETI7ZlKLiBbNxGuszbi2qiu/Wh/sOPFM2I
0Fj7fQPdDIUtQHzJ0c5H+5v472Cl5Gy/IqrT6OCu7z7mzDllBfWYzwIe1U6+hKbd
SiJs0ZAA1RxMSuIr/Y+p
=QBye
-----END PGP SIGNATURE-----

--UlxN1C6awaFNesUv--
