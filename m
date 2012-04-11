Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2DKJme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:42:34 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:49854 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754255Ab2DKJmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:42:32 -0400
Date: Wed, 11 Apr 2012 12:41:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michael BRIGHT <mjbrightfr@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael BRIGHT <mjbrightfr+git-kernel@gmail.com>
Subject: Re: [PATCH 1/1] USB: remove compile warning on gadget/inode.c
Message-ID: <20120411094143.GL12064@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1332438172-20215-1-git-send-email-mjbrightfr+git-kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iAzLNm1y1mIRgolD"
Content-Disposition: inline
In-Reply-To: <1332438172-20215-1-git-send-email-mjbrightfr+git-kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iAzLNm1y1mIRgolD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 22, 2012 at 06:42:52PM +0100, Michael BRIGHT wrote:
> Removed unused "restart:" label, which was causing compiler warning.
>=20
> Signed-off-by: Michael BRIGHT <mjbrightfr+git-kernel@gmail.com>

applied, thanks

--=20
balbi

--iAzLNm1y1mIRgolD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhVHXAAoJEIaOsuA1yqREvKAP/1xnHyvFuDQ0hmrWrEqYB6Yu
0uJ22lnfhPfQAhZs6VKn7cvfZdAz7ueWhd1rD3xHSog6GE12Ug/KD3kQtTRnV3/3
tH2x+YJihsqhklBC1BquBieUxdWBsZDKfTruyPiSCXGP4QVY7NZ8oFkjsOIOalsA
ucO3x/wPI3jwRrJMiQho+htUV0WwCQg7vKN4Aqhkj0oi+iLIoHiFFQpLQGpJGOa2
VyjAFnQMTcn+QIP0C3tg0CorOeYDwDbvdOxvHBJXKK6SkFTaLlaBCz99ULngGzRN
+Cc/pknaP7oJbgdeEMQnUMmiCwgqeYwB+slasOIX6pMHSm9dfpHNQqQ2P3KZkm29
RaNxhPPJ6eObT0UqXiBkPys0jC1pbzqw9P06ffvv7OYWOAFsGkK+qsDiSwyQJ0/5
3s6xCgMmyr0XSDwVVfEQaovVi/btg8sWD5rTpf6E9R5M0Y2ckVGFtrlaYgN6AAmV
Pm2WSkje1cALnwJFrptE7NBOA8ECYWtYtQjfdPpBaSNgwnWXh6HAlhHmQpH/+FTp
tjOp7Qs75FoPZNVsUp+0LtOt9eZxBOEHNZK6GcNsKGzC/Fs5ZcfCCrLNkUT0HQae
VflsRzYhRl3jgKYl2v3igbkMlxswVavuoqkOX9G0HDwFA97JYwUtDTZpuR0GN9k6
zmdJ+HGKpgfg6aDa1gEk
=DoJ7
-----END PGP SIGNATURE-----

--iAzLNm1y1mIRgolD--
