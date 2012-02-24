Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2BXMWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:22:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33042 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2BXMWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:22:36 -0500
Date: Fri, 24 Feb 2012 23:22:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: linux-next: build warning after merge of the libata tree
Message-Id: <20120224232212.caf992ef1200adb2b761890c@canb.auug.org.au>
In-Reply-To: <20120224151410.e245d7610a597504541858ad@canb.auug.org.au>
References: <20120213162740.9e3cb47a39da19ed89edea49@canb.auug.org.au>
	<20120224140814.c134151d30e3f32b36360d5d@canb.auug.org.au>
	<4F470CB3.2010800@garzik.org>
	<20120224151410.e245d7610a597504541858ad@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Feb_2012_23_22_12_+1100_fPLqCSALUqLU5ac."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Feb_2012_23_22_12_+1100_fPLqCSALUqLU5ac.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

On Fri, 24 Feb 2012 15:14:10 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 23 Feb 2012 23:06:11 -0500 Jeff Garzik <jeff@garzik.org> wrote:
> >
> > A build fix and oops fix were both just pushed out.
>=20
> Excellent, thanks.

Except the commits in the current version of the libata tree destined for
linux-next do not fix the warnings I was reporting where the "inline"
keyword is missing from several static function definitions in
drivers/ata/libata.h ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Feb_2012_23_22_12_+1100_fPLqCSALUqLU5ac.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPR4D0AAoJEECxmPOUX5FEp+UP/1Lgq2qaB+hOUdfKK8bGPSN6
JW3ypEF4hHB6BuKTYeAga8KjVhhjQAibjafK4Db1X0XmJXsT1YCh+tohO/8HEP91
L5mBIcDzUR+fdZBR/oCzdeQtoJrEusVCVE9DySh0bcElWECAL8l6G9+9IUua0jxv
7nyWUFYUTt335C4EBZJeyE+gevnUE/KEsgTT6ILSWszjDedsQZwAnfcM1uh6nDDG
f1FxrOdeVZDssAO7PItz2HJWXKlTs9BKlQRTIoKgAM7bNcuY5aklgo5i+ZITNE3B
sKED7n5QUs5dkUTzgQ5s0gGieVG731REieqfn36BF277jTAtlcmGiRUJgutxwAuD
i7BlwsTS4rvOfSJJMddX3smGBCKg0j+NHwrs4JAN9t/JLehqpIHuWOVIM5nbrA8/
wP2+qqvpeufGKadsLHjksVkcRPAjy+D2sddQbbBWW2HuaL2mSs4ULKvLcn1Kp+yH
5B89bfPrEeHFjJMbOV3UY+whSwgahfz8KQX8sjacSXaxdz1OJgN/e30hfUQ8qNGY
w1Vlv9s4NjnRHzZkbHOYft+krUVShJMf4a6ZDPtfj+IOtlujDCco/Okj6+3pBxNi
sEBHGso9VhtV0FJLzScYcr3qR4deVQfrGIDmgvnse9Sti4WEjDXGWaWNtpPl9e6U
wgBdERit9EiLOQRnvx/5
=WhoN
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Feb_2012_23_22_12_+1100_fPLqCSALUqLU5ac.--
