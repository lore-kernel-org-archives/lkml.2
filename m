Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966111Ab2EORd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:33:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39091 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966052Ab2EORd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:33:28 -0400
Date: Tue, 15 May 2012 18:33:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: da903x: Convert to
 regulator_list_voltage_linear()
Message-ID: <20120515173321.GB4140@opensource.wolfsonmicro.com>
References: <1337047463.26683.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1337047463.26683.1.camel@phoenix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 15, 2012 at 10:04:23AM +0800, Axel Lin wrote:
> Use regulator_list_voltage_linear() to replace da903x_list_voltage().

Applied both, thanks.

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPspNSAAoJEBus8iNuMP3diX8QAIt1jRTOKvyp6IB4nKq/Tzq4
5/WcnNx+nYnvhEhkBRhPBBLdOvFrdUY7A15UlUyCoDS+bqou3fN0fz79sn7H5EGo
g5G6fJY4v67COoTiW5+ilK0ncjPwES8VPIEQRIHNm/NWpakE1w7OUfh09dhcBWzL
TCiAzOXlOL6rmsuQ4ydlPzc8ZHkkmmSATq1VI+RFI7mMH01IQC7UkLwk2H0Uo861
g7KzQEvLX6xETkJEzO1oQVmwVFBGV+3Q8ow5IfPqwTx76YOnheREM+FoaFqYwK+U
h8h7sTbQmjRaOjqyAxt4q+gdhw5HTZe7aLmFYsMiWLRWerzV7Wwi5YmmqOB8L3AR
LRjjfv0YrVnH1neW53YGYvDytWx0gkzEK2KzP3WJmd4nzy25ZVr0vHvRohsPX7FL
4yp1GDJquwJF6tyl/4P2eCgEskck3DKjNMt3Y6dpN5pT1DmQ6psX3sEVhIgBevrr
+ccugivwSwAvBpsf3NJWs2w4VetLxk+BL6IO26C/xK2psRbYpvToHf5LcOHVHGEd
Rs0XekrLgI/WuYTDfa+oFKEqmf8yWxm4ubE8ERAlZA9zfWHxWzjX88D6ICxh67vC
AlDCr2vQgbK2cPvzmlolFp4aUBQIWFFmrlvlLK64wtAYccuGP7rs4Zw2GeM75Nk1
Y8aju4NreLdeZFBVqykg
=/k/8
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
