Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab1LOC1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:27:19 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50891 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1LOC1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:27:18 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Xi Wang <xi.wang@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: signedness bug in cma3000_thread_irq()
In-Reply-To: Your message of "Mon, 12 Dec 2011 01:49:26 EST."
             <1323672566-16738-1-git-send-email-xi.wang@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1323672566-16738-1-git-send-email-xi.wang@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1323916035_2907P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Dec 2011 21:27:15 -0500
Message-ID: <12775.1323916035@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4EE95B04.0102,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1323916035_2907P
Content-Type: text/plain; charset=us-ascii

On Mon, 12 Dec 2011 01:49:26 EST, Xi Wang said:
> The error check (intr_status < 0) didn't work because intr_status is
> a u8.  Change its type to signed int.
>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---
>  drivers/input/misc/cma3000_d0x.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c

That will fix the signed/unsigned issue.  However, was there a reason
the field was an 8-bit-wide to begin with?

--==_Exmh_1323916035_2907P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO6VsDcC3lWbTT17ARAn69AJ96UuKJDzCv61DL5GyNr1/V+n1LCgCgiFlq
lNcRNQJ1S3082GWov4TpFBk=
=f98b
-----END PGP SIGNATURE-----

--==_Exmh_1323916035_2907P--

