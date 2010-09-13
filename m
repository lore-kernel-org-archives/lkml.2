Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0IMPNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:13:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36758 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0IMPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:13:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
In-Reply-To: Your message of "Mon, 13 Sep 2010 12:07:19 +0200."
             <20100913100719.GA3903@pema>
From: Valdis.Kletnieks@vt.edu
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema> <4C76D9A0.2010907@zytor.com> <20100829205929.GA3309@pema>
            <20100913100719.GA3903@pema>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284390647_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Sep 2010 11:10:47 -0400
Message-ID: <54870.1284390647@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4C8E3EF7.01A7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284390647_4646P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Sep 2010 12:07:19 +0200, Sh=E9rab said:

> +static int iris_init(void)
> +=7B
> +	unsigned char status =3D inb(IRIS_GIO_INPUT);
> +	if (status =3D=3D IRIS_GIO_NODEV) =7B
> +		printk(KERN_ERR =22This machine does not seem to be an Iris. Power_o=
ff handler not installed.=5Cn=22);
> +		return -ENODEV;
> +	=7D

Is it actually safe to assume that this will do the right thing on a mach=
ine that
is a non-Iris that has something *else* at that I/O  address?  Any furthe=
r sanity
checking we can do?  (For that matter, are there machines that will get i=
ndigestion
at this sort of unexpected inb() access?)

--==_Exmh_1284390647_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMjj73cC3lWbTT17ARAncNAJwKn8hHuT8exgagnjRvYsIiinOlTgCfdayp
NyRmoz/jwix89FzfhvWPNPE=
=UaoW
-----END PGP SIGNATURE-----

--==_Exmh_1284390647_4646P--

