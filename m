Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2KFIPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:15:20 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:33054 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2KFIPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:15:18 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: Your message of "Tue, 06 Nov 2012 03:12:19 +0000."
             <20121106031219.GB24235@srcf.ucam.org>
From: Valdis.Kletnieks@vt.edu
References: <20121104042802.GA11295@srcf.ucam.org> <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com> <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org> <87hap3zbw7.fsf@xmission.com>
            <20121106031219.GB24235@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1352189632_2044P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Nov 2012 03:13:52 -0500
Message-ID: <98455.1352189632@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.5098C6C4.0037,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1352189632_2044P
Content-Type: text/plain; charset=us-ascii

On Tue, 06 Nov 2012 03:12:19 +0000, Matthew Garrett said:
> On Mon, Nov 05, 2012 at 06:46:32PM -0800, Eric W. Biederman wrote:
> > You have it backwards.  The conclusion here is that having a case where
> > a non-interactive install is possible is not a given.
>
> I deal with customers who perform non-interactive installs. The fact
> that you don't care about that use case is entirely irrelevant to me,
> because you're not the person that I am obliged to satisfy.

You *do* realize that the fact you have some set of customers who
perform non-interactive installs does *not* imply that being able to do
so is a given, right?  The fact it is available and doable for your customers
does *not* mean it's available and doable in general.

There's a big difference between "the design has to deal with the fact that
some customers can do this on some subsets of hardware" and "the design
is free to assume that this is doable".

--==_Exmh_1352189632_2044P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUJjGwAdmEQWDXROgAQIIhg/9Gl10cFvr5Y9fk2RvoxuquXQpuFnOgVYj
LcUBn6wFIhTcce8bsxaKPYK48eofDzLmDC+kLSNsxFoP3tkDlwie7nNCCbd6B/RG
po/HbFg1tk0Axsi5CdmPtmHq2NtvZcGbdGlEvSBVh6XybEzJnN2pfXuc6272Mrvf
zLEhyopFunSvqLupymPwNNfUGuZCWrPXb90L9IeBWRhPFQJcBKQ+Q/3khkZB6hvq
zcfA77tBQa7/04NeOW8UNHvpmTdqmoAkMab+ge10W+jfrtgErxYbEjCDuBzMYnKe
aMZr5hjvt0Wcicl2uQSAR5wSGRRMr6G2j0jYrh1UCh9CCXZPvPMv0dg0tsPoz1b7
1cjTbTzj297F/o7ymICwQGrhDqxZkAekRdDBftF0sCS9eguiN5LnU4xLB+lQaq7O
gc4XN7GeW3ZUyXiNWBVZ6uGuvN1QVrgNuAW57V+ETA6acE07DvpILt3XQ4El44HP
4+/mvlD5qG4G7XvOCHSNzY8UrNq1k4HHc0DnwsNXKHoB55K2Rh3DysL8BP4dY25f
HHVmXgQ5Yoe/UnLpQGoaaL/Rn+kcYS+geMq0jAmVoJHB0ALUMD3J0bEy5Rw0HOM4
rEOxpm1/Ujaf2J7x1lVxNe3p0mf1rigGnQr58JfjBPSU0/glu2t6/6+bsxWzyV3f
+NU4hYuxAec=
=LLis
-----END PGP SIGNATURE-----

--==_Exmh_1352189632_2044P--

