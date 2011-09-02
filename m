Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1IBTyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:54:03 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50096 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab1IBTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:54:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: George Shuklin <george.shuklin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: si_swapinfo export
In-Reply-To: Your message of "Fri, 02 Sep 2011 19:41:29 +0400."
             <1314978089.11870.2.camel@mabase>
From: Valdis.Kletnieks@vt.edu
References: <1314978089.11870.2.camel@mabase>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314993238_2623P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Sep 2011 15:53:58 -0400
Message-ID: <3187.1314993238@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E613457.003F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314993238_2623P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Sep 2011 19:41:29 +0400, George Shuklin said:
> Good day.
> 
> Why si_swapinfo (from include/linux/swap.h) is not marked as
> EXPORT_SYMBOL_GPL? It's kinda hard to gain information about memory in
> module. 

Use case?  What information exactly are you trying to get in the module, and
equally important, why?  More likely, what you *actually* want isn't the
information, it's a new API (or using an existing one you didn't even know was
there) :)


--==_Exmh_1314993238_2623P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOYTRWcC3lWbTT17ARAmVfAKDp49+0OomiA9UJ7ZO6i2lj4kl8oQCfW/sB
hTTMDiOYtLv2ZIVHXJHFMSg=
=5WQ2
-----END PGP SIGNATURE-----

--==_Exmh_1314993238_2623P--

