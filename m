Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1I2MnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:43:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43340 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1I2MnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:43:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mark Salter <msalter@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/24] C6X: New architecture
In-Reply-To: Your message of "Thu, 29 Sep 2011 08:21:58 EDT."
             <1317298919.2580.92.camel@deneb.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <22021.1317246541@turing-police.cc.vt.edu> <201109291233.24623.arnd@arndb.de>
            <1317298919.2580.92.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317300157_4421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Sep 2011 08:42:37 -0400
Message-ID: <60327.1317300157@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E8467D6.0079,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317300157_4421P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Sep 2011 08:21:58 EDT, Mark Salter said:

> One thing that we plan to push later is an XIP model where cores can share a
> single kernel text image but run with their own copies of data. So you end up
> with something like a loosely coupled multiprocessor system with some hardware
> support for multicore communication and peripheral sharing.

Ah, OK.  I eventually came across a mention in one of the patches of running
a separate instance of Linux on each core, whick left me even more mystified.
But the above clarifies it, thanks...

I wonder how many currently global variables will need to be moved to per_cpu
structures to make it work, and how intrusive that will end up.  Or is the plan
to have the boot loader simply plonk the entire .data/.bss in different locations
for each core?


--==_Exmh_1317300157_4421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOhGe9cC3lWbTT17ARAjxVAJ9BK60NbcVXSY506pqOWLd94GQz6QCgs58c
2poKcwjoj4HP1RBqkzd9Tp0=
=ms+8
-----END PGP SIGNATURE-----

--==_Exmh_1317300157_4421P--

