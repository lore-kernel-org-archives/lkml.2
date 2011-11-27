Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1K0LZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:25:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:58319 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1K0LZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:25:56 -0500
Date: Sun, 27 Nov 2011 14:25:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Xi Wang <xi.wang@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>, Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <gregory.dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH v3] comedi: integer overflow in do_insnlist_ioctl()
Message-ID: <20111127112539.GB21128@mwanda>
References: <20111123061355.GA3295@mwanda>
 <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
 <20111123145020.GA3258@mwanda>
 <4ECD1A01.3060503@mev.co.uk>
 <4ECD6873.7080106@metafoo.de>
 <20111123215111.GD3258@mwanda>
 <97189E06-26D8-4CF9-B325-06403FB1C42C@gmail.com>
 <20111125072550.GK3195@mwanda>
 <4ED00CCB.80604@gmail.com>
 <20111127025252.GA29073@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20111127025252.GA29073@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ED21E2D.0052,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 26, 2011 at 06:52:52PM -0800, Greg KH wrote:
> On Fri, Nov 25, 2011 at 04:46:51PM -0500, Xi Wang wrote:
> > There is a potential integer overflow in do_insnlist_ioctl() if
> > userspace passes in a large insnlist.n_insns.  The call to kmalloc()
> > would allocate a small buffer, leading to a memory corruption.
> >=20
> > The bug was reported by Dan Carpenter <dan.carpenter@oracle.com>
> > and Haogang Chen <haogangchen@gmail.com>.  The patch was suggested by
> > Ian Abbott <abbotti@mev.co.uk> and Lars-Peter Clausen <lars@metafoo.de>.
> >=20
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
>=20
> Hm, I already applied Dan's previous patch, what should I do with this
> one now?  Revert Dan's and apply this one, or apply both of them, or
> something else?

Sorry for that, I should have replied to my patch when I learned that
it had a problem.

Please, revert mine and apply Xi Wang's.

regards,
dan carpenter


--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO0h4yAAoJEOnZkXI/YHqRBnoP/ihBW26MD942mRLdAtgdfrAu
n4j59gBC9TmGzz+Rq6oX8zOPpWv1N1ITXRj9aEeYogRV5Y8SrdpCa7Ib3M8oLRPs
HUsSAEWHPW7trEyu1kQKnbS0fEds7hOxOL4vMoDfsWwSPlsVbALdGd56ukB6qaqw
/2sJa/OUmus3pFtpPkK/eI45PJ9ZjAzWmSJAddMSPXgkVAPv4ix2vOiJ603gShuw
VnpvNxX7hNgcutQ1UteWtbvFy+H77xoV8c/Mc8KjEE8heY3tXZTefFd41+UGXrPf
IchYJIcHT2FA59v2Ou8Csbp6FzutuBhE5aP1iMrNAeENQPocJkv/3T30Jyy7cmAY
edD84f5S+4pZtBkmt+S4P+ucQau5R5M02q9qQCbj9Ov3rCuX0Se8IxjIpr1qlDax
+pscPnsBmLSj2kpFvA9g11b5VXjIx4rgl+x2FcfkmyIoePAzPqzX8MexT7Y05oSB
01L4x1jzuMutFt6SC6W59uzWGuijCjLoHJqj9q7d7ltaZa1RFgvqokjGMvkW9In6
FAsKQAqFIXywFKya25nZwENN6/A3cVfzOZSVEupL9G6avo5p+C89gGykXH7zqCYI
blJKvJzev5HVupOoMKVQoKYdV+HdwaQhDEZ2DT43Fej+rmESiSWLbhEqVuCAnWtC
GZpozYcxUeeRonVyU+xE
=zca1
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
