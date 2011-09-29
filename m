Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1I2Apf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:45:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37116 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1I2Ape (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:45:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: Your message of "Wed, 28 Sep 2011 13:31:45 PDT."
             <1317241905.16137.516.camel@nimitz>
From: Valdis.Kletnieks@vt.edu
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home> <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com> <alpine.DEB.2.00.1109271546320.13797@router.home>
            <1317241905.16137.516.camel@nimitz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317257024_2944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Sep 2011 20:43:44 -0400
Message-ID: <30918.1317257024@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E83BF43.009C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317257024_2944P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Sep 2011 13:31:45 PDT, Dave Hansen said:

> We could also just _effectively_ make it output in MB:
> 
> 	foo = foo & ~(1<<20)
> 
> or align-up.

I think we want align-up here, there's a bunch of fields that code probably
expects to be non-zero on a system that's finished booting...

> We could also give the imprecise numbers to unprivileged
> users and let privileged ones see the page-level ones.

That also sounds like a good idea.

--==_Exmh_1317257024_2944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOg79AcC3lWbTT17ARAmqiAJ9V4cm5nViiDdSy1BfRSTUxIHFRvwCfScmt
aoEo4KjbCZekOI0n/qkZOTc=
=CRrZ
-----END PGP SIGNATURE-----

--==_Exmh_1317257024_2944P--

