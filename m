Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab1JEMKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:10:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53651 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934334Ab1JEMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:10:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 5
In-Reply-To: Your message of "Wed, 05 Oct 2011 19:37:50 +1100."
             <20111005193750.78af4ac777e9b69230d62375@canb.auug.org.au>
From: Valdis.Kletnieks@vt.edu
References: <20111005193750.78af4ac777e9b69230d62375@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317816559_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Oct 2011 08:09:19 -0400
Message-ID: <27222.1317816559@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E8C48F4.00F1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317816559_4646P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Oct 2011 19:37:50 +1100, Stephen Rothwell said:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ). 

So I managed to bodger up my local linux-next tree, decided to start from
scratch. Had a good 'git pull' of Linus's tree from yesterday, so I did a 'git
clone -l' of that. Then:

[/usr/src/linux-next] git remote add linux-next git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
[/usr/src/linux-next] git fetch linux-next
fatal: The remote end hung up unexpectedly

Am I pointing something in the wrong place, or does git need to be kicked at
the kernel.org end? It's apparently tree-specific - pulling Linus's tree from
git.kernel.org works just fine.


--==_Exmh_1317816559_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjEjvcC3lWbTT17ARArTKAJ9sSapFu2oFt2X/rsxkaZ/mSRjnAwCfaI7O
1xYQhgrWg9SruNnxCzlL0Jg=
=eNw6
-----END PGP SIGNATURE-----

--==_Exmh_1317816559_4646P--

