Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1JIRik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 13:38:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43879 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1JIRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 13:38:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Robert Kubrick <robertkubrick@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 / RH 6.1 scheduler bloated
In-Reply-To: Your message of "Sun, 09 Oct 2011 10:26:22 EDT."
             <8AF29618-6746-484D-B773-AED31FBA714D@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <35C27021-40FC-4127-BC82-9F86FA9D624A@gmail.com> <1318140213.6216.40.camel@marge.simson.net>
            <8AF29618-6746-484D-B773-AED31FBA714D@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318181914_103142P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 09 Oct 2011 13:38:34 -0400
Message-ID: <109116.1318181914@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E91DC1D.0006,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318181914_103142P
Content-Type: text/plain; charset=us-ascii

On Sun, 09 Oct 2011 10:26:22 EDT, Robert Kubrick said:
> Will try this, but I have older kernel version running on the same  
> hardware, with the same boot parameters, and showing a more  
> reasonable 2us wakeup latency. Still high, but coming out of idle can  
> be slow as you say.
> But 10us??

My first guess is that earlier kernels were dropping into a lower sleep state
that only took 2us to wake up, but newer kernels go into a deeper sleep state
that takes longer to wake up from...

--==_Exmh_1318181914_103142P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOkdwacC3lWbTT17ARAq72AKC06jA/UByAuFyA1bHHQB/gKQFK9wCg+Mlu
PtqOPADCYnoCEr1c8TZwh28=
=opaH
-----END PGP SIGNATURE-----

--==_Exmh_1318181914_103142P--

