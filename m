Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161279Ab2COTbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:31:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25988 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2COTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:31:50 -0400
Date: Thu, 15 Mar 2012 22:34:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Miller <amiller@amilx.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: rtl8187se: r8180_dm.c: Fix comments
Message-ID: <20120315193405.GE3163@mwanda>
References: <1331838321-18453-1-git-send-email-amiller@amilx.com>
 <1331838321-18453-6-git-send-email-amiller@amilx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
Content-Disposition: inline
In-Reply-To: <1331838321-18453-6-git-send-email-amiller@amilx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F6243A2.005B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 15, 2012 at 03:05:21PM -0400, Andrew Miller wrote:
> -//+by amy 080312
> +/*{by amy 080312 */
      ^^^^^^^^^^^^^
Just remove these comments.  We use version control to see who is
doing what.

> =20
> -	//printk("----> DoTxHighPower()\n");
> +	/* printk("----> DoTxHighPower()\n"); */
> =20

Also this dead debugging code can be deleted.  There was a bunch of
it.

regards,
dan carpenter

--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYkQsAAoJEOnZkXI/YHqRlogP/3UGhb36wg5+rIPTOkefDcQL
ZxLZxMZsNDJuov5wmwRkYmnrEtZ73rXo953vt1VrY5o54NJ6E6vG65R/8jX/Tg2G
S8Myvb/uLaO+3p9c3V+beHb+xKWtux5+8I/TpK9H1K1+6o1LUbriCO7iZWOb0C5l
pjeGBqtkVgoAY5BwUueq7tDXZ1jPMcniJsgPaY8lo7Q+N5HUS8dl0AymtRaPW9QR
l4ZbjxFYhYzmpceOrsnr3/wVal2VBOT3ybOW/+W/ccPYMG05IA3A5RvqGx0SRi5b
GIce/6ruu6DN7Q+svwbT92KEN/FCZtPK8u6wMZe/rz7TUVAr2b+Rf9cawPnaSRfD
NY25Ij3qLg4LKUQE9Nd8XKZTvrjQDgrOLe/Y0Po4OZ2dGGxVCxB2Ui4FwJz/p/Vh
rxRSbIPiCHvt91pW1P51/X+lq7gIjTg9ir8mJEkeMbSPCPWNO3EpMyllQBnq9ZFR
f0IsM2ZbT0V/pFog2ED8mNK+05Z26r1N/h1PXmU1s5ZjFMf11WgSHWkvta1CMG/5
tCOX0bnIZMMf7Mqi0L7RtATaNloBXNZ6fCyMyGaV1yTk2Coux6W/jrJ0fs4F9cc2
6jR+vihmdKY0b5Nt/EewNCmmCME84f5pQR+sInFEW1qNV8mKw7ib8/7uTH4yPY9/
HHn9jHbRaaeN1dUk4ahe
=JWcj
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--
