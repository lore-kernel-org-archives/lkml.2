Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1FNSXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:23:46 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44002 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1FNSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:23:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jean Sacren <sakiwit@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] boot: Enhance performance by eliminating unnecessary calls to printf()
In-Reply-To: Your message of "Sun, 12 Jun 2011 12:36:28 MDT."
             <20110612183627.GA12311@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20110606004038.GA28970@mail.gmail.com> <4DED0990.8090309@linux.intel.com>
            <20110612183627.GA12311@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308075820_2718P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Jun 2011 14:23:40 -0400
Message-ID: <55695.1308075820@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DF7A72C.01DA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308075820_2718P
Content-Type: text/plain; charset=us-ascii

On Sun, 12 Jun 2011 12:36:28 MDT, Jean Sacren said:

> Subject: [PATCH 1/1] boot: Enhance performance by eliminating unnecessary calls to printf()
> 
> Repeated calling to printf() for 13 times is a dire waste of CPU cycles.
> For performance, combine all those calls into one while source code
> formatting is preserved for readability.

*facepalm*

I defy anybody to find a *less* performance-critical piece of code to
micro-optimize. It doesn't even make a boot faster, it makes a kernel build
non-measurably faster.

If you wanted to make kernel builds faster, go look at Ingo's numbers regarding
the current #include mess - fixing *that* will be of more benefit than this...


--==_Exmh_1308075820_2718P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN96cscC3lWbTT17ARAnuiAKCPSWykhkJvedFKQf0po37U297MZACgreWq
YhrCamM155YlqU+oX4rTEKE=
=/pTQ
-----END PGP SIGNATURE-----

--==_Exmh_1308075820_2718P--

