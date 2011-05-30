Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1E3FFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:05:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55143 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1E3FFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:05:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [PATCH 2/4] clk: Implement clk_set_rate
Date: Mon, 30 May 2011 01:05:08 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1305876469.326620.351525457111.2.gpush@pororo>
In-Reply-To: <1305876469.326620.351525457111.2.gpush@pororo>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14360417.VdBLknXpXf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105300105.10258.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14360417.VdBLknXpXf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday, May 20, 2011 03:27:49 Jeremy Kerr wrote:
>  int clk_set_rate(struct clk *clk, unsigned long rate)
>  {
> -	/* not yet implemented */
> -	return -ENOSYS;
> +	unsigned long parent_rate, new_rate;
> +	int ret;
> +
> +	if (!clk->ops->set_rate)
> +		return -ENOSYS;

i thought ENOSYS is only for syscalls.  shouldnt this be ENODEV or perhaps=
=20
EOPNOTSUPP ?
=2Dmike

--nextPart14360417.VdBLknXpXf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJN4yWGAAoJEEFjO5/oN/WB+eMP/RxjSuK5Z+UozT0X95+vU2OV
2LK//CmjY/FsGTn4Vdfi24LVMYIYB4wuIhUkMO6Ry+rb5bAtXE69rHEuroVcXV2V
Gw8oxpZD5SCrD3QTtOiBJ25d7w5rBDbd+kNm6nex0we3PMN2Ubf45FnBh0IkkN4D
dnV8z1EdAwHaxlQ8COoBO1zIDOQLYd6r86selmZdxhSHhooDw0CXx55WDIu6IddS
G5eFWd/N8J3vDZmCFi8aX2irLXF2XR9/jUaMUfYghFr1GqtSnfHwbbbm16C6TUqa
WDaG5aNvaFuoaeuq6dfWDXh82wDpi8xmHlyqppnZ6wah4+t0AzMKX70rcnF671Ll
sOYzRAAbhkMKzYfc1pFbCRzlKdiG8EPJaPfqBGBxVZ6KrJw1/QP9Av290HeMI63M
IWV++tjQ61U7B0zRlLBps6FrVtjzaD/PC8wE9FOHM+9V7uPYkTScITWUZUKAsjQR
Wcgig3TJqaQ3LxX9Qc+5TjvL13sxNeFKPE7hPZp1RFXPYCcw+rLIrytN89tySmnx
kxQXj40SHKQpYPmrx+wB7SZMlucr1yrI6FLsLBWAKXNQaX5v2Dxtr27z+YqJCkVI
TmUIPZn61pwV5x2ju4r/ysytww1mu0ubSgWogQvRXQV4HEBCC7Rgw7gmxsCKoj3E
pfccE4hA+3kMZ5xIaycd
=sDAA
-----END PGP SIGNATURE-----

--nextPart14360417.VdBLknXpXf--
