Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1IPRFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:05:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54919 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1IPRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:05:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sys_poll(): fix function definition/negative timeout values
In-Reply-To: Your message of "Thu, 15 Sep 2011 14:45:56 +0200."
             <1316090761.6545.70.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1316090761.6545.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316192684_55056P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Sep 2011 13:04:44 -0400
Message-ID: <57087.1316192684@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A010208.4E7381AE.0007,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316192684_55056P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Sep 2011 14:45:56 +0200, Thomas Meyer said:
> Fix negative timeout values for x86 userland on x86_64 kernels.
> Align sys_poll() definition to glibc's definition.

> -		long, timeout_msecs)
> +		int, timeout_msecs)

Is this going to surprise a non-glibc userspace on any platforms?

--==_Exmh_1316192684_55056P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOc4GscC3lWbTT17ARAoNtAKCKgzUYgu1qBF95dBuGZIWdbQ4M5gCePY+T
nGAIDgL0VmxhX6n/g/QrUJQ=
=JIKd
-----END PGP SIGNATURE-----

--==_Exmh_1316192684_55056P--

