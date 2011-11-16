Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab1KPAaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:30:03 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:33464 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab1KPAaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:30:01 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Joe Perches <joe@perches.com>
Cc: Huang Ying <ying.huang@intel.com>,
        William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Printk mulitple line message support
In-Reply-To: Your message of "Mon, 14 Nov 2011 17:18:03 PST."
             <1321319883.8944.7.camel@Joe-Laptop>
From: Valdis.Kletnieks@vt.edu
References: <1321253936.13860.35.camel@yhuang-dev> <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
            <1321319883.8944.7.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1321403394_2702P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Nov 2011 19:29:54 -0500
Message-ID: <21274.1321403394@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4EC30403.014B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1321403394_2702P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Nov 2011 17:18:03 PST, Joe Perches said:

> mp_start(&cookie)
> pr_<level>(fmt, ...);
> pr_mp_cont(&cookie, fmt, ...);
> pr_mp_cont(&cookie, fmt "\n", ...);
> mp_end(&cookie);

What should happen if buggy code returns before calling mp_end()?

--==_Exmh_1321403394_2702P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOwwQCcC3lWbTT17ARAvr3AJ0cSIsAX2cVtRxrhiFyZ1OYQ9OM9QCeIRdx
icvHl/E+aPqp4ao9VGHg65E=
=hwpw
-----END PGP SIGNATURE-----

--==_Exmh_1321403394_2702P--

