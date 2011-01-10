Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1AJEdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 23:33:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49369 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1AJEdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 23:33:01 -0500
Date: Mon, 10 Jan 2011 15:32:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Juerg Haefliger <juergh@gmail.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the hwmon-staging tree with the
 jdelvare-hwmon tree
Message-Id: <20110110153252.7b293aa0.sfr@canb.auug.org.au>
In-Reply-To: <20110110034638.GA28007@ericsson.com>
References: <20110110132057.bc5d54a0.sfr@canb.auug.org.au>
	<20110110034638.GA28007@ericsson.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Jan_2011_15_32_52_+1100_RlIFsY/Bciqg82yr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Jan_2011_15_32_52_+1100_RlIFsY/Bciqg82yr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Sun, 9 Jan 2011 19:46:38 -0800 Guenter Roeck <guenter.roeck@ericsson.com=
> wrote:
>
> thanks for the note. I suspected that would happen - sorry for the troubl=
e.
>=20
> Jean, do you want to take Joe's pr_fmt change from my tree and apply it t=
o yours,
> or should we just wait until the first of the trees was merged into Linus=
' tree ?
> If the latter, do you want to send your patches to Linus first, or should=
 I go first ?
> I am ready to go.

I wouldn't worry too much, Linus is cleverer me and will work it out.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Jan_2011_15_32_52_+1100_RlIFsY/Bciqg82yr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNKov0AAoJEDMEi1NhKgbsJn4H/2zPexnziV825nWrG7Gx3JoH
VIcl3ibNb5fCDiIDbRqsZboFoiTKcXsvTOBmJRqnHImLifFR+1qaJuhpJ4tYOb1i
Mup0/USCOtOiBeHTkQMIDbtzRJJCxxQPHGLSJcvI3jo6eaK4Hw/J4CFkB+gN1tQz
dYgw9hKXFIJ9WWY+tgxAomceEoB4zQZxKZ2xN/rvevNDcWXoweWb8Zb8w8REWqlP
JPNXOBricnmYh9vdcJxuVX5pycngRekLu0ShwBQi7+iaKt7ulPDIHApO+BplX5IL
7RqSxHyhYnmIDuVK5bMgOwCyhAz+LKcl+bh2vnPivWjNJoKL2nlfAX02uSmwJgY=
=DJrN
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Jan_2011_15_32_52_+1100_RlIFsY/Bciqg82yr--
