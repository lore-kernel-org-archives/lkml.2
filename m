Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab0IBEvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 00:51:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47426 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0IBEvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 00:51:16 -0400
Date: Thu, 2 Sep 2010 14:51:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Micha?? Nazarewicz <m.nazarewicz@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-Id: <20100902145107.c0a84da7.sfr@canb.auug.org.au>
In-Reply-To: <20100902043254.GB30689@kroah.com>
References: <20100902135450.59d6b96a.sfr@canb.auug.org.au>
	<20100902043254.GB30689@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Sep_2010_14_51_07_+1000_hOQlfLEZXmv+uaxM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Sep_2010_14_51_07_+1000_hOQlfLEZXmv+uaxM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 1 Sep 2010 21:32:54 -0700 Greg KH <greg@kroah.com> wrote:
>
> Sorry about that, my build didn't catch this.  I'll fix it up tomorrow.

Actually the author of the patch should have caught it ... (unless you
have been hanging onto this patch since before v2.6.34-rc1 :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Sep_2010_14_51_07_+1000_hOQlfLEZXmv+uaxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMfy07AAoJEDMEi1NhKgbs5t8H/2OB39/njYXCuvCHQmn9rri8
Tq3pBhNm7dWyszv1b7WvgWJxvNfn0myRrDg0tDSGjEwyjfJE7Rik+iRExrWKTzdH
ipffwYeFgw9icctK8BER3jX9xubzTYLgiLFfmjqGMCaXgfLW5kIZWA58OI6UaAMy
x1GjY382mcXs+bfdYTMME8UfTDwpxg9w1tVqMnusvcVKC1dlE2+ql7XvbCj+tX4e
AZRO/JnpfegWzykd5obKvMr2V8ePq3d5CDXq1M3+EwGFde3cFz1l1Bzoy5L6GeXl
AQcfGMooUpIyZ5p+iQSrGMl9VtTJLLitk+dCarDcSphqlplM5HZm1mBTCL/9vmM=
=WrhK
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Sep_2010_14_51_07_+1000_hOQlfLEZXmv+uaxM--
