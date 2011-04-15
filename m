Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1DOTjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:39:18 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39593 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1DOTjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:39:16 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-04-14 - hangs during boot.
In-Reply-To: Your message of "Fri, 15 Apr 2011 21:06:22 +0200."
             <1302894382.2035.35.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org> <9629.1302879429@localhost> <6325.1302893631@localhost>
            <1302894382.2035.35.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302896313_5065P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Apr 2011 15:38:33 -0400
Message-ID: <9034.1302896313@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4DA89EBB.0063,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302896313_5065P
Content-Type: text/plain; charset=us-ascii

On Fri, 15 Apr 2011 21:06:22 +0200, Peter Zijlstra said:
> Does your kernel contain c2f7115e2e52a6c187b8c1f54f0e4970bb677be0 ? If
> not, mmotm is based on an old -next and should upgrade ;-)
 
https://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fsfr%2Flinux-next.git&a=search&h=HEAD&st=commit&s=c2f7115e2e52a6c187b8c1f54f0e4970bb677be0

says 'no match' against 20110415, so I think you and Steve Rothwell need to chat. ;)

--==_Exmh_1302896313_5065P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqJ65cC3lWbTT17ARAnmvAJ0fgXu86r03lTDsnHnOp+mm2kmDQwCgldhx
XeFEsdzFIm+VcVd5KduYWXo=
=cI6Q
-----END PGP SIGNATURE-----

--==_Exmh_1302896313_5065P--

