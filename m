Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1HZDeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 23:34:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55093 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab1HZDeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 23:34:01 -0400
Date: Fri, 26 Aug 2011 13:33:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Timur Tabi <timur@freescale.com>
Cc: <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] [v2] tty/powerpc: fix build break with ehv_bytechan.c
 on allyesconfig
Message-Id: <20110826133345.f76a4f6cee53925de9ec2567@canb.auug.org.au>
In-Reply-To: <1314295617-2953-1-git-send-email-timur@freescale.com>
References: <1314295617-2953-1-git-send-email-timur@freescale.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_13_33_45_+1000_fmwIfgQUypxploIx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_13_33_45_+1000_fmwIfgQUypxploIx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 25 Aug 2011 13:06:57 -0500 Timur Tabi <timur@freescale.com> wrote:
>
> The ePAPR hypervisor byte channel driver is supposed to work on all
> ePAPR-compliant embedded PowerPC systems, but it had a reference to the M=
SR_GS
> bit, which is available only on Book-E systems.
>=20
> Also fix a couple integer-to-pointer typecast problems.

I applied this to linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_13_33_45_+1000_fmwIfgQUypxploIx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVxQZAAoJEDMEi1NhKgbs8vAH/2VYdW0yglicLXlFDMcoAoma
pJEWnjspPeIEamtuc2OfKwUp79U6YYVNdkgKy6dy4wc//YccSaujLRugvOKtAfpU
6K6WLBi2ID6mLH/RvOy62fA6dATu1C3Wc2aCCZZkaKQ0XaY18VihuYSMWBkpuDxI
Hg3ieImG9n2m0NHa7l5Nx3ZpKvTZ5ovWgNfBnaNk0ecW6E/o8Fm5im7ARcvLar7Q
1/hEQVxP3Op/ojtPkeOWJuWgmlx3wknnUL3zwpG5mIoAyWJVVO5r66ksiDaf/TmI
lS9CJNj8Yec1yt3yeVG+ENbSQ2p4641pfa6U+efo1F4keTukRzlX7+KNN++NLG4=
=duXm
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_13_33_45_+1000_fmwIfgQUypxploIx--
